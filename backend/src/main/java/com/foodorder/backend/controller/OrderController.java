package com.foodorder.backend.controller;

import com.foodorder.backend.dto.OrderResponse;
import com.foodorder.backend.service.OrderService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private static final Logger log = LoggerFactory.getLogger(OrderController.class);

    @Autowired
    private OrderService orderService;

    @PostMapping
    public ResponseEntity<?> placeOrder(@RequestBody Map<String, Object> request) {
        try {
            String email = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            OrderResponse response = orderService.createOrder(request, email);
            return ResponseEntity.status(201).body(response);
        } catch (IllegalArgumentException e) {
            log.error("[OrderController] Error placing order: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            log.error("[OrderController] Internal error placing order: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("message", "An unexpected error occurred while placing order"));
        }
    }

    @GetMapping
    public ResponseEntity<?> getMyOrders() {
        try {
            String email = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            List<OrderResponse> responseList = orderService.getOrdersForUser(email);
            return ResponseEntity.ok(responseList);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(404).body(Map.of("message", e.getMessage()));
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getOrderById(@PathVariable Long id) {
        Optional<OrderResponse> orderOpt = orderService.getOrderById(id);
        if (orderOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(orderOpt.get());
    }

    @GetMapping("/restaurant/{restaurantId}")
    public ResponseEntity<List<OrderResponse>> getRestaurantOrders(@PathVariable Long restaurantId) {
        return ResponseEntity.ok(orderService.getOrdersByRestaurantId(restaurantId));
    }
}
