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

    @Scheduled(fixedRate = 5000)
    public void advanceOrders() {

        List<Order> orders = orderRepository.findAll();

        LocalDateTime now = LocalDateTime.now();

        for (Order order : orders) {

            if (order.getStatus() == null)
                continue;

            if (order.getStatus().equalsIgnoreCase("DELIVERED"))
                continue;

            if (order.getStatus().equalsIgnoreCase("CANCELLED"))
                continue;

            LocalDateTime created =
                    order.getCreatedAt() == null
                            ? now
                            : order.getCreatedAt();

            long elapsed =
                    Duration.between(created, now).getSeconds();

            String newStatus;

            if (elapsed < 15)
                newStatus = "ORDER_PLACED";

            else if (elapsed < 30)
                newStatus = "PAYMENT_PROCESSING";

            else if (elapsed < 60)
                newStatus = "RESTAURANT_ACCEPTED";

            else if (elapsed < 90)
                newStatus = "KITCHEN_PREPARING";

            else if (elapsed < 120)
                newStatus = "OUT_FOR_DELIVERY";

            else
                newStatus = "DELIVERED";

            if (!newStatus.equals(order.getStatus())) {

                order.setStatus(newStatus);

                switch (newStatus) {

                    case "PAYMENT_PROCESSING":
                        if (order.getPaymentProcessingAt() == null)
                            order.setPaymentProcessingAt(now);
                        break;

                    case "RESTAURANT_ACCEPTED":
                        if (order.getRestaurantAcceptedAt() == null)
                            order.setRestaurantAcceptedAt(now);
                        break;

                    case "KITCHEN_PREPARING":
                        if (order.getKitchenPreparingAt() == null)
                            order.setKitchenPreparingAt(now);
                        break;

                    case "OUT_FOR_DELIVERY":
                        if (order.getOutForDeliveryAt() == null)
                            order.setOutForDeliveryAt(now);
                        break;

                    case "DELIVERED":
                        if (order.getDeliveredAt() == null)
                            order.setDeliveredAt(now);

                        order.setPaymentStatus("PAID");
                        break;
                }

                orderRepository.save(order);

                log.info("Order {} -> {}", order.getId(), newStatus);
            }
        }
    }
}
