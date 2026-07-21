import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

/**
 * Generates and downloads a Cancellation Receipt PDF for ByteBurst orders.
 * @param {Object} order - The order object
 */
export function generateCancellationReceipt(order) {
  const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
  const pageWidth = doc.internal.pageSize.getWidth();
  const pageHeight = doc.internal.pageSize.getHeight();
  const margin = 20;

  // --- Header (Dark Gray / Red Accent) ---
  doc.setFillColor(220, 38, 38); // Red banner for cancellation
  doc.rect(0, 0, pageWidth, 42, 'F');

  doc.setTextColor(255, 255, 255);
  doc.setFontSize(24);
  doc.setFont('helvetica', 'bold');
  doc.text('ByteBurst', margin, 18);

  doc.setFontSize(8.5);
  doc.setFont('helvetica', 'normal');
  doc.text('123 Food Street, Suite 500, Tech City, NY 10001', margin, 25);
  doc.text('Support: support@byteburst.com | Phone: +1 (800) 555-BITE', margin, 31);

  doc.setFontSize(18);
  doc.setFont('helvetica', 'bold');
  doc.text('CANCELLATION RECEIPT', pageWidth - margin, 20, { align: 'right' });

  doc.setFontSize(9);
  doc.setFont('helvetica', 'normal');
  doc.text('Order #' + order.id, pageWidth - margin, 28, { align: 'right' });

  // --- Customer & Order Info ---
  const metaY = 52;

  doc.setFontSize(8.5);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(150, 150, 150);
  doc.text('CUSTOMER INFORMATION', margin, metaY);

  const customerName = order.user?.name || order.customer?.name || order.customerName || 'Customer';
  const customerEmail = order.user?.email || order.customer?.email || 'Registered User';

  doc.setFont('helvetica', 'bold');
  doc.setFontSize(10.5);
  doc.setTextColor(30, 30, 30);
  doc.text(customerName, margin, metaY + 7);

  doc.setFont('helvetica', 'normal');
  doc.setFontSize(9);
  doc.setTextColor(90, 90, 90);
  doc.text(customerEmail, margin, metaY + 13);

  const rightX = pageWidth - margin;
  doc.setFontSize(8.5);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(150, 150, 150);
  doc.text('TRANSACTION DETAILS', rightX, metaY, { align: 'right' });

  doc.setFont('helvetica', 'normal');
  doc.setTextColor(60, 60, 60);

  const orderDate = new Date(order.createdAt || Date.now()).toLocaleString('en-US', {
    month: 'short', day: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit'
  });

  const details = [
    ['Order ID', '#' + order.id],
    ['Order Date & Time', orderDate],
    ['Payment Method', order.paymentMethod || 'UPI'],
    ['Payment Status', 'FAILED'],
    ['Order Status', 'CANCELLED'],
    ['Reason', 'Payment Transaction Failed'],
  ];

  details.forEach(([label, value], i) => {
    const y = metaY + 7 + i * 6.5;
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(8.5);
    doc.text(label + ':', rightX - 65, y);
    doc.setFont('helvetica', 'bold');
    if (label === 'Payment Status' || label === 'Order Status') {
      doc.setTextColor(220, 38, 38);
    } else {
      doc.setTextColor(60, 60, 60);
    }
    doc.text(value, rightX, y, { align: 'right' });
    doc.setTextColor(60, 60, 60);
  });

  // --- Notice Box ---
  const noticeY = metaY + 52;
  doc.setFillColor(254, 242, 242);
  doc.setDrawColor(254, 202, 202);
  doc.roundedRect(margin, noticeY, pageWidth - margin * 2, 18, 2, 2, 'FD');

  doc.setFontSize(9);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(185, 28, 28);
  doc.text('ATTENTION: TRANSACTION FAILED', margin + 4, noticeY + 6);

  doc.setFont('helvetica', 'normal');
  doc.setFontSize(8);
  doc.setTextColor(127, 29, 29);
  doc.text('This order was cancelled because the payment transaction could not be processed.', margin + 4, noticeY + 11);
  doc.text('No funds were charged to your bank account or payment method.', margin + 4, noticeY + 15);

  // --- Items Table ---
  const tableStartY = noticeY + 24;
  const items = (order.items || []).map((item) => {
    const itemName = item.foodItem?.name || item.name || 'Food Item';
    const unitPrice = Number(item.price ?? item.foodItem?.price ?? 0);
    const qty = Number(item.quantity ?? 1);
    return [itemName, qty, '$' + unitPrice.toFixed(2), '$' + (unitPrice * qty).toFixed(2)];
  });

  autoTable(doc, {
    startY: tableStartY,
    head: [['Item Name', 'Quantity', 'Unit Price', 'Total']],
    body: items,
    margin: { left: margin, right: margin },
    styles: { fontSize: 8.5, cellPadding: 4 },
    headStyles: { fillColor: [100, 116, 139], textColor: [255, 255, 255], fontStyle: 'bold' },
    columnStyles: {
      0: { cellWidth: 'auto' },
      1: { cellWidth: 25, halign: 'center' },
      2: { cellWidth: 35, halign: 'right' },
      3: { cellWidth: 35, halign: 'right' },
    },
  });

  // --- Footer Note ---
  const footerY = pageHeight - 20;
  doc.setDrawColor(230, 230, 230);
  doc.line(margin, footerY - 5, pageWidth - margin, footerY - 5);

  doc.setFont('helvetica', 'bold');
  doc.setFontSize(9);
  doc.setTextColor(100, 116, 139);
  doc.text('ByteBurst Customer Support: support@byteburst.com', pageWidth / 2, footerY, { align: 'center' });

  const filename = 'FoodOrder-CancellationReceipt-' + String(order.id).padStart(6, '0') + '.pdf';
  doc.save(filename);
}
