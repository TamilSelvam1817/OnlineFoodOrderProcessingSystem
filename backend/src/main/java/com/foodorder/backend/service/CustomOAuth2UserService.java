package com.foodorder.backend.service;

import com.foodorder.backend.model.GoogleAccount;
import com.foodorder.backend.model.User;
import com.foodorder.backend.repository.GoogleAccountRepository;
import com.foodorder.backend.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Optional;
import java.util.UUID;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private static final Logger log = LoggerFactory.getLogger(CustomOAuth2UserService.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private GoogleAccountRepository googleAccountRepository;

    private final PasswordEncoder passwordEncoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        log.info("[OAuth2UserService] Google OAuth User attributes: {}", oAuth2User.getAttributes());

        String googleId = oAuth2User.getAttribute("sub");
        String email = oAuth2User.getAttribute("email");
        String name = oAuth2User.getAttribute("name");

        if (email == null || email.isBlank()) {
            throw new OAuth2AuthenticationException("Email not supplied by Google OAuth provider");
        }

        User user = userRepository.findByEmail(email).orElseGet(() -> {
            User newUser = new User();
            newUser.setEmail(email);
            newUser.setName(name != null ? name : "Google User");
            newUser.setRole("ROLE_CUSTOMER");
            newUser.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
            log.info("[OAuth2UserService] Registering new user for email: {}", email);
            return userRepository.save(newUser);
        });

        String accessToken = userRequest.getAccessToken().getTokenValue();
        String refreshToken = userRequest.getAdditionalParameters() != null ?
                (String) userRequest.getAdditionalParameters().get("refresh_token") : null;
        
        LocalDateTime expiresAt = null;
        if (userRequest.getAccessToken().getExpiresAt() != null) {
            expiresAt = LocalDateTime.ofInstant(userRequest.getAccessToken().getExpiresAt(), ZoneId.systemDefault());
        }

        Optional<GoogleAccount> accountOpt = googleAccountRepository.findByUser(user);
        GoogleAccount account;
        if (accountOpt.isPresent()) {
            account = accountOpt.get();
            account.setAccessToken(accessToken);
            if (refreshToken != null && !refreshToken.isBlank()) {
                account.setRefreshToken(refreshToken);
            }
            account.setExpiresAt(expiresAt);
            account.setEmail(email);
            account.setGoogleId(googleId);
        } else {
            account = new GoogleAccount(user, googleId, email, accessToken, refreshToken, expiresAt);
        }
        googleAccountRepository.save(account);
        log.info("[OAuth2UserService] Stored OAuth tokens for user {}", email);

        return oAuth2User;
    }
}
