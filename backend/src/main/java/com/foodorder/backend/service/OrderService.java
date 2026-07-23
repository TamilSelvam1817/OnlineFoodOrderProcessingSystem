package com.foodorder.backend.service;

import com.foodorder.backend.config.JmsConfig;
import com.foodorder.backend.dto.OrderResponse;
import com.foodorder.backend.model.*;
import com.foodorder.backend.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@Service
public class OrderService {

    private static final Logger log = LoggerFactory.getLogger(OrderService.class);

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Autowired
    private FoodItemRepository foodItemRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private InvoiceService invoiceService;

    @Autowired
    private JmsTemplate jmsTemplate;

    public OrderResponse createOrder(Map<String, Object> request, String email) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("Authenticated customer not found");
        }
        User customer = userOpt.get();

        List<Map<String, Object>> itemsReq = (List<Map<String, Object>>) request.get("items");
        if (itemsReq == null || itemsReq.isEmpty()) {
            throw new IllegalArgumentException("Order items list cannot be empty");
        }

        Object rawRestId = request.get("restaurantId");
        Long restaurantId = null;

        if (rawRestId != null && !rawRestId.toString().isBlank() && !rawRestId.toString().equals("undefined")) {
            try {
                restaurantId = Long.valueOf(rawRestId.toString());
            } catch (NumberFormatException e) {
                log.warn("[OrderService] Could not parse restaurantId: {}", rawRestId);
            }
        }

        if (restaurantId == null) {
            Object firstFoodIdObj = itemsReq.get(0).get("foodItemId");
            if (firstFoodIdObj != null) {
                try {
                    Long firstFoodId = Long.valueOf(firstFoodIdObj.toString());
                    Optional<FoodItem> fOpt = foodItemRepository.findById(firstFoodId);
                    if (fOpt.isPresent() && fOpt.get().getRestaurant() != null) {
                        restaurantId = fOpt.get().getRestaurant().getId();
                    }
                } catch (Exception e) {
                    log.warn("[OrderService] Error deriving restaurantId from foodItem: {}", e.getMessage());
                }
            }
        }

        if (restaurantId == null) {
            throw new IllegalArgumentException("restaurantId parameter is missing or invalid");
        }

        Optional<Restaurant> restaurantOpt = restaurantRepository.findById(restaurantId);
        if (restaurantOpt.isEmpty()) {
            throw new IllegalArgumentException("Restaurant with ID " + restaurantId + " not found in database");
        }
        Restaurant restaurant = restaurantOpt.get();

        List<OrderItem> orderItems = new ArrayList<>();
        double subtotal = 0;

        for (Map<String, Object> itemMap : itemsReq) {
            Object foodItemIdObj = itemMap.get("foodItemId");
            if (foodItemIdObj == null) {
                throw new IllegalArgumentException("foodItemId is required for each item");
            }
            Long foodItemId = Long.valueOf(foodItemIdObj.toString());
            int quantity = Integer.parseInt(itemMap.getOrDefault("quantity", 1).toString());

            Optional<FoodItem> foodItemOpt = foodItemRepository.findById(foodItemId);
            if (foodItemOpt.isEmpty()) {
                throw new IllegalArgumentException("Food item with ID " + foodItemId + " not found in database");
            }

            FoodItem foodItem = foodItemOpt.get();
            if (foodItem.getRestaurant() != null && !foodItem.getRestaurant().getId().equals(restaurant.getId())) {
                throw new IllegalArgumentException("Menu item '" + foodItem.getName() + "' does not belong to selected restaurant '" + restaurant.getName() + "'");
            }

            double dbPrice = foodItem.getPrice();
            OrderItem orderItem = new OrderItem();
            orderItem.setFoodItem(foodItem);
            orderItem.setQuantity(quantity);
            orderItem.setPrice(dbPrice);
            orderItems.add(orderItem);

            subtotal += dbPrice * quantity;
        }

        double deliveryCharge = 4.00;
        double gst = subtotal * 0.05;
        double finalTotal = subtotal + deliveryCharge + gst;

        String deliveryAddress = (String) request.get("deliveryAddress");
        if (deliveryAddress == null || deliveryAddress.isBlank()) {
            if (customer.getAddresses() != null && !customer.getAddresses().isEmpty()) {
                deliveryAddress = customer.getAddresses().get(0);
            } else {
                deliveryAddress = "Standard Delivery Address";
            }
        }

        boolean isPaymentFailed = false;
        Object failedObj = request.get("isPaymentFailed");
        if (failedObj != null && ("true".equalsIgnoreCase(failedObj.toString()) || Boolean.TRUE.equals(failedObj))) {
            isPaymentFailed = true;
        }

        String paymentMethod = (String) request.getOrDefault("paymentMethod", "UPI");
        String paymentStatus;
        String initialOrderStatus;

        if (isPaymentFailed) {
            paymentStatus = "FAILED";
            initialOrderStatus = "CANCELLED";
        } else if ("Cash on Delivery".equalsIgnoreCase(paymentMethod) || "COD".equalsIgnoreCase(paymentMethod)) {
            paymentStatus = "PENDING";
            initialOrderStatus = "ORDER_PLACED";
        } else {
            paymentStatus = "PAID";
            initialOrderStatus = "ORDER_PLACED";
        }

        String customerName = (String) request.getOrDefault("customerName", customer.getName());
        LocalDateTime now = LocalDateTime.now();

        Order order = new Order();
        order.setCustomer(customer);
        order.setCustomerName(customerName);
        order.setRestaurant(restaurant);
        order.setItems(orderItems);
        order.setTotalAmount(finalTotal);
        order.setDeliveryAddress(deliveryAddress);
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus(paymentStatus);
        order.setStatus(initialOrderStatus);
        order.setEstimatedDelivery("25-35 mins");
        order.setCreatedAt(now);
        order.setOrderPlacedAt(now);

        if (!isPaymentFailed) {
            order.setInvoiceGenerated(true);
        }

        Order saved = orderRepository.save(order);
        if (!isPaymentFailed) {
            saved.setInvoiceNumber("INV-" + String.format("%06d", saved.getId()));
            saved = orderRepository.save(saved);
        }

        log.info("[OrderService] Order #{} - Status: PLACED, Workflow Started", saved.getId());

        if (isPaymentFailed) {
            log.warn("[OrderService] Order #{} payment failed. No invoice generated and no restaurant notification sent.", saved.getId());
            return OrderResponse.fromOrder(saved);
        }

        // Async email delivery using fresh DB fetch
        final Long createdOrderId = saved.getId();
        final String recipientEmail = customer.getEmail();
        CompletableFuture.runAsync(() -> {
            try {
                invoiceService.generateAndSendInvoice(createdOrderId, recipientEmail);
            } catch (Exception e) {
                log.error("[OrderService] Async customer invoice email error for Order #{}: {}", createdOrderId, e.getMessage());
            }

            try {
                Optional<Order> freshOpt = orderRepository.findById(createdOrderId);
                if (freshOpt.isPresent()) {
                    emailService.sendOrderNotificationToRestaurant(freshOpt.get());
                }
            } catch (Exception e) {
                log.error("[OrderService] Async restaurant owner notification email error for Order #{}: {}", createdOrderId, e.getMessage());
            }
        });

        // Publish to ActiveMQ
        try {
            jmsTemplate.convertAndSend(JmsConfig.ORDER_CREATED_QUEUE, saved.getId().toString());
            log.info("[OrderService] Order #{} - Published to '{}' queue", saved.getId(), JmsConfig.ORDER_CREATED_QUEUE);
        } catch (Exception e) {
            log.error("[OrderService] Order #{} - Failed to publish to ActiveMQ: {}", saved.getId(), e.getMessage());
        }

        return OrderResponse.fromOrder(saved);
    }

    public List<OrderResponse> getOrdersForUser(String email) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("Customer not found");
        }
        User customer = userOpt.get();

        List<Order> rawOrders;
        if (customer.getRole().equals("ROLE_ADMIN")) {
            rawOrders = orderRepository.findAll(org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "createdAt"));
        } else if (customer.getRole().equals("ROLE_RESTAURANT")) {
            List<Restaurant> owned = restaurantRepository.findByOwnerId(customer.getId());
            rawOrders = new ArrayList<>();
            for (Restaurant r : owned) {
                rawOrders.addAll(orderRepository.findByRestaurantIdOrderByCreatedAtDesc(r.getId()));
            }
        } else {
            rawOrders = orderRepository.findByCustomerIdOrderByCreatedAtDesc(customer.getId());
        }

        return rawOrders.stream().map(OrderResponse::fromOrder).collect(Collectors.toList());
    }

    public Optional<OrderResponse> getOrderById(Long id) {
        return orderRepository.findById(id).map(OrderResponse::fromOrder);
    }

    public List<OrderResponse> getOrdersByRestaurantId(Long restaurantId) {
        return orderRepository.findByRestaurantIdOrderByCreatedAtDesc(restaurantId)
                .stream().map(OrderResponse::fromOrder).collect(Collectors.toList());
    }

    public OrderResponse cancelOrder(Long orderId, String reason, String email) {
        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isEmpty()) {
            throw new IllegalArgumentException("Order #" + orderId + " not found");
        }

        Order order = orderOpt.get();
        
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (!user.getRole().equals("ROLE_ADMIN") && (order.getCustomer() != null && !order.getCustomer().getId().equals(user.getId()))) {
                throw new IllegalArgumentException("Unauthorized to cancel Order #" + orderId);
            }
        }

        String currentStatus = order.getStatus() != null ? order.getStatus().toUpperCase() : "ORDER_PLACED";
        List<String> allowedStatuses =
            List.of("ORDER_PLACED","PLACED","PAYMENT_PROCESSING","RESTAURANT_ACCEPTED");

        if (!allowedStatuses.contains(currentStatus)) {
            throw new IllegalArgumentException("Order can no longer be cancelled because preparation has started.");
}

        order.setStatus("CANCELLED");
        String pMethod = order.getPaymentMethod() != null ? order.getPaymentMethod().toUpperCase() : "";
        boolean isCOD = pMethod.contains("CASH") || pMethod.contains("COD");
        if (isCOD || "PENDING".equalsIgnoreCase(order.getPaymentStatus())) {
            order.setPaymentStatus("CANCELLED");
        } else {
            order.setPaymentStatus("REFUNDED");
        }
        order.setCancellationReason(reason != null && !reason.isBlank() ? reason : "Customer requested cancellation");
        order.setCancelledAt(LocalDateTime.now());

        Order saved = orderRepository.save(order);
        log.info("[OrderService] Order #{} cancelled by {}. Reason: {}", saved.getId(), email, order.getCancellationReason());

        return OrderResponse.fromOrder(saved);
    }
}
