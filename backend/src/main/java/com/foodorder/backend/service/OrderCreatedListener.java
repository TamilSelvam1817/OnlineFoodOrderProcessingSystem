package com.foodorder.backend.service;

import com.foodorder.backend.config.JmsConfig;
import org.camunda.bpm.engine.RuntimeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * JMS Listener that consumes messages from the 'order.created' ActiveMQ queue.
 * On receiving an order ID, it starts the Camunda BPMN workflow process.
 */
@Component
public class OrderCreatedListener {

    private static final Logger log = LoggerFactory.getLogger(OrderCreatedListener.class);

    @Autowired
    private RuntimeService runtimeService;

    @JmsListener(destination = JmsConfig.ORDER_CREATED_QUEUE)
    public void onOrderCreated(String orderIdStr) {
        try {
            Long orderId = Long.parseLong(orderIdStr.trim());
            log.info("[OrderService] Order #{} - Received from queue, starting Camunda workflow", orderId);

            // Start the BPMN process instance with orderId as a variable
            Map<String, Object> variables = new HashMap<>();
            variables.put("orderId", orderId);

            runtimeService.startProcessInstanceByKey("orderProcessing", orderId.toString(), variables);

            log.info("[OrderService] Order #{} - Camunda workflow started successfully", orderId);
        } catch (Exception e) {
            log.error("[OrderService] Failed to process order from queue: {} - Error: {}", orderIdStr, e.getMessage(), e);
        }
    }
}
