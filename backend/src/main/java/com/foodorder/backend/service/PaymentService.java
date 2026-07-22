package com.foodorder.backend.service;

import com.foodorder.backend.model.Payment;
import com.foodorder.backend.repository.PaymentRepository;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Random;
import java.util.UUID;

/**
 * Camunda Java Delegate for Payment Processing.
 * Invoked by Camunda during Workflow Step 1.
 * Mocks a success/fail calculation (80% success rate),
 * saves payment record to DB, and sets paymentSuccess variable.
 */
@Component("paymentService")
public class PaymentService implements JavaDelegate {

    private static final Logger log = LoggerFactory.getLogger(PaymentService.class);
    private static final Random random = new Random();

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private OrderStatusService orderStatusService;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        Long orderId = (Long) execution.getVariable("orderId");

        // Status progression is managed on a 90s live timeline by OrderStatusSchedulerService
        // orderStatusService.updateOrderStatus(orderId, "PAYMENT_PROCESSING");

        // Get order amount
        double amount = orderStatusService.getOrderAmount(orderId);

        // Payment processing for order (100% success rate for placed orders)
        boolean paymentSuccess = true;

        String transactionId = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String status = paymentSuccess ? "SUCCESS" : "FAILED";

        // Save payment record to DB
        Payment payment = new Payment(orderId, amount, status, transactionId);
        paymentRepository.save(payment);

        // Log in required format
        log.info("[PaymentService] Order #{} - Payment {}", orderId, status);

        // Set process variable for exclusive gateway decision
        execution.setVariable("paymentSuccess", paymentSuccess);
    }
}
