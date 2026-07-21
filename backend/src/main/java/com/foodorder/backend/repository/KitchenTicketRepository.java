package com.foodorder.backend.repository;

import com.foodorder.backend.model.KitchenTicket;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface KitchenTicketRepository extends JpaRepository<KitchenTicket, Long> {
    Optional<KitchenTicket> findByOrderId(Long orderId);
}
