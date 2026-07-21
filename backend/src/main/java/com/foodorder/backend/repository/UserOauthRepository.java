package com.foodorder.backend.repository;

import com.foodorder.backend.model.UserOauth;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserOauthRepository extends JpaRepository<UserOauth, Long> {
    Optional<UserOauth> findByGoogleEmail(String googleEmail);
    Optional<UserOauth> findByGoogleId(String googleId);
}
