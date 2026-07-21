package com.foodorder.backend.model;

import com.foodorder.backend.config.EncryptionConverter;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_oauth")
public class UserOauth {

    @Id
    @Column(name = "user_id")
    private Long userId;

    @OneToOne(fetch = FetchType.LAZY)
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "google_email", nullable = false)
    private String googleEmail;

    @Column(name = "google_id", nullable = false)
    private String googleId;

    @Column(name = "access_token", length = 2000)
    @Convert(converter = EncryptionConverter.class)
    private String accessToken;

    @Column(name = "refresh_token", length = 2000)
    @Convert(converter = EncryptionConverter.class)
    private String refreshToken;

    @Column(name = "expiry_time")
    private LocalDateTime expiryTime;

    public UserOauth() {}

    public UserOauth(User user, String googleEmail, String googleId, String accessToken, String refreshToken, LocalDateTime expiryTime) {
        this.user = user;
        this.userId = user.getId();
        this.googleEmail = googleEmail;
        this.googleId = googleId;
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.expiryTime = expiryTime;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.userId = user.getId();
        }
    }

    public String getGoogleEmail() {
        return googleEmail;
    }

    public void setGoogleEmail(String googleEmail) {
        this.googleEmail = googleEmail;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public LocalDateTime getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(LocalDateTime expiryTime) {
        this.expiryTime = expiryTime;
    }
}
