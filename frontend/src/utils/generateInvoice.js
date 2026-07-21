import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

/**
 * Generates and downloads a professional PDF invoice for ByteBurst.
 * @param {Object} order - The order object
 */
export function generateInvoice(order) {
  const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
  const pageWidth = doc.internal.pageSize.getWidth();
  const pageHeight = doc.internal.pageSize.getHeight();
  const margin = 20;

  // --- Brand Header (ByteBurst) ---
  doc.setFillColor(255, 107, 53); // ByteBurst primary orange
  doc.rect(0, 0, pageWidth, 42, 'F');

  doc.setTextColor(255, 255, 255);
  doc.setFontSize(24);
  doc.setFont('helvetica', 'bold');
  doc.text('ByteBurst', margin, 18);

  doc.setFontSize(8.5);
  doc.setFont('helvetica', 'normal');
  doc.text('123 Food Street, Suite 500, Tech City, NY 10001', margin, 25);
  doc.text('Support: support@byteburst.com | Phone: +1 (800) 555-BITE', margin, 31);

  doc.setFontSize(20);
  doc.setFont('helvetica', 'bold');
  doc.text('INVOICE', pageWidth - margin, 20, { align: 'right' });

  const invoiceNo = 'INV-' + String(order.id).padStart(6, '0');
  doc.setFontSize(9);
  doc.setFont('helvetica', 'normal');
  doc.text('#' + invoiceNo, pageWidth - margin, 28, { align: 'right' });

  // --- Customer & Invoice Details ---
  const metaY = 52;
  doc.setTextColor(60, 60, 60);

  // Bill To (Customer Info)
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
  if (order.deliveryAddress) {
    const addrLines = doc.splitTextToSize('Delivery: ' + order.deliveryAddress, 85);
    doc.text(addrLines, margin, metaY + 19);
  }

  // Order Details Right Column
  const rightX = pageWidth - margin;
  doc.setFontSize(8.5);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(150, 150, 150);
  doc.text('INVOICE INFORMATION', rightX, metaY, { align: 'right' });

  doc.setFont('helvetica', 'normal');
  doc.setTextColor(60, 60, 60);

  const orderDate = new Date(order.createdAt || Date.now()).toLocaleString('en-US', {
    month: 'short', day: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit'
  });

  let payStatus = order.paymentStatus;
  if (order.status === 'DELIVERED') {
    payStatus = 'PAID';
  } else if (!payStatus) {
    if (order.paymentMethod === 'Cash on Delivery' || order.paymentMethod === 'COD') {
      payStatus = 'PENDING';
    } else {
      payStatus = 'PAID';
    }
  }

  const details = [
    ['Invoice Number', invoiceNo],
    ['Order ID', '#' + order.id],
    ['Order Date & Time', orderDate],
    ['Payment Method', order.paymentMethod || 'UPI'],
    ['Payment Status', payStatus],
    ['Order Status', (order.status || 'ORDER_PLACED').replace(/_/g, ' ')],
  ];

  details.forEach(([label, value], i) => {
    const y = metaY + 7 + i * 6.5;
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(8.5);
    doc.text(label + ':', rightX - 65, y);
    doc.setFont('helvetica', 'normal');
    doc.text(value, rightX, y, { align: 'right' });
  });

  // --- Restaurant Info ---
  const restY = metaY + 52;
  doc.setFillColor(250, 250, 250);
  doc.setDrawColor(230, 230, 230);
  doc.roundedRect(margin, restY, pageWidth - margin * 2, 15, 2, 2, 'FD');

  doc.setFontSize(8);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(150, 150, 150);
  doc.text('RESTAURANT', margin + 4, restY + 5.5);
  doc.setFont('helvetica', 'bold');
  doc.setFontSize(10);
  doc.setTextColor(30, 30, 30);
  doc.text(order.restaurant?.name || 'ByteBurst Partner Kitchen', margin + 4, restY + 11.5);

  // --- Ordered Items Table ---
  const tableStartY = restY + 22;

  const items = (order.items || []).map((item) => {
    const itemName = item.foodItem?.name || item.name || 'Food Item';
    const unitPrice = Number(item.price ?? item.foodItem?.price ?? 0);
    const qty = Number(item.quantity ?? 1);
    const subtotal = unitPrice * qty;
    return [
      itemName,
      qty,
      '$' + unitPrice.toFixed(2),
      '$' + subtotal.toFixed(2),
    ];
  });

  autoTable(doc, {
    startY: tableStartY,
    head: [['Item Name', 'Quantity', 'Unit Price', 'Total']],
    body: items,
    margin: { left: margin, right: margin },
    styles: {
      fontSize: 9,
      cellPadding: { top: 4, bottom: 4, left: 4, right: 4 },
      lineColor: [230, 230, 230],
      lineWidth: 0.3,
    },
    headStyles: {
      fillColor: [255, 107, 53],
      textColor: [255, 255, 255],
      fontStyle: 'bold',
      halign: 'left',
    },
    columnStyles: {
      0: { cellWidth: 'auto' },
      1: { cellWidth: 25, halign: 'center' },
      2: { cellWidth: 35, halign: 'right' },
      3: { cellWidth: 35, halign: 'right', fontStyle: 'bold' },
    },
    alternateRowStyles: { fillColor: [252, 252, 252] },
  });

  // --- Pricing Breakdown ---
  const afterTableY = doc.lastAutoTable.finalY + 4;
  const totalsX = pageWidth - margin - 75;

  const subtotalAmt = (order.items || []).reduce((sum, item) => {
    const price = Number(item.price ?? item.foodItem?.price ?? 0);
    return sum + price * Number(item.quantity ?? 1);
  }, 0);

  const deliveryFee = 4.00;
  const gstAmt = subtotalAmt * 0.05;
  const grandTotal = Number(order.totalAmount || (subtotalAmt + deliveryFee + gstAmt));

  let rowOffset = 0;
  const drawRow = (label, value, bold, accent) => {
    rowOffset += 7;
    const rowY = afterTableY + rowOffset;
    doc.setFont('helvetica', bold ? 'bold' : 'normal');
    if (accent) {
      doc.setFillColor(255, 107, 53);
      doc.rect(totalsX - 4, rowY - 5, pageWidth - margin - totalsX + 4, 8, 'F');
      doc.setTextColor(255, 255, 255);
    } else {
      doc.setTextColor(60, 60, 60);
    }
    doc.setFontSize(9);
    doc.text(label, totalsX, rowY);
    doc.text(value, pageWidth - margin, rowY, { align: 'right' });
    doc.setTextColor(60, 60, 60);
  };

  drawRow('Subtotal', '$' + subtotalAmt.toFixed(2));
  drawRow('Delivery Fee', '$' + deliveryFee.toFixed(2));
  drawRow('GST (5%)', '$' + gstAmt.toFixed(2));

  const divY = afterTableY + rowOffset + 4;
  doc.setDrawColor(200, 200, 200);
  doc.line(totalsX - 4, divY, pageWidth - margin, divY);
  rowOffset += 3;

  drawRow('Grand Total', '$' + grandTotal.toFixed(2), true, true);

  // --- Footer ---
  const footerY = pageHeight - 20;
  doc.setDrawColor(230, 230, 230);
  doc.line(margin, footerY - 5, pageWidth - margin, footerY - 5);

  doc.setFont('helvetica', 'bold');
  doc.setFontSize(9);
  doc.setTextColor(255, 107, 53);
  doc.text('Thank you for ordering with ByteBurst.', pageWidth / 2, footerY, { align: 'center' });

  doc.setFont('helvetica', 'normal');
  doc.setFontSize(7.5);
  doc.setTextColor(150, 150, 150);
  doc.text('ByteBurst Inc. © ' + new Date().getFullYear() + ' | support@byteburst.com', pageWidth / 2, footerY + 5, { align: 'center' });

  // --- Save File ---
  const filename = 'FoodOrder-Invoice-' + String(order.id).padStart(6, '0') + '.pdf';
  doc.save(filename);
}
