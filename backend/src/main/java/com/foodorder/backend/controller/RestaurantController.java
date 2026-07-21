package com.foodorder.backend.controller;

import com.foodorder.backend.model.FoodItem;
import com.foodorder.backend.model.Restaurant;
import com.foodorder.backend.repository.FoodItemRepository;
import com.foodorder.backend.repository.RestaurantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/restaurants")
public class RestaurantController {

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Autowired
    private FoodItemRepository foodItemRepository;

    @GetMapping
    public ResponseEntity<List<Restaurant>> getAllRestaurants(@RequestParam(required = false) String search) {
        if (search != null && !search.trim().isEmpty()) {
            return ResponseEntity.ok(restaurantRepository.findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCase(search, search));
        }
        return ResponseEntity.ok(restaurantRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getRestaurantById(@PathVariable Long id) {
        Optional<Restaurant> restaurantOpt = restaurantRepository.findById(id);
        if (restaurantOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(restaurantOpt.get());
    }

    @PostMapping
    @PreAuthorize("hasAnyAuthority('ROLE_RESTAURANT', 'ROLE_ADMIN')")
    public ResponseEntity<Restaurant> createRestaurant(@RequestBody Restaurant restaurant) {
        Restaurant saved = restaurantRepository.save(restaurant);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('ROLE_RESTAURANT', 'ROLE_ADMIN')")
    public ResponseEntity<?> updateRestaurant(@PathVariable Long id, @RequestBody Restaurant details) {
        Optional<Restaurant> restaurantOpt = restaurantRepository.findById(id);
        if (restaurantOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        Restaurant restaurant = restaurantOpt.get();
        restaurant.setName(details.getName());
        restaurant.setDescription(details.getDescription());
        restaurant.setImageUrl(details.getImageUrl());
        restaurant.setOpeningHours(details.getOpeningHours());
        restaurant.setDeliveryTime(details.getDeliveryTime());
        
        Restaurant updated = restaurantRepository.save(restaurant);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('ROLE_RESTAURANT', 'ROLE_ADMIN')")
    public ResponseEntity<?> deleteRestaurant(@PathVariable Long id) {
        if (!restaurantRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        restaurantRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }

    // Menu Management APIs
    @GetMapping("/{id}/menu")
    public ResponseEntity<List<FoodItem>> getRestaurantMenu(@PathVariable Long id) {
        return ResponseEntity.ok(foodItemRepository.findByRestaurantId(id));
    }

    @PostMapping("/{id}/menu")
    @PreAuthorize("hasAnyAuthority('ROLE_RESTAURANT', 'ROLE_ADMIN')")
    public ResponseEntity<?> addMenuItem(@PathVariable Long id, @RequestBody FoodItem foodItem) {
        Optional<Restaurant> restaurantOpt = restaurantRepository.findById(id);
        if (restaurantOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        foodItem.setRestaurant(restaurantOpt.get());
        FoodItem saved = foodItemRepository.save(foodItem);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}/menu/{itemId}")
    @PreAuthorize("hasAnyAuthority('ROLE_RESTAURANT', 'ROLE_ADMIN')")
    public ResponseEntity<?> updateMenuItem(@PathVariable Long id, @PathVariable Long itemId, @RequestBody FoodItem details) {
        Optional<FoodItem> foodItemOpt = foodItemRepository.findById(itemId);
        if (foodItemOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        FoodItem foodItem = foodItemOpt.get();
        foodItem.setName(details.getName());
        foodItem.setDescription(details.getDescription());
        foodItem.setPrice(details.getPrice());
        foodItem.setImageUrl(details.getImageUrl());
        foodItem.setCategory(details.getCategory());
        foodItem.setVeg(details.isVeg());
        foodItem.setAvailable(details.isAvailable());

        FoodItem updated = foodItemRepository.save(foodItem);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}/menu/{itemId}")
    @PreAuthorize("hasAnyAuthority('ROLE_RESTAURANT', 'ROLE_ADMIN')")
    public ResponseEntity<?> deleteMenuItem(@PathVariable Long id, @PathVariable Long itemId) {
        if (!foodItemRepository.existsById(itemId)) {
            return ResponseEntity.notFound().build();
        }
        foodItemRepository.deleteById(itemId);
        return ResponseEntity.ok().build();
    }
}
