package com.foodorder.backend.service;

import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Camunda Java Delegate to mark an order as DELIVERED.
 * Called as the final success step in the BPMN workflow.
 */
@Component("orderDeliveredDelegate")
public class OrderDeliveredDelegate implements JavaDelegate {

    private static final Logger log = LoggerFactory.getLogger(OrderDeliveredDelegate.class);

    @Autowired
    private OrderStatusService orderStatusService;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        Long orderId = (Long) execution.getVariable("orderId");
        orderStatusService.updateOrderStatus(orderId, "DELIVERED");
        log.info("[OrderService] Order #{} - Workflow COMPLETE", orderId);
    }
}
