package com.foodorder.backend.service;

import com.foodorder.backend.model.KitchenTicket;
import com.foodorder.backend.repository.KitchenTicketRepository;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Random;

/**
 * Camunda Java Delegate for Kitchen Preparation.
 * Invoked by Camunda during Workflow Step 2.
 * Saves kitchen ticket with status READY and logs execution.
 */
@Component("kitchenService")
public class KitchenService implements JavaDelegate {

    private static final Logger log = LoggerFactory.getLogger(KitchenService.class);

    private static final String[] CHEFS = {"Chef Mario", "Chef Gordon", "Chef Julia", "Chef Ramsay", "Chef Sanjeev"};
    private static final Random random = new Random();

    @Autowired
    private KitchenTicketRepository kitchenTicketRepository;

    @Autowired
    private OrderStatusService orderStatusService;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        Long orderId = (Long) execution.getVariable("orderId");

        // Update order status to KITCHEN_PREPARING
        orderStatusService.updateOrderStatus(orderId, "KITCHEN_PREPARING");

        // Assign chef and save kitchen ticket with READY status
        String chef = CHEFS[random.nextInt(CHEFS.length)];
        KitchenTicket ticket = new KitchenTicket(orderId, "READY", chef);
        ticket.setCompletedAt(LocalDateTime.now());
        kitchenTicketRepository.save(ticket);

        // Set process variable
        execution.setVariable("kitchenStatus", "READY");

        // Log in exact required format
        log.info("[KitchenService] Order #{} - Food READY", orderId);
    }
}
