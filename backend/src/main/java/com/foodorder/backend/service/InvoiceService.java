package com.foodorder.backend.service;

import com.foodorder.backend.model.Order;
import com.foodorder.backend.repository.OrderRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class InvoiceService {

    private static final Logger log = LoggerFactory.getLogger(InvoiceService.class);

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private InvoiceEmailService invoiceEmailService;

    @Autowired
    private EmailService emailService;

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional(readOnly = true)
    public boolean generateAndSendInvoice(Long orderId) {
        return generateAndSendInvoice(orderId, null);
    }

    /**
     * Always reloads the latest Order entity directly from the database,
     * ensuring fresh state (DELIVERED, PAID) before PDF generation and email dispatch.
     */
    @Transactional(readOnly = true)
    public boolean generateAndSendInvoice(Long orderId, String fallbackEmail) {
        log.info("[InvoiceService] Loading latest Order from database for Order #{}", orderId);

        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isEmpty()) {
            log.error("[InvoiceService] ❌ Order #{} not found in database", orderId);
            return false;
        }

        Order latestOrder = orderOpt.get();
        try {
            entityManager.refresh(latestOrder);
        } catch (Exception e) {
            log.debug("[InvoiceService] Entity refresh note: {}", e.getMessage());
        }

        // Business logic check: If order status is DELIVERED, ensure payment status is PAID
        if ("DELIVERED".equalsIgnoreCase(latestOrder.getStatus())) {
            latestOrder.setPaymentStatus("PAID");
        }

        log.info("[InvoiceService] Latest Order Status = {}", latestOrder.getStatus());
        log.info("[InvoiceService] Latest Payment Status = {}", latestOrder.getPaymentStatus());

        log.info("[InvoiceService] Generating PDF for Order #{}", orderId);
        byte[] pdfBytes = invoiceEmailService.generateInvoicePdf(latestOrder);

        if (pdfBytes == null || pdfBytes.length == 0) {
            log.error("[InvoiceService] ❌ Failed to generate PDF bytes for Order #{}", orderId);
            return false;
        }

        log.info("[InvoiceService] Sending Email for Order #{} to recipient or fallback ({})", orderId, fallbackEmail);
        boolean sent = emailService.sendInvoiceToCustomer(latestOrder, pdfBytes, fallbackEmail);

        if (sent) {
            log.info("[InvoiceService] ✅ Invoice Email Sent Successfully for Order #{}", orderId);
        } else {
            log.warn("[InvoiceService] ⚠️ Invoice Email dispatch returned false for Order #{}", orderId);
        }

        return sent;
    }
}
