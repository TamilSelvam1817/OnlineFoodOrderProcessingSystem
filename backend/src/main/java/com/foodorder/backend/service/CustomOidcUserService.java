package com.foodorder.backend.service;

import com.foodorder.backend.model.GoogleAccount;
import com.foodorder.backend.model.User;
import com.foodorder.backend.repository.GoogleAccountRepository;
import com.foodorder.backend.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserRequest;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Optional;
import java.util.UUID;

@Service
public class CustomOidcUserService extends OidcUserService {

    private static final Logger log = LoggerFactory.getLogger(CustomOidcUserService.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private GoogleAccountRepository googleAccountRepository;

    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public OidcUser loadUser(OidcUserRequest userRequest) throws OAuth2AuthenticationException {
        log.info("[OidcUserService] Called! Loading OIDC user...");
        OidcUser oidcUser = super.loadUser(userRequest);
        log.info("[OidcUserService] Attributes received: {}", oidcUser.getAttributes());

        String googleId = oidcUser.getAttribute("sub");
        String rawEmail = oidcUser.getAttribute("email");
        String name = oidcUser.getAttribute("name");

        if (rawEmail == null || rawEmail.isBlank()) {
            throw new OAuth2AuthenticationException("Email not supplied by Google OpenID Connect provider");
        }

        String email = rawEmail.toLowerCase().trim();

        User user = userRepository.findByEmail(email).orElseGet(() -> {
            User newUser = new User();
            newUser.setEmail(email);
            newUser.setName(name != null ? name : "Google User");
            newUser.setRole("ROLE_CUSTOMER");
            newUser.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
            User saved = userRepository.save(newUser);
            log.info("[OidcUserService] ✅ Saved new user to DB. ID: {}, Email: {}", saved.getId(), saved.getEmail());
            return saved;
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
        log.info("[OidcUserService] ✅ Saved GoogleAccount tokens for user ID: {}", user.getId());

        return oidcUser;
    }
}
