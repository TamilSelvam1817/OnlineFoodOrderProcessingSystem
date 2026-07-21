package com.foodorder.backend.service;

import com.foodorder.backend.model.GoogleAccount;
import com.foodorder.backend.model.Order;
import com.foodorder.backend.model.UserOauth;
import com.foodorder.backend.repository.GoogleAccountRepository;
import com.foodorder.backend.repository.UserOauthRepository;
import jakarta.activation.DataHandler;
import jakarta.activation.DataSource;
import jakarta.mail.Session;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.util.ByteArrayDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.io.ByteArrayOutputStream;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@Service
public class GmailService {

    private static final Logger log = LoggerFactory.getLogger(GmailService.class);

    @Autowired
    private GoogleAccountRepository googleAccountRepository;

    @Autowired
    private UserOauthRepository userOauthRepository;

    @Autowired
    private InvoiceEmailService invoiceEmailService;

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String clientId;

    @Value("${spring.security.oauth2.client.registration.google.client-secret}")
    private String clientSecret;

    public String getOrRefreshAccessToken(GoogleAccount account) {
        if (account.getExpiresAt() == null || account.getExpiresAt().isBefore(LocalDateTime.now().plusMinutes(5))) {
            log.info("[GmailService] Access token expired for user {}. Attempting refresh...", account.getUser().getId());
            if (account.getRefreshToken() == null || account.getRefreshToken().isEmpty()) {
                throw new RuntimeException("No refresh token stored. User must log in with Google again.");
            }
            refreshAccessToken(account);
        }
        return account.getAccessToken();
    }

    private void refreshAccessToken(GoogleAccount account) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
            map.add("client_id", clientId);
            map.add("client_secret", clientSecret);
            map.add("refresh_token", account.getRefreshToken());
            map.add("grant_type", "refresh_token");

            HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(map, headers);
            RestTemplate restTemplate = new RestTemplate();
            
            ResponseEntity<Map> responseEntity = restTemplate.postForEntity(
                    "https://oauth2.googleapis.com/token", request, Map.class);
            
            Map<String, Object> responseBody = responseEntity.getBody();
            if (responseBody == null || !responseBody.containsKey("access_token")) {
                throw new RuntimeException("Refresh token request returned no access token");
            }

            String newAccessToken = (String) responseBody.get("access_token");
            Number expiresIn = (Number) responseBody.get("expires_in");
            LocalDateTime newExpiryTime = LocalDateTime.now().plusSeconds(expiresIn.longValue());

            account.setAccessToken(newAccessToken);
            account.setExpiresAt(newExpiryTime);
            googleAccountRepository.save(account);
            log.info("[GmailService] Access token refreshed successfully for user {}", account.getUser().getId());
        } catch (Exception e) {
            log.error("[GmailService] Token refresh failed for user {}", account.getUser().getId(), e);
            throw new RuntimeException("Failed to refresh Google access token", e);
        }
    }

    public void sendInvoiceViaGmail(Order order, GoogleAccount account) {
        try {
            String accessToken = getOrRefreshAccessToken(account);
            String customerEmail = order.getCustomer() != null ? order.getCustomer().getEmail() : null;
            String customerName = order.getCustomer() != null ? order.getCustomer().getName() : "Customer";

            if (customerEmail == null || customerEmail.isBlank()) {
                throw new IllegalArgumentException("Customer email is missing from the order record");
            }

            byte[] pdfBytes = invoiceEmailService.generateInvoicePdf(order);
            String invoiceNo = "INV-" + String.format("%06d", order.getId());
            String htmlContent = invoiceEmailService.buildHtmlBody(customerName, order, invoiceNo);
            String filename = "FoodOrder-Invoice-" + String.format("%06d", order.getId()) + ".pdf";

            Properties props = new Properties();
            Session session = Session.getDefaultInstance(props, null);
            MimeMessage mimeMessage = new MimeMessage(session);

            mimeMessage.setFrom(new InternetAddress(account.getEmail(), "ByteBurst"));
            mimeMessage.setRecipient(MimeMessage.RecipientType.TO, new InternetAddress(customerEmail));
            mimeMessage.setSubject("Your ByteBurst Order Invoice");

            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(htmlContent, "text/html; charset=UTF-8");

            MimeBodyPart attachmentPart = new MimeBodyPart();
            DataSource pdfDataSource = new ByteArrayDataSource(pdfBytes, "application/pdf");
            attachmentPart.setDataHandler(new DataHandler(pdfDataSource));
            attachmentPart.setFileName(filename);

            MimeMultipart multipart = new MimeMultipart("mixed");
            multipart.addBodyPart(htmlPart);
            multipart.addBodyPart(attachmentPart);
            mimeMessage.setContent(multipart);

            ByteArrayOutputStream os = new ByteArrayOutputStream();
            mimeMessage.writeTo(os);
            byte[] rawBytes = os.toByteArray();
            String encodedEmail = Base64.getUrlEncoder().withoutPadding().encodeToString(rawBytes);

            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(accessToken);
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> requestBody = new HashMap<>();
            requestBody.put("raw", encodedEmail);

            HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(requestBody, headers);
            RestTemplate restTemplate = new RestTemplate();

            ResponseEntity<Map> response = restTemplate.postForEntity(
                    "https://gmail.googleapis.com/gmail/v1/users/me/messages/send",
                    requestEntity,
                    Map.class
            );

            if (response.getStatusCode().is2xxSuccessful()) {
                log.info("[GmailService] Invoice {} sent via Gmail API from {} to {}", invoiceNo, account.getEmail(), customerEmail);
            } else {
                throw new RuntimeException("Gmail API delivery failed with status: " + response.getStatusCode());
            }

        } catch (Exception e) {
            log.error("[GmailService] Failed to send invoice via Gmail API for order #{}", order.getId(), e);
            throw new RuntimeException("Gmail API email delivery failed.", e);
        }
    }

    public void sendInvoiceViaGmail(Order order, UserOauth oauth) {
        GoogleAccount account = new GoogleAccount();
        account.setUser(oauth.getUser());
        account.setEmail(oauth.getGoogleEmail());
        account.setGoogleId(oauth.getGoogleId());
        account.setAccessToken(oauth.getAccessToken());
        account.setRefreshToken(oauth.getRefreshToken());
        account.setExpiresAt(oauth.getExpiryTime());
        sendInvoiceViaGmail(order, account);
    }
}
