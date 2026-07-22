package com.foodorder.backend.service;

import com.foodorder.backend.model.Order;
import com.foodorder.backend.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderStatusSchedulerService {

    private final OrderRepository orderRepository;

    /**
     * Sequential step-by-step stage transition scheduler running every 5 seconds.
     * Guarantees exact realistic order lifecycle:
     * 1. ORDER_PLACED        (15s duration) -> Cancel button ACTIVE
     * 2. PAYMENT_PROCESSING   (15s duration) -> Cancel button ACTIVE
     * 3. RESTAURANT_ACCEPTED  (30s duration) -> Cancel button ACTIVE
     * 4. KITCHEN_PREPARING    (30s duration) -> Cancel button DISAPPEARS
     * 5. OUT_FOR_DELIVERY     (30s duration)
     * 6. DELIVERED            (Final stage)
     */
    @Scheduled(fixedRate = 5000)
    public void advanceOrders() {
        List<Order> orders = orderRepository.findAll();
        LocalDateTime now = LocalDateTime.now();

        for (Order order : orders) {
            String currentStatus = order.getStatus();

            if (currentStatus == null) continue;
            if ("DELIVERED".equalsIgnoreCase(currentStatus)) continue;
            if ("CANCELLED".equalsIgnoreCase(currentStatus)) continue;

            String upper = currentStatus.toUpperCase();
            String newStatus = upper;

            if ("ORDER_PLACED".equals(upper) || "PLACED".equals(upper)) {
                LocalDateTime start = order.getOrderPlacedAt() != null ? order.getOrderPlacedAt() : order.getCreatedAt();
                if (start == null) {
                    order.setOrderPlacedAt(now);
                    orderRepository.save(order);
                    start = now;
                }
                long secondsInStage = Math.max(0, Duration.between(start, now).getSeconds());
                if (secondsInStage >= 15) {
                    newStatus = "PAYMENT_PROCESSING";
                }
            } else if ("PAYMENT_PROCESSING".equals(upper)) {
                LocalDateTime start = order.getPaymentProcessingAt();
                if (start == null) {
                    order.setPaymentProcessingAt(now);
                    orderRepository.save(order);
                    start = now;
                }
                long secondsInStage = Math.max(0, Duration.between(start, now).getSeconds());
                if (secondsInStage >= 15) {
                    newStatus = "RESTAURANT_ACCEPTED";
                }
            } else if ("RESTAURANT_ACCEPTED".equals(upper)) {
                LocalDateTime start = order.getRestaurantAcceptedAt();
                if (start == null) {
                    order.setRestaurantAcceptedAt(now);
                    orderRepository.save(order);
                    start = now;
                }
                long secondsInStage = Math.max(0, Duration.between(start, now).getSeconds());
                if (secondsInStage >= 30) {
                    newStatus = "KITCHEN_PREPARING";
                }
            } else if ("KITCHEN_PREPARING".equals(upper) || "KITCHEN_PREP".equals(upper)) {
                LocalDateTime start = order.getKitchenPreparingAt();
                if (start == null) {
                    order.setKitchenPreparingAt(now);
                    orderRepository.save(order);
                    start = now;
                }
                long secondsInStage = Math.max(0, Duration.between(start, now).getSeconds());
                if (secondsInStage >= 30) {
                    newStatus = "OUT_FOR_DELIVERY";
                }
            } else if ("OUT_FOR_DELIVERY".equals(upper)) {
                LocalDateTime start = order.getOutForDeliveryAt();
                if (start == null) {
                    order.setOutForDeliveryAt(now);
                    orderRepository.save(order);
                    start = now;
                }
                long secondsInStage = Math.max(0, Duration.between(start, now).getSeconds());
                if (secondsInStage >= 30) {
                    newStatus = "DELIVERED";
                }
            }

            if (!newStatus.equalsIgnoreCase(currentStatus)) {
                order.setStatus(newStatus);

                switch (newStatus) {
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
                        break;
                }

                orderRepository.save(order);
                log.info("[OrderStatusScheduler] Order #{} stage advanced: {} -> {}", order.getId(), currentStatus, newStatus);
            }
        }
    }
}
