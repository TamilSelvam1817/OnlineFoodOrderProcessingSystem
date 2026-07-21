package com.foodorder.backend.config;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Component
public class OAuthDebugLogger {

    private static final Logger log = LoggerFactory.getLogger(OAuthDebugLogger.class);

    @Autowired
    private Environment environment;

    @Value("${spring.security.oauth2.client.registration.google.client-id:}")
    private String clientId;

    @Value("${spring.security.oauth2.client.registration.google.redirect-uri:}")
    private String redirectUri;

    @PostConstruct
    public void logOAuthConfiguration() {
        log.info("==========================================================================================");
        log.info("[OAuthDebugLogger] Active Spring Profiles: {}", Arrays.toString(environment.getActiveProfiles()));
        
        String envClientId = System.getenv("GOOGLE_CLIENT_ID");
        log.info("[OAuthDebugLogger] Environment variable GOOGLE_CLIENT_ID present: {}", envClientId != null && !envClientId.isBlank());

        if (clientId == null || clientId.isBlank() || clientId.contains("YOUR_ACTUAL_GOOGLE_CLIENT_ID")) {
            log.error("[OAuthDebugLogger] ❌ CRITICAL: Current Google Client ID is UNCONFIGURED or using PLACEHOLDER string!");
            log.error("[OAuthDebugLogger] Loaded Client ID value: '{}'", clientId);
            log.error("[OAuthDebugLogger] This will cause Google to return 'Error 401: invalid_client - The OAuth client was not found.'");
        } else {
            String maskedId = clientId.length() > 15 
                    ? clientId.substring(0, 8) + "..." + clientId.substring(clientId.length() - 15)
                    : "****";
            log.info("[OAuthDebugLogger] ✅ Successfully loaded Google Client ID: {}", maskedId);
            log.info("[OAuthDebugLogger] ✅ Configured Redirect URI template: {}", redirectUri);
        }
        log.info("==========================================================================================");
    }
}
