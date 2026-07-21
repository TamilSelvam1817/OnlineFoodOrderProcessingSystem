package com.foodorder.backend.service;

import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Camunda Java Delegate to cancel an order on payment failure.
 * Handles graceful failure by updating order status to CANCELLED.
 */
@Component("orderCancelledDelegate")
public class OrderCancelledDelegate implements JavaDelegate {

    private static final Logger log = LoggerFactory.getLogger(OrderCancelledDelegate.class);

    @Autowired
    private OrderStatusService orderStatusService;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        Long orderId = (Long) execution.getVariable("orderId");
        orderStatusService.updateOrderStatus(orderId, "CANCELLED");
        log.info("[OrderService] Order #{} - CANCELLED (Payment Failed)", orderId);
    }
}
