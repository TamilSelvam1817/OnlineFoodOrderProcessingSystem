package com.foodorder.backend.service;

import com.foodorder.backend.model.Delivery;
import com.foodorder.backend.repository.DeliveryRepository;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Random;

/**
 * Camunda Java Delegate for Delivery Processing.
 * Invoked by Camunda during Workflow Step 3.
 * Assigns a mock driver, saves delivery record to DB, and sets deliveryStatus variable.
 */
@Component("deliveryService")
public class DeliveryService implements JavaDelegate {

    private static final Logger log = LoggerFactory.getLogger(DeliveryService.class);

    private static final String[] DRIVERS = {"Raj Kumar", "Amit Singh", "Priya Sharma", "Vikram Patel", "Deepa Nair"};
    private static final Random random = new Random();

    @Autowired
    private DeliveryRepository deliveryRepository;

    @Autowired
    private OrderStatusService orderStatusService;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        Long orderId = (Long) execution.getVariable("orderId");

        // Update order status to OUT_FOR_DELIVERY
        orderStatusService.updateOrderStatus(orderId, "OUT_FOR_DELIVERY");

        // Assign a random mock driver
        String driver = DRIVERS[random.nextInt(DRIVERS.length)];

        // Create and save delivery record in DB
        Delivery delivery = new Delivery(orderId, driver, "DELIVERED");
        delivery.setDeliveredAt(LocalDateTime.now());
        deliveryRepository.save(delivery);

        // Set process variable
        execution.setVariable("deliveryStatus", "DELIVERED");

        // Log in exact required format
        log.info("[DeliveryService] Order #{} - DELIVERED", orderId);
    }
}
