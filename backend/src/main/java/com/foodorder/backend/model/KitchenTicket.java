package com.foodorder.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "kitchen_tickets")
public class KitchenTicket {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long orderId;

    @Column(nullable = false)
    private String status; // PREPARING, READY

    private String assignedChef;

    private LocalDateTime createdAt = LocalDateTime.now();

    private LocalDateTime completedAt;

    public KitchenTicket() {}

    public KitchenTicket(Long orderId, String status, String assignedChef) {
        this.orderId = orderId;
        this.status = status;
        this.assignedChef = assignedChef;
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAssignedChef() { return assignedChef; }
    public void setAssignedChef(String assignedChef) { this.assignedChef = assignedChef; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(LocalDateTime completedAt) { this.completedAt = completedAt; }
}
