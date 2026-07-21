package com.foodorder.backend.repository;

import com.foodorder.backend.model.GoogleAccount;
import com.foodorder.backend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface GoogleAccountRepository extends JpaRepository<GoogleAccount, Long> {
    Optional<GoogleAccount> findByUser(User user);
    Optional<GoogleAccount> findByUserId(Long userId);
    Optional<GoogleAccount> findByEmail(String email);
    Optional<GoogleAccount> findByGoogleId(String googleId);
}
