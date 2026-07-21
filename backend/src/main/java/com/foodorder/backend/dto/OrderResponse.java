package com.foodorder.backend.dto;

import com.foodorder.backend.model.Order;
import com.foodorder.backend.model.OrderItem;
import com.foodorder.backend.model.Restaurant;

import java.time.LocalDateTime;
import java.util.List;

public class OrderResponse {
    private Long id;
    private String customerName;
    private String customerEmail;
    private Restaurant restaurant;
    private List<OrderItem> items;
    private double totalAmount;
    private String deliveryAddress;
    private String paymentMethod;
    private String paymentStatus;
    private String status;
    private String invoiceNumber;
    private boolean invoiceGenerated;
    private String estimatedDelivery;

    private LocalDateTime orderPlacedAt;
    private LocalDateTime paymentProcessingAt;
    private LocalDateTime restaurantAcceptedAt;
    private LocalDateTime kitchenPreparingAt;
    private LocalDateTime outForDeliveryAt;
    private LocalDateTime deliveredAt;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public OrderResponse() {}

    public static OrderResponse fromOrder(Order order) {
        if (order == null) return null;
        OrderResponse dto = new OrderResponse();
        dto.setId(order.getId());
        dto.setCustomerName(order.getCustomerName());
        if (order.getCustomer() != null) {
            dto.setCustomerEmail(order.getCustomer().getEmail());
        }
        dto.setRestaurant(order.getRestaurant());
        dto.setItems(order.getItems());
        dto.setTotalAmount(order.getTotalAmount());
        dto.setDeliveryAddress(order.getDeliveryAddress());
        dto.setPaymentMethod(order.getPaymentMethod());
        dto.setPaymentStatus(order.getPaymentStatus());
        dto.setStatus(order.getStatus());
        dto.setInvoiceNumber(order.getInvoiceNumber());
        dto.setInvoiceGenerated(order.isInvoiceGenerated());
        dto.setEstimatedDelivery(order.getEstimatedDelivery());

        dto.setOrderPlacedAt(order.getOrderPlacedAt() != null ? order.getOrderPlacedAt() : order.getCreatedAt());
        dto.setPaymentProcessingAt(order.getPaymentProcessingAt());
        dto.setRestaurantAcceptedAt(order.getRestaurantAcceptedAt());
        dto.setKitchenPreparingAt(order.getKitchenPreparingAt());
        dto.setOutForDeliveryAt(order.getOutForDeliveryAt());
        dto.setDeliveredAt(order.getDeliveredAt());

        dto.setCreatedAt(order.getCreatedAt());
        dto.setUpdatedAt(order.getUpdatedAt());
        return dto;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public Restaurant getRestaurant() { return restaurant; }
    public void setRestaurant(Restaurant restaurant) { this.restaurant = restaurant; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getInvoiceNumber() { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber) { this.invoiceNumber = invoiceNumber; }

    public boolean isInvoiceGenerated() { return invoiceGenerated; }
    public void setInvoiceGenerated(boolean invoiceGenerated) { this.invoiceGenerated = invoiceGenerated; }

    public String getEstimatedDelivery() { return estimatedDelivery; }
    public void setEstimatedDelivery(String estimatedDelivery) { this.estimatedDelivery = estimatedDelivery; }

    public LocalDateTime getOrderPlacedAt() { return orderPlacedAt; }
    public void setOrderPlacedAt(LocalDateTime orderPlacedAt) { this.orderPlacedAt = orderPlacedAt; }

    public LocalDateTime getPaymentProcessingAt() { return paymentProcessingAt; }
    public void setPaymentProcessingAt(LocalDateTime paymentProcessingAt) { this.paymentProcessingAt = paymentProcessingAt; }

    public LocalDateTime getRestaurantAcceptedAt() { return restaurantAcceptedAt; }
    public void setRestaurantAcceptedAt(LocalDateTime restaurantAcceptedAt) { this.restaurantAcceptedAt = restaurantAcceptedAt; }

    public LocalDateTime getKitchenPreparingAt() { return kitchenPreparingAt; }
    public void setKitchenPreparingAt(LocalDateTime kitchenPreparingAt) { this.kitchenPreparingAt = kitchenPreparingAt; }

    public LocalDateTime getOutForDeliveryAt() { return outForDeliveryAt; }
    public void setOutForDeliveryAt(LocalDateTime outForDeliveryAt) { this.outForDeliveryAt = outForDeliveryAt; }

    public LocalDateTime getDeliveredAt() { return deliveredAt; }
    public void setDeliveredAt(LocalDateTime deliveredAt) { this.deliveredAt = deliveredAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
