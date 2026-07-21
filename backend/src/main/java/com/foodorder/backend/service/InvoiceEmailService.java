package com.foodorder.backend.service;

import com.foodorder.backend.model.Order;
import com.foodorder.backend.model.OrderItem;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.time.format.DateTimeFormatter;

@Service
public class InvoiceEmailService {

    private static final Logger log = LoggerFactory.getLogger(InvoiceEmailService.class);

    public String buildHtmlBody(String name, Order order, String invoiceNo) {
        String customerName = name != null && !name.isBlank() ? name : "Customer";
        String restName = order.getRestaurant() != null ? order.getRestaurant().getName() : "ByteBurst Partner Kitchen";
        double total = order.getTotalAmount();
        String payStatus = "DELIVERED".equalsIgnoreCase(order.getStatus()) ? "PAID" : (order.getPaymentStatus() != null ? order.getPaymentStatus() : "PAID");

        return "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;background:#f8f9fa;padding:20px;color:#333;'>" +
                "<div style='max-width:550px;margin:0 auto;background:#fff;padding:25px;border-radius:12px;border:1px solid #eee;'>" +
                "<h2 style='color:#ff6b35;margin-top:0;'>ByteBurst Order Invoice</h2>" +
                "<p>Hello <strong>" + customerName + "</strong>,</p>" +
                "<p>Thank you for ordering with <strong>ByteBurst</strong>.</p>" +
                "<p>Please find your invoice attached.</p>" +
                "<div style='background:#f9f9f9;padding:15px;border-radius:8px;margin:20px 0;line-height:1.6;'>" +
                "<p style='margin:4px 0;'><strong>Order ID:</strong> #" + order.getId() + "</p>" +
                "<p style='margin:4px 0;'><strong>Restaurant:</strong> " + restName + "</p>" +
                "<p style='margin:4px 0;'><strong>Payment Method:</strong> " + order.getPaymentMethod() + "</p>" +
                "<p style='margin:4px 0;'><strong>Payment Status:</strong> " + payStatus + "</p>" +
                "<p style='margin:4px 0;'><strong>Order Status:</strong> " + (order.getStatus() != null ? order.getStatus().replace("_", " ") : "ORDER PLACED") + "</p>" +
                "<p style='margin:4px 0;'><strong>Total:</strong> $" + String.format("%.2f", total) + "</p>" +
                "</div>" +
                "<p>We hope you enjoy your meal.</p>" +
                "<p style='margin-top:25px;color:#666;'>Thank you,<br><strong>ByteBurst Team</strong></p>" +
                "</div></body></html>";
    }

