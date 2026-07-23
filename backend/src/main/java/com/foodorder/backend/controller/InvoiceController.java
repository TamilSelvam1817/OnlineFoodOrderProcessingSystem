package com.foodorder.backend.controller;

import com.foodorder.backend.model.GoogleAccount;
import com.foodorder.backend.model.Order;
import com.foodorder.backend.model.User;
import com.foodorder.backend.repository.GoogleAccountRepository;
import com.foodorder.backend.repository.OrderRepository;
import com.foodorder.backend.repository.UserRepository;
import com.foodorder.backend.service.GmailService;
import com.foodorder.backend.service.InvoiceService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;

@RestController
public class InvoiceController {

    private static final Logger log = LoggerFactory.getLogger(InvoiceController.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private GoogleAccountRepository googleAccountRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private InvoiceService invoiceService;

    @Autowired
    private GmailService gmailService;

    @PostMapping({"/api/orders/{orderId}/invoice", "/api/invoice/send"})
    public ResponseEntity<?> sendInvoice(@PathVariable(required = false) Long orderId,
                                         @RequestBody(required = false) Map<String, Object> payload) {
        Long targetOrderId = orderId;
        if (targetOrderId == null && payload != null && payload.containsKey("orderId")) {
            targetOrderId = Long.valueOf(payload.get("orderId").toString());
        }

        if (targetOrderId == null) {
            log.error("[InvoiceController] ❌ Error: orderId parameter is required");
            return ResponseEntity.badRequest().body(Map.of("message", "orderId parameter is required"));
        }

        log.info("[InvoiceController] Invoice request received for Order #{}", targetOrderId);

        final Long idToProcess = targetOrderId;
        String currentEmail = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        // Fire invoice email dispatch asynchronously with fallback user email
        CompletableFuture.runAsync(() -> {
            try {
                boolean success = invoiceService.generateAndSendInvoice(idToProcess, currentEmail);
                log.info("[InvoiceController] Central invoice email dispatch result for Order #{}: {}", idToProcess, success);

                // Optional: Also send via Google OAuth Gmail API if connected
                if (currentEmail != null && !currentEmail.equals("anonymousUser")) {
                    Optional<User> userOpt = userRepository.findByEmail(currentEmail);
                    if (userOpt.isPresent()) {
                        Optional<GoogleAccount> accountOpt = googleAccountRepository.findByUser(userOpt.get());
                        if (accountOpt.isPresent() && accountOpt.get().getAccessToken() != null) {
                            Optional<Order> orderOpt = orderRepository.findById(idToProcess);
                            if (orderOpt.isPresent()) {
                                try {
                                    gmailService.sendInvoiceViaGmail(orderOpt.get(), accountOpt.get());
                                    log.info("[InvoiceController] Sent invoice via Google OAuth Gmail API for Order #{}", idToProcess);
                                } catch (Exception gEx) {
                                    log.warn("[InvoiceController] Optional OAuth Gmail delivery skipped: {}", gEx.getMessage());
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                log.error("[InvoiceController] ❌ Exception during async invoice processing for Order #{}: {}", idToProcess, e.getMessage(), e);
            }
        });

        return ResponseEntity.ok(Map.of("message", "Invoice PDF generation & email delivery started!"));
    }
}
