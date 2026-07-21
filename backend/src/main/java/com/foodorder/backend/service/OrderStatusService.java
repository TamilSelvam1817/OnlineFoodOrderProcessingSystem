package com.foodorder.backend.service;

import com.foodorder.backend.model.Order;
import com.foodorder.backend.repository.OrderRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class OrderStatusService {

    private static final Logger log = LoggerFactory.getLogger(OrderStatusService.class);

    @Autowired
    private OrderRepository orderRepository;

    /**
     * Updates the status of an order and records the exact timestamp for the matching stage.
     */
    public void updateOrderStatus(Long orderId, String newStatus) {
        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            String upper = newStatus.toUpperCase();
            LocalDateTime now = LocalDateTime.now();

            if (order.getOrderPlacedAt() == null) {
                order.setOrderPlacedAt(order.getCreatedAt() != null ? order.getCreatedAt() : now);
            }

            switch (upper) {
                case "PAYMENT_PROCESSING":
                    order.setStatus("PAYMENT_PROCESSING");
                    if (order.getPaymentProcessingAt() == null) order.setPaymentProcessingAt(now);
                    break;
                case "RESTAURANT_ACCEPTED":
                    order.setStatus("RESTAURANT_ACCEPTED");
                    if (order.getRestaurantAcceptedAt() == null) order.setRestaurantAcceptedAt(now);
                    break;
                case "KITCHEN_PREPARING":
                case "KITCHEN_PREP":
                    order.setStatus("KITCHEN_PREPARING");
                    if (order.getKitchenPreparingAt() == null) order.setKitchenPreparingAt(now);
                    break;
                case "OUT_FOR_DELIVERY":
                    order.setStatus("OUT_FOR_DELIVERY");
                    if (order.getOutForDeliveryAt() == null) order.setOutForDeliveryAt(now);
                    break;
                case "DELIVERED":
                    order.setStatus("DELIVERED");
                    if (order.getDeliveredAt() == null) order.setDeliveredAt(now);
                    order.setPaymentStatus("PAID");
                    break;
                case "CANCELLED":
                    order.setStatus("CANCELLED");
                    order.setPaymentStatus("FAILED");
                    break;
                default:
                    order.setStatus(upper);
                    break;
            }

            orderRepository.save(order);
            log.info("[OrderService] Order #{} - Status updated to {}", orderId, order.getStatus());
        } else {
            log.error("[OrderService] Order #{} - NOT FOUND, cannot update status to {}", orderId, newStatus);
        }
    }

    /**
     * Retrieves the total amount for an order (used by PaymentService).
     */
    public double getOrderAmount(Long orderId) {
        return orderRepository.findById(orderId)
                .map(Order::getTotalAmount)
                .orElse(0.0);
    }
}
