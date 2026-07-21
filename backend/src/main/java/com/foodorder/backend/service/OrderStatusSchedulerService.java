package com.foodorder.backend.service;

import com.foodorder.backend.model.Order;
import com.foodorder.backend.repository.OrderRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderStatusSchedulerService {

    private static final Logger log = LoggerFactory.getLogger(OrderStatusSchedulerService.class);

    @Autowired
    private OrderRepository orderRepository;

    @Scheduled(fixedRate = 5000)
    public void advanceActiveOrdersStatus() {
        List<Order> orders = orderRepository.findAll();
        for (Order order : orders) {
            String currentStatus = order.getStatus();
            if (currentStatus == null || currentStatus.equalsIgnoreCase("DELIVERED") || currentStatus.equalsIgnoreCase("CANCELLED")) {
                continue;
            }

            String nextStatus = getNextStatus(currentStatus);
            if (nextStatus != null && !nextStatus.equalsIgnoreCase(currentStatus)) {
                order.setStatus(nextStatus);
                LocalDateTime now = LocalDateTime.now();

                if (order.getOrderPlacedAt() == null) {
                    order.setOrderPlacedAt(order.getCreatedAt() != null ? order.getCreatedAt() : now);
                }

                switch (nextStatus.toUpperCase()) {
                    case "PAYMENT_PROCESSING":
                        if (order.getPaymentProcessingAt() == null) order.setPaymentProcessingAt(now);
                        break;
                    case "RESTAURANT_ACCEPTED":
                        if (order.getRestaurantAcceptedAt() == null) order.setRestaurantAcceptedAt(now);
                        break;
                    case "KITCHEN_PREPARING":
                        if (order.getKitchenPreparingAt() == null) order.setKitchenPreparingAt(now);
                        break;
                    case "OUT_FOR_DELIVERY":
                        if (order.getOutForDeliveryAt() == null) order.setOutForDeliveryAt(now);
                        break;
                    case "DELIVERED":
                        if (order.getDeliveredAt() == null) order.setDeliveredAt(now);
                        order.setPaymentStatus("PAID");
                        log.info("[OrderStatusScheduler] Order #{} DELIVERED -> Payment status set to PAID", order.getId());
                        break;
                }

                orderRepository.save(order);
                log.info("[OrderStatusScheduler] Order #{} status advanced: {} -> {}", order.getId(), currentStatus, nextStatus);
            }
        }
    }

    private String getNextStatus(String currentStatus) {
        switch (currentStatus.toUpperCase()) {
            case "ORDER_PLACED":
            case "PLACED":
                return "PAYMENT_PROCESSING";
            case "PAYMENT_PROCESSING":
                return "RESTAURANT_ACCEPTED";
            case "RESTAURANT_ACCEPTED":
            case "KITCHEN_PREP":
                return "KITCHEN_PREPARING";
            case "KITCHEN_PREPARING":
                return "OUT_FOR_DELIVERY";
            case "OUT_FOR_DELIVERY":
                return "DELIVERED";
            default:
                return null;
        }
    }
}
