package com.foodorder.backend.service;

import com.foodorder.backend.model.*;
import com.foodorder.backend.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;
import java.util.Arrays;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Autowired
    private FoodItemRepository foodItemRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        if (userRepository.count() > 0) return; // DB already populated

        // 1. Create Users
        User customer = new User();
        customer.setName("John Doe");
        customer.setEmail("customer@food.com");
        customer.setPassword(passwordEncoder.encode("password"));
        customer.setRole("ROLE_CUSTOMER");
        customer.setPhone("+1 (555) 234-5678");
        customer.setAddresses(Arrays.asList("123 Food Street, Foodville", "456 Tech Lane, Silicon Valley"));
        userRepository.save(customer);

        User owner = new User();
        owner.setName("Chef Mario");
        owner.setEmail("owner@food.com");
        owner.setPassword(passwordEncoder.encode("password"));
        owner.setRole("ROLE_RESTAURANT");
        owner.setPhone("+1 (555) 987-6543");
        userRepository.save(owner);

        User admin = new User();
        admin.setName("Admin Manager");
        admin.setEmail("admin@food.com");
        admin.setPassword(passwordEncoder.encode("password"));
        admin.setRole("ROLE_ADMIN");
        userRepository.save(admin);

        // 2. Create Restaurants (IDs 1 to 6)
        Restaurant rest1 = new Restaurant();
        rest1.setName("Royal Spice Biryani");
        rest1.setDescription("Authentic Hyderabadi Biryani, Kebabs, and Mughlai delicacies crafted with secret aromatic spices.");
        rest1.setImageUrl("https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&q=80");
        rest1.setRating(4.8);
        rest1.setDeliveryTime(25);
        rest1.setOpeningHours("11:00 AM - 11:00 PM");
        rest1.setOwnerId(owner.getId());
        rest1.setOwnerName("Chef Mario");
        rest1.setOwnerEmail("owner@food.com");
        rest1.setPhone("+1 (555) 111-2222");
        rest1.setAddress("124 Park Street, Downtown");
        rest1.setActive(true);
        restaurantRepository.save(rest1);

        Restaurant rest2 = new Restaurant();
        rest2.setName("Pizzeria Bella Ciao");
        rest2.setDescription("Hand-tossed Neapolitan pizzas baked in authentic wood-fired stone ovens with imported Mozzarella.");
        rest2.setImageUrl("https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&q=80");
        rest2.setRating(4.7);
        rest2.setDeliveryTime(20);
        rest2.setOpeningHours("10:00 AM - 10:00 PM");
        rest2.setOwnerId(owner.getId());
        rest2.setOwnerName("Chef Luigi");
        rest2.setOwnerEmail("luigi@bellaciao.com");
        rest2.setPhone("+1 (555) 222-3333");
        rest2.setAddress("45 Tech Hub Blvd, Cybercity");
        rest2.setActive(true);
        restaurantRepository.save(rest2);

        Restaurant rest3 = new Restaurant();
        rest3.setName("The Burger Joint");
        rest3.setDescription("Juicy smashed Angus beef burgers, crispy golden fries, and artisanal thick milkshakes.");
        rest3.setImageUrl("https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80");
        rest3.setRating(4.6);
        rest3.setDeliveryTime(18);
        rest3.setOpeningHours("12:00 PM - 10:30 PM");
        rest3.setOwnerId(owner.getId());
        rest3.setOwnerName("Gordon Ramsay");
        rest3.setOwnerEmail("gordon@burgerjoint.com");
        rest3.setPhone("+1 (555) 333-4444");
        rest3.setAddress("88 Ocean Drive, Marina");
        rest3.setActive(true);
        restaurantRepository.save(rest3);

        Restaurant rest4 = new Restaurant();
        rest4.setName("Sakura Sushi Bar");
        rest4.setDescription("Fresh sashimi grade salmon, dragon rolls, steaming ramen bowls, and traditional bento boxes.");
        rest4.setImageUrl("https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=600&q=80");
        rest4.setRating(4.9);
        rest4.setDeliveryTime(30);
        rest4.setOpeningHours("12:00 PM - 11:00 PM");
        rest4.setOwnerId(owner.getId());
        rest4.setOwnerName("Kenji Sato");
        rest4.setOwnerEmail("kenji@sakurasushi.com");
        rest4.setPhone("+1 (555) 444-5555");
        rest4.setAddress("12 Green Avenue, West End");
        rest4.setActive(true);
        restaurantRepository.save(rest4);

        Restaurant rest5 = new Restaurant();
        rest5.setName("Sweet Tooth Dessert Bar");
        rest5.setDescription("Decadent chocolate lava cakes, Belgian waffles, French macarons, and gourmet gelato scoops.");
        rest5.setImageUrl("https://images.unsplash.com/photo-1551024601-bec78aea704b?w=600&q=80");
        rest5.setRating(4.8);
        rest5.setDeliveryTime(15);
        rest5.setOpeningHours("10:00 AM - 11:30 PM");
        rest5.setOwnerId(owner.getId());
        rest5.setOwnerName("Pierre Hermé");
        rest5.setOwnerEmail("pierre@sweettooth.com");
        rest5.setPhone("+1 (555) 555-6666");
        rest5.setAddress("77 Sugar Lane, City Center");
        rest5.setActive(true);
        restaurantRepository.save(rest5);

        Restaurant rest6 = new Restaurant();
        rest6.setName("Taco Fiesta Express");
        rest6.setDescription("Mexican street tacos, loaded cheesy nachos, spicy burritos, and freshly whipped churros.");
        rest6.setImageUrl("https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&q=80");
        rest6.setRating(4.5);
        rest6.setDeliveryTime(22);
        rest6.setOpeningHours("11:00 AM - 10:00 PM");
        rest6.setOwnerId(owner.getId());
        rest6.setOwnerName("Carlos Rodriguez");
        rest6.setOwnerEmail("carlos@tacofiesta.com");
        rest6.setPhone("+1 (555) 666-7777");
        rest6.setAddress("302 Sunset Blvd");
        rest6.setActive(true);
        restaurantRepository.save(rest6);

        // 3. Populate Menus
        FoodItem f101 = new FoodItem(null, "Hyderabadi Chicken Dum Biryani", "Slow-cooked fragrant basmati rice layered with succulent chicken.", 14.99, "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&q=80", "Biryani", false, true, rest1);
        FoodItem f102 = new FoodItem(null, "Special Veg Paneer Biryani", "Charcoal grilled cottage cheese cubes with saffron basmati rice.", 12.99, "https://images.unsplash.com/photo-1642821373181-696a54913e93?w=500&q=80", "Biryani", true, true, rest1);
        FoodItem f103 = new FoodItem(null, "Murg Tandoori Kebab (Half)", "Roasted spiced chicken cooked over clay oven.", 9.99, "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=500&q=80", "Starters", false, true, rest1);
        FoodItem f104 = new FoodItem(null, "Butter Naan Basket (3 pcs)", "Freshly baked soft tandoori bread with garlic butter.", 3.49, "https://images.unsplash.com/photo-1626074353765-517a681e40be?w=500&q=80", "Breads", true, true, rest1);
        foodItemRepository.saveAll(Arrays.asList(f101, f102, f103, f104));

        FoodItem f201 = new FoodItem(null, "Margherita Pepperoni Deluxe Pizza", "Double layer pepperoni with buffalo mozzarella.", 16.49, "https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=500&q=80", "Pizza", false, true, rest2);
        FoodItem f202 = new FoodItem(null, "Truffle Mushroom & Spinach Pizza", "White base pizza with portobello mushrooms and truffle oil.", 15.99, "https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500&q=80", "Pizza", true, true, rest2);
        FoodItem f203 = new FoodItem(null, "Cheesy Garlic Bread Sticks", "Oven baked bread coated in garlic butter and mozzarella.", 5.99, "https://images.unsplash.com/photo-1619535860434-ba1d8fa12536?w=500&q=80", "Starters", true, true, rest2);
        foodItemRepository.saveAll(Arrays.asList(f201, f202, f203));

        FoodItem f301 = new FoodItem(null, "Double Bacon Smash Cheeseburger", "Two smashed beef patties, cheddar cheese, and crispy bacon.", 11.99, "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80", "Burger", false, true, rest3);
        FoodItem f302 = new FoodItem(null, "Crispy Black Bean Veggie Burger", "Spicy black bean patty with avocado and chipotle mayo.", 9.99, "https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?w=500&q=80", "Burger", true, true, rest3);
        FoodItem f303 = new FoodItem(null, "Truffle Seasoned Potato Fries", "Golden skin-on fries with parmesan and truffle oil.", 4.99, "https://images.unsplash.com/photo-1576107232684-1279f3908594?w=500&q=80", "Sides", true, true, rest3);
        foodItemRepository.saveAll(Arrays.asList(f301, f302, f303));

        FoodItem f401 = new FoodItem(null, "Salmon Dragon Roll (8 pcs)", "Fresh salmon, avocado, spicy mayo, and tobiko.", 16.99, "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500&q=80", "Sushi", false, true, rest4);
        FoodItem f402 = new FoodItem(null, "Avocado & Cucumber Veg Roll (8 pcs)", "Ripe avocado and cucumber wrapped in sushi rice.", 10.99, "https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=500&q=80", "Sushi", true, true, rest4);
        foodItemRepository.saveAll(Arrays.asList(f401, f402));

        FoodItem f501 = new FoodItem(null, "Triple Chocolate Molten Lava Cake", "Warm chocolate cake with oozing chocolate center.", 7.99, "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&q=80", "Dessert", true, true, rest5);
        FoodItem f502 = new FoodItem(null, "Belgian Waffle with Berry Compote", "Crispy golden waffle with maple syrup and fresh berries.", 8.49, "https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=500&q=80", "Dessert", true, true, rest5);
        foodItemRepository.saveAll(Arrays.asList(f501, f502));

        FoodItem f601 = new FoodItem(null, "Spicy Carne Asada Street Tacos (3 pcs)", "Grilled flank steak with onions, cilantro, and salsa.", 10.99, "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=500&q=80", "Tacos", false, true, rest6);
        foodItemRepository.saveAll(Arrays.asList(f601));

        // 4. Initial Demo Orders
        OrderItem oItem1 = new OrderItem(null, f201, 1, 16.49);
        OrderItem oItem2 = new OrderItem(null, f203, 1, 5.99);
        Order order1 = new Order();
        order1.setCustomer(customer);
        order1.setRestaurant(rest2);
        order1.setItems(Arrays.asList(oItem1, oItem2));
        order1.setTotalAmount(26.48);
        order1.setDeliveryAddress("123 Food Street, Foodville");
        order1.setPaymentMethod("UPI");
        order1.setPaymentStatus("PAID");
        order1.setStatus("DELIVERED");
        order1.setInvoiceNumber("INV-000001");
        order1.setInvoiceGenerated(true);

        LocalDateTime baseTime = LocalDateTime.now().minusDays(2);
        order1.setCreatedAt(baseTime);
        order1.setOrderPlacedAt(baseTime);
        order1.setPaymentProcessingAt(baseTime.plusMinutes(2));
        order1.setRestaurantAcceptedAt(baseTime.plusMinutes(4));
        order1.setKitchenPreparingAt(baseTime.plusMinutes(10));
        order1.setOutForDeliveryAt(baseTime.plusMinutes(22));
        order1.setDeliveredAt(baseTime.plusMinutes(32));

        orderRepository.save(order1);
    }
}
