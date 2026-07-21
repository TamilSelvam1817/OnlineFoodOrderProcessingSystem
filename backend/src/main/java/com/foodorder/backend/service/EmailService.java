package com.foodorder.backend.service;

import com.foodorder.backend.model.Order;
import com.foodorder.backend.model.OrderItem;
import com.foodorder.backend.model.Restaurant;
import com.foodorder.backend.model.User;
import jakarta.activation.DataHandler;
import jakarta.activation.DataSource;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.util.ByteArrayDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;

@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @Value("${spring.mail.username:byteburst.orders@gmail.com}")
    private String fromEmail;

    /**
     * Sends the ByteBurst Order Confirmation and PDF Invoice to the authenticated customer.
     */
    public boolean sendInvoiceToCustomer(Order order, byte[] pdfBytes) {
        log.info("[EmailService] 1. Invoice request received for Order #{}", order.getId());

        User customer = order.getCustomer();
        String customerEmail = customer != null ? customer.getEmail() : null;
        String customerName = customer != null ? customer.getName() : order.getCustomerName();

        if (customerEmail == null || customerEmail.isBlank()) {
            log.error("[EmailService] ❌ Recipient email address missing for Order #{}", order.getId());
            return false;
        }
        log.info("[EmailService] 2. Verified recipient email address: {}", customerEmail);

        if (pdfBytes != null && pdfBytes.length > 0) {
            log.info("[EmailService] 3. PDF generated successfully (size: {} bytes)", pdfBytes.length);
        } else {
            log.warn("[EmailService] ⚠️ PDF byte array is empty for Order #{}", order.getId());
        }

        String restaurantName = order.getRestaurant() != null ? order.getRestaurant().getName() : "ByteBurst Partner Kitchen";
        String invoiceNo = String.format("%06d", order.getId());
        String filename = "FoodOrder-Invoice-" + invoiceNo + ".pdf";
        String subject = "Your ByteBurst Order Confirmation & Invoice";

        String bodyText = String.format(
            "Hello %s,\n\n" +
            "Thank you for ordering with ByteBurst.\n\n" +
            "Your order has been confirmed successfully.\n\n" +
            "Restaurant:\n%s\n\n" +
            "Order ID:\n#%d\n\n" +
            "Estimated Delivery:\n25–35 Minutes\n\n" +
            "Payment Method:\n%s\n\n" +
            "Grand Total:\n$%.2f\n\n" +
            "Please find your invoice attached.\n\n" +
            "Thank you,\nByteBurst Team",
            customerName,
            restaurantName,
            order.getId(),
            order.getPaymentMethod(),
            order.getTotalAmount()
        );

        try {
            if (mailSender != null) {
                log.info("[EmailService] 4. Preparing email for Order #{} to {}", order.getId(), customerEmail);
                MimeMessage message = mailSender.createMimeMessage();
                message.setFrom(new InternetAddress(fromEmail, "ByteBurst Orders"));
                message.setRecipient(MimeMessage.RecipientType.TO, new InternetAddress(customerEmail));
                message.setSubject(subject);

                MimeBodyPart textPart = new MimeBodyPart();
                textPart.setText(bodyText, "UTF-8");

                MimeMultipart multipart = new MimeMultipart();
                multipart.addBodyPart(textPart);

                if (pdfBytes != null && pdfBytes.length > 0) {
                    log.info("[EmailService] 5. Attaching PDF: {} (size: {} bytes)", filename, pdfBytes.length);
                    MimeBodyPart attachmentPart = new MimeBodyPart();
                    DataSource dataSource = new ByteArrayDataSource(pdfBytes, "application/pdf");
                    attachmentPart.setDataHandler(new DataHandler(dataSource));
                    attachmentPart.setFileName(filename);
                    multipart.addBodyPart(attachmentPart);
                }

                message.setContent(multipart);

                log.info("[EmailService] 6. Sending email via JavaMailSender");
                mailSender.send(message);

                log.info("[EmailService] 7. Email sent successfully to {} for Order #{}", customerEmail, order.getId());
                return true;
            } else {
                log.warn("[EmailService] JavaMailSender bean not configured. Skipping email sending for {}", customerEmail);
                return false;
            }
        } catch (Exception e) {
            log.error("[EmailService] ❌ Exception occurred while sending email for Order #{}: {}", order.getId(), e.getMessage(), e);
            return false;
        }
    }

    /**
     * Sends a New Order Notification Email to the restaurant owner.
     */
    public boolean sendOrderNotificationToRestaurant(Order order) {
        Restaurant restaurant = order.getRestaurant();
        if (restaurant == null) {
            log.error("[EmailService] ❌ Restaurant missing for Order #{}", order.getId());
            return false;
        }

        String ownerEmail = restaurant.getOwnerEmail();
        if (ownerEmail == null || ownerEmail.isBlank()) {
            ownerEmail = "owner@food.com";
        }
        String ownerName = restaurant.getOwnerName() != null ? restaurant.getOwnerName() : "Restaurant Partner";

        User customer = order.getCustomer();
        String customerName = customer != null ? customer.getName() : order.getCustomerName();
        String customerEmail = customer != null ? customer.getEmail() : "N/A";
        String customerPhone = (customer != null && customer.getPhone() != null) ? customer.getPhone() : "+1 (555) 019-2834";
        String deliveryAddress = order.getDeliveryAddress();

        StringBuilder itemsSummary = new StringBuilder();
        if (order.getItems() != null) {
            for (OrderItem item : order.getItems()) {
                String itemName = item.getFoodItem() != null ? item.getFoodItem().getName() : "Item";
                itemsSummary.append(String.format("• %s x%d - $%.2f\n", itemName, item.getQuantity(), item.getPrice() * item.getQuantity()));
            }
        }

        DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("MMM dd, yyyy hh:mm a");
        String subject = "New Order Received";

        String bodyText = String.format(
            "Hello %s,\n\n" +
            "A new order has been placed.\n\n" +
            "Customer:\n%s\n\n" +
            "Customer Email:\n%s\n\n" +
            "Phone:\n%s\n\n" +
            "Delivery Address:\n%s\n\n" +
            "Order ID:\n#%d\n\n" +
            "Items Ordered:\n%s\n" +
            "Grand Total:\n$%.2f\n\n" +
            "Payment Method:\n%s\n\n" +
            "Order Time:\n%s\n\n" +
            "Please prepare the order.",
            ownerName,
            customerName,
            customerEmail,
            customerPhone,
            deliveryAddress,
            order.getId(),
            itemsSummary.toString(),
            order.getTotalAmount(),
            order.getPaymentMethod(),
            order.getCreatedAt() != null ? order.getCreatedAt().format(dateFmt) : "Now"
        );

        try {
            if (mailSender != null) {
                MimeMessage message = mailSender.createMimeMessage();
                message.setFrom(new InternetAddress(fromEmail, "ByteBurst System"));
                message.setRecipient(MimeMessage.RecipientType.TO, new InternetAddress(ownerEmail));
                message.setSubject(subject);
                message.setText(bodyText, "UTF-8");

                mailSender.send(message);
                log.info("[EmailService] ✅ Restaurant Owner Notification Email sent to {} for Order #{}", ownerEmail, order.getId());
                return true;
            } else {
                log.warn("[EmailService] JavaMailSender not configured. Skipping Spring Mail delivery for owner {}", ownerEmail);
                return false;
            }
        } catch (Exception e) {
            log.error("[EmailService] ❌ Failed to send Restaurant Owner Email for Order #{}: {}", order.getId(), e.getMessage(), e);
            return false;
        }
    }
}
