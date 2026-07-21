import React, { useState, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { orderService } from '../services/api';
import { FaCheckCircle, FaHourglassHalf, FaBoxOpen, FaMotorcycle, FaStar, FaSpinner, FaTimes, FaUtensils, FaStore, FaClock, FaDownload, FaFileDownload, FaExclamationTriangle } from 'react-icons/fa';
import SkeletonLoader from '../components/SkeletonLoader';
import { generateInvoice } from '../utils/generateInvoice';
import { generateCancellationReceipt } from '../utils/generateCancellationReceipt';

const STATUS_STEPS = [
  'ORDER_PLACED',
  'PAYMENT_PROCESSING',
  'RESTAURANT_ACCEPTED',
  'KITCHEN_PREPARING',
  'OUT_FOR_DELIVERY',
  'DELIVERED'
];

const statusConfig = {
  ORDER_PLACED: { icon: <FaBoxOpen />, color: 'text-blue-500', bg: 'bg-blue-50 dark:bg-blue-950/20', label: 'Order Placed' },
  PAYMENT_PROCESSING: { icon: <FaHourglassHalf />, color: 'text-purple-500', bg: 'bg-purple-50 dark:bg-purple-950/20', label: 'Payment Processing' },
  RESTAURANT_ACCEPTED: { icon: <FaStore />, color: 'text-indigo-500', bg: 'bg-indigo-50 dark:bg-indigo-950/20', label: 'Restaurant Accepted' },
  KITCHEN_PREPARING: { icon: <FaUtensils />, color: 'text-amber-500', bg: 'bg-amber-50 dark:bg-orange-950/20', label: 'Kitchen Preparing' },
  OUT_FOR_DELIVERY: { icon: <FaMotorcycle />, color: 'text-primary', bg: 'bg-orange-50 dark:bg-orange-950/20', label: 'Out for Delivery' },
  DELIVERED: { icon: <FaCheckCircle />, color: 'text-green-500', bg: 'bg-green-50 dark:bg-green-950/20', label: 'Delivered' },
  CANCELLED: { icon: <FaTimes className="text-red-500" />, color: 'text-red-500', bg: 'bg-red-50 dark:bg-red-950/20', label: 'Cancelled' }
};

const normalizeStatus = (status) => {
  if (!status) return 'ORDER_PLACED';
  const u = status.toUpperCase();
  if (u === 'PLACED') return 'ORDER_PLACED';
  if (u === 'KITCHEN_PREP' || u === 'PREPARING') return 'KITCHEN_PREPARING';
  return u;
};

const getStageTimestamp = (s, order) => {
  let rawDate = null;
  switch (s) {
    case 'ORDER_PLACED':
      rawDate = order.orderPlacedAt || order.createdAt;
      break;
    case 'PAYMENT_PROCESSING':
      rawDate = order.paymentProcessingAt || order.paymentProcessedAt;
      break;
    case 'RESTAURANT_ACCEPTED':
      rawDate = order.restaurantAcceptedAt;
      break;
    case 'KITCHEN_PREPARING':
      rawDate = order.kitchenPreparingAt;
      break;
    case 'OUT_FOR_DELIVERY':
      rawDate = order.outForDeliveryAt;
      break;
    case 'DELIVERED':
      rawDate = order.deliveredAt;
      break;
  }
  if (!rawDate) return null;
  return new Date(rawDate).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
};

export default function OrdersPage() {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [sendingId, setSendingId] = useState(null);
  const [toast, setToast] = useState(null);

  const showToast = (type, message) => {
    setToast({ type, message });
    setTimeout(() => setToast(null), 5000);
  };

  const handleInvoiceDownload = async (order) => {
    setSendingId(order.id);
    try {
      let currentOrder = order;
      try {
        const freshRes = await orderService.getOrderById(order.id);
        if (freshRes.data) {
          currentOrder = freshRes.data;
        }
      } catch (fErr) {
        console.warn('Could not fetch fresh order data, using current view state', fErr);
      }

      // 1. Download PDF locally in browser
      generateInvoice(currentOrder);

      // 2. Trigger backend API to send PDF invoice email to registered email address
      try {
        await orderService.sendGmailInvoice(order.id);
        showToast('success', '✅ Invoice PDF downloaded & emailed to your registered email address!');
      } catch (eErr) {
        console.warn('Backend invoice email request note:', eErr);
        showToast('success', '✅ Invoice PDF downloaded successfully.');
      }
    } catch (err) {
      showToast('error', 'Failed to generate invoice PDF.');
    } finally {
      setSendingId(null);
    }
  };

  useEffect(() => {
    const fetchOrders = () => {
      orderService.getMyOrders()
        .then((res) => {
          setOrders(Array.isArray(res.data) ? res.data : []);
        })
        .catch(() => setOrders([]))
        .finally(() => setLoading(false));
    };

    fetchOrders();
    const interval = setInterval(fetchOrders, 2000);
    return () => clearInterval(interval);
  }, []);

  if (loading) {
    return <div className="max-w-4xl mx-auto px-4 py-8"><SkeletonLoader type="list" count={3} /></div>;
  }

  return (
    <div className="min-h-screen bg-[#F8F9FA] dark:bg-slate-900 py-8">

      {/* Toast Notification */}
      <AnimatePresence>
        {toast && (
          <motion.div
            key="toast"
            initial={{ opacity: 0, y: -60 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -60 }}
            transition={{ type: 'spring', stiffness: 300, damping: 25 }}
            className={`fixed top-6 left-1/2 -translate-x-1/2 z-50 flex items-center gap-3 px-5 py-3.5 rounded-2xl shadow-2xl min-w-[300px] max-w-[90vw] ${
              toast.type === 'success'
                ? 'bg-green-500 text-white'
                : toast.type === 'info'
                ? 'bg-blue-500 text-white'
                : 'bg-red-500 text-white'
            }`}
          >
            <FaCheckCircle className="text-white text-base flex-shrink-0" />
            <span className="text-sm font-semibold flex-1">{toast.message}</span>
            <button onClick={() => setToast(null)} className="ml-2 hover:opacity-70 transition-opacity">
              <FaTimes />
            </button>
          </motion.div>
        )}
      </AnimatePresence>

      <div className="max-w-4xl mx-auto px-4">
        <h1 className="text-2xl font-black text-slate-800 dark:text-white mb-2">My Orders</h1>
        <p className="text-slate-400 text-sm mb-8">Track your live order progress and order history</p>

        {orders.length === 0 ? (
          <div className="text-center py-24 bg-white dark:bg-slate-800 rounded-3xl border border-slate-100 dark:border-slate-700">
            <div className="text-6xl mb-4">📦</div>
            <h3 className="text-xl font-black text-slate-700 dark:text-slate-300">No orders yet</h3>
            <p className="text-slate-400 mt-2 mb-6">Your order history will appear here</p>
            <a href="/home" className="bg-primary text-white px-8 py-3 rounded-xl font-bold hover:bg-primary-dark transition-all inline-block">Browse Restaurants</a>
          </div>
        ) : (
          <div className="space-y-6">
            {orders.map((order, idx) => {
              const normStatus = normalizeStatus(order.status);
              const stepIdx = STATUS_STEPS.indexOf(normStatus);
              const config = statusConfig[normStatus] || statusConfig.ORDER_PLACED;
              const isDelivered = normStatus === 'DELIVERED';
              const isCancelled = normStatus === 'CANCELLED' || order.paymentStatus === 'FAILED';

              const safeTotal = Number(order.totalAmount || 0);
              const payStatus = isCancelled ? 'FAILED' : (order.paymentStatus || (order.paymentMethod === 'Cash on Delivery' || order.paymentMethod === 'COD' ? (isDelivered ? 'PAID' : 'PENDING') : 'PAID'));
              const baseDate = new Date(order.createdAt || Date.now());

              return (
                <motion.div key={order.id} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: idx * 0.08 }}
                  className="bg-white dark:bg-slate-800 rounded-3xl border border-slate-100 dark:border-slate-700 shadow-sm overflow-hidden">

                  {/* Order Header */}
                  <div className="flex items-center justify-between p-5 border-b border-slate-100 dark:border-slate-700">
                    <div>
                      <p className="text-xs text-slate-400 mb-0.5">Order #{order.id} • {baseDate.toLocaleDateString()}</p>
                      <h3 className="text-lg font-black text-slate-800 dark:text-white">{order.restaurant?.name || 'ByteBurst Partner Kitchen'}</h3>
                      <div className="flex items-center gap-3 text-xs text-slate-400 mt-1">
                        <span>Payment: <strong className="text-slate-600 dark:text-slate-300">{order.paymentMethod || 'UPI'}</strong></span>
                        <span>•</span>
                        <span>Status: <strong className={payStatus === 'PAID' ? 'text-green-500 font-bold' : payStatus === 'FAILED' ? 'text-red-500 font-bold' : 'text-amber-500 font-bold'}>{payStatus}</strong></span>
                        {!isCancelled && (
                          <>
                            <span>•</span>
                            <span className="flex items-center gap-1">
                              <FaClock className="text-primary" />
                              {isDelivered ? <strong className="text-green-500">Delivered</strong> : <strong>Est: 25–35 mins</strong>}
                            </span>
                          </>
                        )}
                      </div>
                    </div>
                    <div className="text-right">
                      <span className={`inline-flex items-center gap-1.5 text-xs font-black px-3 py-1.5 rounded-full ${isCancelled ? 'bg-red-50 text-red-500 dark:bg-red-950/20' : isDelivered ? 'bg-green-50 text-green-500 dark:bg-green-950/20' : config.bg + ' ' + config.color}`}>
                        {isCancelled ? <FaExclamationTriangle /> : isDelivered ? <FaCheckCircle /> : config.icon} {isCancelled ? 'Cancelled' : isDelivered ? 'Delivered' : config.label}
                      </span>
                      <p className="text-lg font-black text-slate-800 dark:text-white mt-2">${safeTotal.toFixed(2)}</p>
                    </div>
                  </div>

                  {/* Body Content */}
                  <div className="p-5">
                    {isCancelled ? (
                      <div className="bg-red-50 dark:bg-red-950/20 border border-red-100 dark:border-red-900/50 rounded-2xl p-4 text-center mb-5">
                        <span className="text-red-500 text-2xl block mb-1">❌</span>
                        <h4 className="font-bold text-red-600 dark:text-red-400 text-sm">Order Cancelled</h4>
                        <p className="text-xs text-red-500/80">Reason: Payment Transaction Failed</p>
                      </div>
                    ) : (
                      /* Timeline */
                      <div className="flex items-center gap-1 overflow-x-auto pb-4 mb-5">
                        {STATUS_STEPS.map((s, i) => {
                          let done = false;
                          let active = false;

                          if (isDelivered) {
                            done = true;
                            active = false;
                          } else if (stepIdx <= 0) { // ORDER_PLACED state
                            done = i === 0;
                            active = i === 1; // PAYMENT_PROCESSING is active
                          } else {
                            done = i < stepIdx;
                            active = i === stepIdx;
                          }

                          const stepConf = statusConfig[s] || {};
                          const stageTime = getStageTimestamp(s, order);

                          return (
                            <React.Fragment key={s}>
                              <div className="flex flex-col items-center text-center min-w-[105px]">
                                <div className={`w-9 h-9 rounded-full flex items-center justify-center text-xs border-2 transition-all ${
                                  done
                                    ? 'border-green-500 bg-green-500 text-white'
                                    : active
                                    ? 'border-primary bg-primary text-white scale-110 shadow-lg shadow-primary/30 animate-pulse ring-4 ring-primary/20'
                                    : 'border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 text-slate-400'
                                }`}>
                                  {done ? '✓' : stepConf.icon || (i + 1)}
                                </div>
                                <p className={`text-[10px] mt-2 font-bold whitespace-nowrap ${
                                  done ? 'text-green-500 font-bold' : active ? 'text-primary font-black scale-105' : 'text-slate-400'
                                }`}>
                                  {stepConf.label}
                                </p>
                                {(done || active) && stageTime && (
                                  <span className="text-[9px] text-slate-400 mt-0.5 font-medium">{stageTime}</span>
                                )}
                              </div>
                              {i < STATUS_STEPS.length - 1 && (
                                <div className={`flex-1 h-1 min-w-[20px] rounded-full transition-all ${
                                  done ? 'bg-green-500' : 'bg-slate-200 dark:bg-slate-700'
                                }`}></div>
                              )}
                            </React.Fragment>
                          );
                        })}
                      </div>
                    )}

                    {/* Ordered Items */}
                    <div className="space-y-2 mb-4 bg-slate-50 dark:bg-slate-900/50 p-4 rounded-2xl border border-slate-100 dark:border-slate-700/50">
                      <p className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Order Items</p>
                      {order.items?.map((item, itemIdx) => {
                        const foodName = item.foodItem?.name || item.name || 'Food Item';
                        const itemPrice = Number(item.price ?? item.foodItem?.price ?? 0);
                        const quantity = Number(item.quantity ?? 1);
                        const subtotal = (itemPrice * quantity).toFixed(2);

                        return (
                          <div key={item.id || itemIdx} className="flex items-center justify-between text-xs text-slate-500 dark:text-slate-400">
                            <span className="font-semibold text-slate-700 dark:text-slate-300">{foodName} x{quantity}</span>
                            <span className="font-bold text-slate-700 dark:text-slate-200">${subtotal}</span>
                          </div>
                        );
                      })}
                    </div>

                    {/* Actions */}
                    <div className="flex items-center justify-between border-t border-slate-100 dark:border-slate-700 pt-4">
                      <div>
                        {isDelivered && (
                          <button className="flex items-center gap-1.5 text-xs font-bold text-slate-500 dark:text-slate-400 hover:text-primary transition-colors px-3 py-1.5 rounded-lg hover:bg-primary/5">
                            <FaStar className="text-amber-400" /> Rate Order
                          </button>
                        )}
                      </div>

                      {isCancelled ? (
                        <button
                          onClick={() => generateCancellationReceipt(order)}
                          className="flex items-center gap-1.5 text-xs font-bold text-white bg-slate-800 hover:bg-slate-900 transition-all px-4 py-2 rounded-xl shadow-sm"
                        >
                          <FaFileDownload /> Download Cancellation Receipt
                        </button>
                      ) : (
                        <button
                          onClick={() => handleInvoiceDownload(order)}
                          disabled={sendingId === order.id}
                          className="flex items-center gap-1.5 text-xs font-bold text-white bg-primary hover:bg-orange-600 transition-all px-4 py-2 rounded-xl shadow-sm shadow-primary/30 disabled:opacity-60 disabled:cursor-not-allowed"
                        >
                          {sendingId === order.id
                            ? <FaSpinner className="animate-spin" />
                            : <FaDownload />}
                          {sendingId === order.id ? 'Downloading...' : 'Invoice'}
                        </button>
                      )}
                    </div>
                  </div>
                </motion.div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
