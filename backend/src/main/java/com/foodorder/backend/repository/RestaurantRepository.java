package com.foodorder.backend.repository;

import com.foodorder.backend.model.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface RestaurantRepository extends JpaRepository<Restaurant, Long> {
    List<Restaurant> findByOwnerId(Long ownerId);
    List<Restaurant> findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCase(String name, String description);
}
