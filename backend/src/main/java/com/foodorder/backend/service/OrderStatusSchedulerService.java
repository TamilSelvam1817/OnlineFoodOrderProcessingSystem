package com.foodorder.backend.service;

import com.foodorder.backend.model.Order;
import com.foodorder.backend.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderStatusSchedulerService {

    private final OrderRepository orderRepository;

    // In-memory epoch millis tracker for bulletproof stage durations immune to DB timezone offsets
    private final Map<Long, Long> stageStartTimes = new ConcurrentHashMap<>();

    /**
     * Sequential step-by-step stage transition scheduler running every 5 seconds.
     * Uses System.currentTimeMillis() epoch tracking for 100% accurate live timeline:
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
        long nowMillis = System.currentTimeMillis();
        LocalDateTime now = LocalDateTime.now();

        for (Order order : orders) {
            String currentStatus = order.getStatus();

            if (currentStatus == null) continue;
            if ("DELIVERED".equalsIgnoreCase(currentStatus)) {
                stageStartTimes.remove(order.getId());
                continue;
            }
            if ("CANCELLED".equalsIgnoreCase(currentStatus)) {
                stageStartTimes.remove(order.getId());
                continue;
            }

            String upper = currentStatus.toUpperCase();
            String newStatus = upper;

            // Initialize or retrieve stage start epoch millis for this order
            Long startMillis = stageStartTimes.computeIfAbsent(order.getId(), k -> nowMillis);
            long secondsInStage = Math.max(0, (nowMillis - startMillis) / 1000);

            if ("ORDER_PLACED".equals(upper) || "PLACED".equals(upper)) {
                if (secondsInStage >= 15) {
                    newStatus = "PAYMENT_PROCESSING";
                }
            } else if ("PAYMENT_PROCESSING".equals(upper)) {
                if (secondsInStage >= 15) {
                    newStatus = "RESTAURANT_ACCEPTED";
                }
            } else if ("RESTAURANT_ACCEPTED".equals(upper)) {
                // Wait 60 seconds before kitchen starts
                if (secondsInStage >= 60) {
                    newStatus = "KITCHEN_PREPARING";
                }
            } else if ("KITCHEN_PREPARING".equals(upper) || "KITCHEN_PREP".equals(upper)) {
                if (secondsInStage >= 30) {
                    newStatus = "OUT_FOR_DELIVERY";
                }
            } else if ("OUT_FOR_DELIVERY".equals(upper)) {
                if (secondsInStage >= 30) {
                    newStatus = "DELIVERED";
                }
            }

            if (!newStatus.equalsIgnoreCase(currentStatus)) {
                order.setStatus(newStatus);
                // Reset stage start time for the new stage
                stageStartTimes.put(order.getId(), nowMillis);

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
                        stageStartTimes.remove(order.getId());
                        break;
                }

                orderRepository.save(order);
                log.info("[OrderStatusScheduler] Order #{} ({}s in stage) advanced: {} -> {}", order.getId(), secondsInStage, currentStatus, newStatus);
            }
        }
    }
}
