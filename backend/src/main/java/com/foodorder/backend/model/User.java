package com.foodorder.backend.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String role; // ROLE_CUSTOMER, ROLE_RESTAURANT, ROLE_ADMIN

    private String phone = "+1 (555) 019-2834";

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "user_addresses", joinColumns = @JoinColumn(name = "user_id"))
    private List<String> addresses = new ArrayList<>();

    @ElementCollection
    @CollectionTable(name = "user_favorites", joinColumns = @JoinColumn(name = "user_id"))
    private List<Long> favoriteRestaurantIds = new ArrayList<>();

    public User() {}

    public User(Long id, String name, String email, String password, String role, String phone, List<String> addresses, List<Long> favoriteRestaurantIds) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.phone = phone;
        this.addresses = addresses;
        this.favoriteRestaurantIds = favoriteRestaurantIds;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public List<String> getAddresses() {
        return addresses;
    }

    public void setAddresses(List<String> addresses) {
        this.addresses = addresses;
    }

    public List<Long> getFavoriteRestaurantIds() {
        return favoriteRestaurantIds;
    }

    public void setFavoriteRestaurantIds(List<Long> favoriteRestaurantIds) {
        this.favoriteRestaurantIds = favoriteRestaurantIds;
    }
}
