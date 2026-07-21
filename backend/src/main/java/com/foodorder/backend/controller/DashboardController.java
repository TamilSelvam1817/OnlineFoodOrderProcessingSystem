package com.foodorder.backend.controller;

import com.foodorder.backend.model.*;
import com.foodorder.backend.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Autowired
    private FoodItemRepository foodItemRepository;

    @GetMapping("/admin")
    @PreAuthorize("hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> getAdminStats() {
        List<Order> allOrders = orderRepository.findAll();
        List<User> allUsers = userRepository.findAll();
        List<Restaurant> allRestaurants = restaurantRepository.findAll();

        long customersCount = allUsers.stream().filter(u -> "ROLE_CUSTOMER".equals(u.getRole())).count();
        long restaurantsCount = allRestaurants.size();
        long ordersCount = allOrders.size();
        double totalRevenue = allOrders.stream()
                .filter(o -> !"CANCELLED".equals(o.getStatus()))
                .mapToDouble(Order::getTotalAmount)
                .sum();

        // Calculate sales trends
        Map<String, Double> salesTrend = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        allOrders.stream()
                .filter(o -> !"CANCELLED".equals(o.getStatus()))
                .sorted(Comparator.comparing(Order::getCreatedAt))
                .forEach(o -> {
                    String date = o.getCreatedAt().format(formatter);
                    salesTrend.put(date, salesTrend.getOrDefault(date, 0.0) + o.getTotalAmount());
                });

        List<Map<String, Object>> chartData = new ArrayList<>();
        salesTrend.forEach((date, rev) -> {
            chartData.add(Map.of("date", date, "revenue", rev));
        });

        // Top selling foods mock calculation based on recent orders
        Map<String, Integer> foodSales = new HashMap<>();
        allOrders.forEach(o -> o.getItems().forEach(item -> {
            String name = item.getFoodItem().getName();
            foodSales.put(name, foodSales.getOrDefault(name, 0) + item.getQuantity());
        }));

        List<Map<String, Object>> topFoods = foodSales.entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .limit(5)
                .map(entry -> Map.of("name", entry.getKey(), "sales", (Object) entry.getValue()))
                .collect(Collectors.toList());

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalRevenue", totalRevenue);
        stats.put("ordersCount", ordersCount);
        stats.put("customersCount", customersCount);
        stats.put("restaurantsCount", restaurantsCount);
        stats.put("recentOrders", allOrders.stream()
                .sorted(Comparator.comparing(Order::getCreatedAt).reversed())
                .limit(5)
                .collect(Collectors.toList()));
        stats.put("salesChart", chartData);
        stats.put("topFoods", topFoods);

        return ResponseEntity.ok(stats);
    }

    @GetMapping("/restaurant/{restaurantId}")
    @PreAuthorize("hasAnyAuthority('ROLE_RESTAURANT', 'ROLE_ADMIN')")
    public ResponseEntity<?> getRestaurantStats(@PathVariable Long restaurantId) {
        Optional<Restaurant> restaurantOpt = restaurantRepository.findById(restaurantId);
        if (restaurantOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        List<Order> restaurantOrders = orderRepository.findByRestaurantIdOrderByCreatedAtDesc(restaurantId);
        long itemsCount = foodItemRepository.findByRestaurantId(restaurantId).size();

        long ordersCount = restaurantOrders.size();
        double totalRevenue = restaurantOrders.stream()
                .filter(o -> !"CANCELLED".equals(o.getStatus()))
                .mapToDouble(Order::getTotalAmount)
                .sum();

        // Group orders by status for dashboard summary
        Map<String, Long> statusCounts = restaurantOrders.stream()
                .collect(Collectors.groupingBy(Order::getStatus, Collectors.counting()));

        // Calculate sales trends
        Map<String, Double> salesTrend = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        restaurantOrders.stream()
                .filter(o -> !"CANCELLED".equals(o.getStatus()))
                .sorted(Comparator.comparing(Order::getCreatedAt))
                .forEach(o -> {
                    String date = o.getCreatedAt().format(formatter);
                    salesTrend.put(date, salesTrend.getOrDefault(date, 0.0) + o.getTotalAmount());
                });

        List<Map<String, Object>> chartData = new ArrayList<>();
        salesTrend.forEach((date, rev) -> {
            chartData.add(Map.of("date", date, "revenue", rev));
        });

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalRevenue", totalRevenue);
        stats.put("ordersCount", ordersCount);
        stats.put("itemsCount", itemsCount);
        stats.put("statusCounts", statusCounts);
        stats.put("recentOrders", restaurantOrders.stream().limit(5).collect(Collectors.toList()));
        stats.put("salesChart", chartData);

        return ResponseEntity.ok(stats);
    }
}
