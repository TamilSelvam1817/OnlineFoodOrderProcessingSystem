package com.foodorder.backend.service;

import com.foodorder.backend.model.Order;
import com.foodorder.backend.repository.OrderRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderStatusSchedulerService {

    private static final Logger log = LoggerFactory.getLogger(OrderStatusSchedulerService.class);

    @Autowired
    private OrderRepository orderRepository;

    /**
     * Scheduled every 5 seconds to simulate realistic live order tracking timeline:
     * 0s  - 15s : ORDER_PLACED           (Customer CAN cancel)
     * 15s - 30s : PAYMENT_PROCESSING     (Customer CAN cancel)
     * 30s - 60s : RESTAURANT_ACCEPTED    (Customer CAN cancel)
     * 60s - 90s : KITCHEN_PREPARING     (Cancel button disappears!)
     * 90s - 120s: OUT_FOR_DELIVERY
     * >= 120s   : DELIVERED
     */
    @Scheduled(fixedRate = 5000)
    public void advanceActiveOrdersStatus() {
        List<Order> orders = orderRepository.findAll();
        LocalDateTime now = LocalDateTime.now();

        for (Order order : orders) {
            String currentStatus = order.getStatus() != null ? order.getStatus().toUpperCase() : "ORDER_PLACED";

            // If cancelled or delivered, immediately stop all transitions!
            if ("CANCELLED".equals(currentStatus) || "DELIVERED".equals(currentStatus)) {
                continue;
            }

            LocalDateTime created = order.getCreatedAt() != null ? order.getCreatedAt() : now;
            long elapsedSeconds = Duration.between(created, now).getSeconds();

            String targetStatus = currentStatus;
            if (elapsedSeconds >= 120) {
                targetStatus = "DELIVERED";
            } else if (elapsedSeconds >= 90) {
                targetStatus = "OUT_FOR_DELIVERY";
            } else if (elapsedSeconds >= 60) {
                targetStatus = "KITCHEN_PREPARING";
            } else if (elapsedSeconds >= 30) {
                targetStatus = "RESTAURANT_ACCEPTED";
            } else if (elapsedSeconds >= 15) {
                targetStatus = "PAYMENT_PROCESSING";
            } else {
                targetStatus = "ORDER_PLACED";
            }

            // Only update if target status represents an advancement
            if (!targetStatus.equals(currentStatus)) {
                order.setStatus(targetStatus);

                if (order.getOrderPlacedAt() == null) {
                    order.setOrderPlacedAt(created);
                }

                switch (targetStatus) {
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
                        if (!"Cash on Delivery".equalsIgnoreCase(order.getPaymentMethod()) && !"COD".equalsIgnoreCase(order.getPaymentMethod())) {
                            order.setPaymentStatus("PAID");
                        }
                        log.info("[OrderStatusScheduler] Order #{} reached DELIVERED", order.getId());
                        break;
                }

                orderRepository.save(order);
                log.info("[OrderStatusScheduler] Order #{} (elapsed {}s) status updated: {} -> {}", order.getId(), elapsedSeconds, currentStatus, targetStatus);
            }
        }
    }
}