    public byte[] generateInvoicePdf(Order order) {
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            Document doc = new Document(PageSize.A4, 40, 40, 40, 40);
            PdfWriter.getInstance(doc, baos);
            doc.open();

            Color primaryOrange = new Color(255, 107, 53);
            Color white = Color.WHITE;
            Color darkText = new Color(40, 40, 40);
            Color grayText = new Color(100, 100, 100);
            Color lightBg = new Color(250, 250, 250);

            Font brandFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, white);
            Font tagFont = FontFactory.getFont(FontFactory.HELVETICA, 8, new Color(230, 230, 230));
            Font invTitleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, white);
            Font labelFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, new Color(140, 140, 140));
            Font valueFont = FontFactory.getFont(FontFactory.HELVETICA, 9, grayText);
            Font boldVal = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, darkText);
            Font tblHead = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, white);
            Font tblCell = FontFactory.getFont(FontFactory.HELVETICA, 9, grayText);
            Font tblCellBold = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, darkText);
            Font grandTotalFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, white);
            Font footerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, primaryOrange);

            String invoiceNo = order.getInvoiceNumber() != null ? order.getInvoiceNumber() : ("INV-" + String.format("%06d", order.getId()));
            DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("MMM dd, yyyy hh:mm a");

            // Header Bar
            PdfPTable header = new PdfPTable(2);
            header.setWidthPercentage(100);
            header.setWidths(new float[]{2f, 1f});
            header.setSpacingAfter(18);

            PdfPCell brandCell = new PdfPCell();
            brandCell.setBackgroundColor(primaryOrange);
            brandCell.setBorder(0);
            brandCell.setPadding(12);
            brandCell.addElement(new Phrase("ByteBurst", brandFont));
            brandCell.addElement(new Phrase("123 Food Street, Suite 500, Tech City, NY 10001", tagFont));
            brandCell.addElement(new Phrase("Support: support@byteburst.com | Phone: +1 (800) 555-BITE", tagFont));
            header.addCell(brandCell);

            PdfPCell invCell = new PdfPCell();
            invCell.setBackgroundColor(primaryOrange);
            invCell.setBorder(0);
            invCell.setPadding(12);
            invCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            invCell.addElement(new Phrase("INVOICE", invTitleFont));
            invCell.addElement(new Phrase("#" + invoiceNo, tagFont));
            header.addCell(invCell);

            doc.add(header);

            // Customer + Invoice Meta
            PdfPTable meta = new PdfPTable(2);
            meta.setWidthPercentage(100);
            meta.setWidths(new float[]{1f, 1f});
            meta.setSpacingAfter(14);

            String custName = order.getCustomer() != null ? order.getCustomer().getName() : order.getCustomerName();
            String custEmail = order.getCustomer() != null ? order.getCustomer().getEmail() : "Registered Customer";

            PdfPCell billCell = new PdfPCell();
            billCell.setBorder(0);
            billCell.addElement(new Phrase("CUSTOMER INFORMATION", labelFont));
            billCell.addElement(new Phrase(custName != null ? custName : "Customer", boldVal));
            billCell.addElement(new Phrase(custEmail, valueFont));
            if (order.getDeliveryAddress() != null) {
                billCell.addElement(new Phrase("Delivery: " + order.getDeliveryAddress(), valueFont));
            }
            meta.addCell(billCell);

            PdfPCell detCell = new PdfPCell();
            detCell.setBorder(0);
            detCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            detCell.addElement(new Phrase("INVOICE INFORMATION", labelFont));
            
            String orderDateStr = order.getCreatedAt() != null ? order.getCreatedAt().format(dateFmt) : "Now";
            String currentStatus = order.getStatus() != null ? order.getStatus().replace("_", " ") : "ORDER PLACED";
            String payStatus = "DELIVERED".equalsIgnoreCase(order.getStatus()) ? "PAID" : (order.getPaymentStatus() != null ? order.getPaymentStatus() : "PAID");
            String estDelivery = order.getEstimatedDelivery() != null ? order.getEstimatedDelivery() : "25-35 mins";

            String[][] details = {
                {"Invoice Number", invoiceNo},
                {"Order ID", "#" + order.getId()},
                {"Order Date & Time", orderDateStr},
                {"Payment Method", order.getPaymentMethod() != null ? order.getPaymentMethod() : "UPI"},
                {"Payment Status", payStatus},
                {"Order Status", currentStatus},
                {"Delivery Time", estDelivery}
            };
            for (String[] d : details) {
                PdfPTable r = new PdfPTable(2);
                r.setWidthPercentage(100);
                PdfPCell k = new PdfPCell(new Phrase(d[0] + ":", tblCellBold)); k.setBorder(0); r.addCell(k);
                PdfPCell v = new PdfPCell(new Phrase(d[1], tblCell)); v.setBorder(0); v.setHorizontalAlignment(Element.ALIGN_RIGHT); r.addCell(v);
                detCell.addElement(r);
            }
            meta.addCell(detCell);
            doc.add(meta);

            // Restaurant Box
            if (order.getRestaurant() != null) {
                PdfPTable restTable = new PdfPTable(1);
                restTable.setWidthPercentage(100);
                restTable.setSpacingAfter(12);
                PdfPCell rc = new PdfPCell();
                rc.setBackgroundColor(lightBg);
                rc.setBorderColor(new Color(230, 230, 230));
                rc.setPadding(8);
                rc.addElement(new Phrase("RESTAURANT INFORMATION", labelFont));
                rc.addElement(new Phrase(order.getRestaurant().getName(), boldVal));
                restTable.addCell(rc);
                doc.add(restTable);
            }

            // Items Table
            PdfPTable table = new PdfPTable(4);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{3.5f, 1f, 1.5f, 1.5f});
            table.setSpacingAfter(8);

            String[] heads = {"Item Name", "Quantity", "Unit Price", "Total"};
            for (String h : heads) {
                PdfPCell hc = new PdfPCell(new Phrase(h, tblHead));
                hc.setBackgroundColor(primaryOrange);
                hc.setPadding(6);
                hc.setHorizontalAlignment(h.equals("Quantity") ? Element.ALIGN_CENTER : h.equals("Unit Price") || h.equals("Total") ? Element.ALIGN_RIGHT : Element.ALIGN_LEFT);
                hc.setBorder(0);
                table.addCell(hc);
            }

            for (OrderItem item : order.getItems()) {
                String name = item.getFoodItem() != null ? item.getFoodItem().getName() : "Food Item";
                int qty = item.getQuantity();
                double price = item.getPrice();
                double total = price * qty;

                addTableCell(table, name, tblCellBold, Element.ALIGN_LEFT);
                addTableCell(table, String.valueOf(qty), tblCell, Element.ALIGN_CENTER);
                addTableCell(table, "$" + String.format("%.2f", price), tblCell, Element.ALIGN_RIGHT);
                addTableCell(table, "$" + String.format("%.2f", total), tblCellBold, Element.ALIGN_RIGHT);
            }
            doc.add(table);

            // Pricing Totals
            double subtotal = order.getItems().stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();
            double delivery = 4.00;
            double gst = subtotal * 0.05;
            double grandTotal = order.getTotalAmount();

            PdfPTable totals = new PdfPTable(2);
            totals.setWidthPercentage(50);
            totals.setHorizontalAlignment(Element.ALIGN_RIGHT);
            totals.setSpacingAfter(16);

            addTotalRow(totals, "Subtotal", "$" + String.format("%.2f", subtotal), valueFont, valueFont);
            addTotalRow(totals, "Delivery Fee", "$" + String.format("%.2f", delivery), valueFont, valueFont);
            addTotalRow(totals, "GST (5%)", "$" + String.format("%.2f", gst), valueFont, valueFont);

            PdfPCell gtLabel = new PdfPCell(new Phrase("Grand Total", grandTotalFont));
            gtLabel.setBackgroundColor(primaryOrange); gtLabel.setBorder(0); gtLabel.setPadding(6);
            PdfPCell gtVal = new PdfPCell(new Phrase("$" + String.format("%.2f", grandTotal), grandTotalFont));
            gtVal.setBackgroundColor(primaryOrange); gtVal.setBorder(0); gtVal.setPadding(6); gtVal.setHorizontalAlignment(Element.ALIGN_RIGHT);
            totals.addCell(gtLabel); totals.addCell(gtVal);
            doc.add(totals);

            // Footer Note
            PdfPTable footer = new PdfPTable(1);
            footer.setWidthPercentage(100);
            PdfPCell fc = new PdfPCell(new Phrase("Thank you for ordering with ByteBurst.", footerFont));
            fc.setBorder(0);
            fc.setHorizontalAlignment(Element.ALIGN_CENTER);
            footer.addCell(fc);
            doc.add(footer);

            doc.close();
            return baos.toByteArray();
        } catch (Exception e) {
            log.error("[InvoiceEmailService] PDF generation error: {}", e.getMessage(), e);
            return new byte[0];
        }
    }

    private void addTableCell(PdfPTable table, String text, Font font, int align) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setBorder(Rectangle.BOTTOM);
        cell.setBorderColor(new Color(240, 240, 240));
        cell.setPadding(5);
        cell.setHorizontalAlignment(align);
        table.addCell(cell);
    }

    private void addTotalRow(PdfPTable table, String label, String value, Font labelFont, Font valueFont) {
        PdfPCell lc = new PdfPCell(new Phrase(label, labelFont));
        lc.setBorder(0); lc.setPadding(4);
        PdfPCell vc = new PdfPCell(new Phrase(value, valueFont));
        vc.setBorder(0); vc.setPadding(4); vc.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(lc); table.addCell(vc);
    }
}
