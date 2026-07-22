package com.foodorder.backend.config;

import com.foodorder.backend.model.User;
import com.foodorder.backend.repository.UserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@Component
public class OAuth2SuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private static final Logger log = LoggerFactory.getLogger(OAuth2SuccessHandler.class);

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserRepository userRepository;

    @Value("${app.frontend.url:https://frontend-production-26f5.up.railway.app}")
    private String frontendUrl;

    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        log.info("[OAuth2SuccessHandler] Called! Principal attributes: {}", oAuth2User.getAttributes());

        String rawEmail = oAuth2User.getAttribute("email");
        String name = oAuth2User.getAttribute("name");

        String baseUrl = (frontendUrl != null && !frontendUrl.isBlank()) ? frontendUrl.trim() : "https://frontend-production-26f5.up.railway.app";

        String serverName = request.getServerName();
        if (baseUrl.contains("localhost") && ((serverName != null && serverName.contains("railway.app")) || System.getenv("PORT") != null)) {
            baseUrl = "https://frontend-production-26f5.up.railway.app";
        }

        if (baseUrl.endsWith("/")) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }

        if (rawEmail == null || rawEmail.isBlank()) {
            log.error("[OAuth2SuccessHandler] ❌ Email attribute missing in OAuth2User!");
            getRedirectStrategy().sendRedirect(request, response, baseUrl + "/login?error=EmailMissing");
            return;
        }

        String email = rawEmail.toLowerCase().trim();
        log.info("[OAuth2SuccessHandler] Processing login for normalized email: {}", email);

        User user = userRepository.findByEmail(email).orElseGet(() -> {
            log.info("[OAuth2SuccessHandler] User not found in DB during handler execution, creating fallback user for {}", email);
            User newUser = new User();
            newUser.setEmail(email);
            newUser.setName(name != null ? name : "Google User");
            newUser.setRole("ROLE_CUSTOMER");
            newUser.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
            return userRepository.save(newUser);
        });

        String token = jwtUtil.generateToken(user.getEmail(), user.getRole(), user.getId());

        String targetUrl = baseUrl + "/oauth/success" +
                "?token=" + URLEncoder.encode(token, StandardCharsets.UTF_8) +
                "&email=" + URLEncoder.encode(user.getEmail(), StandardCharsets.UTF_8) +
                "&name=" + URLEncoder.encode(user.getName(), StandardCharsets.UTF_8) +
                "&role=" + URLEncoder.encode(user.getRole(), StandardCharsets.UTF_8) +
                "&userId=" + user.getId();

        log.info("[OAuth2SuccessHandler] ✅ Successfully generated JWT and redirecting to React: {}", targetUrl);
        getRedirectStrategy().sendRedirect(request, response, targetUrl);
    }
}
