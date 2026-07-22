import React, { useState, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { motion, AnimatePresence } from 'framer-motion';
import { orderService } from '../services/api';
import { addNotification } from '../redux/slices/notificationSlice';
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
  const dispatch = useDispatch();
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [cancellingId, setCancellingId] = useState(null);
  const [sendingId, setSendingId] = useState(null);
  const [toast, setToast] = useState(null);

  const showToast = (type, message) => {
    setToast({ type, message });
    setTimeout(() => setToast(null), 5000);
  };

  const handleDirectCancelOrder = async (order) => {
    setCancellingId(order.id);
    try {
      const defaultReason = 'Customer requested cancellation';
      const res = await orderService.cancelOrder(order.id, defaultReason);
      const pMethod = String(order.paymentMethod || '').toUpperCase();
      const isCOD = pMethod.includes('CASH') || pMethod.includes('COD');
      const nextPayStatus = isCOD || order.paymentStatus === 'PENDING' ? 'CANCELLED' : 'REFUNDED';

      const updatedOrder = res.data || { ...order, status: 'CANCELLED', paymentStatus: nextPayStatus, cancellationReason: defaultReason };

      generateCancellationReceipt(updatedOrder);

      setOrders((prev) =>
        prev.map((o) => (o.id === order.id ? { ...o, status: 'CANCELLED', paymentStatus: nextPayStatus, cancellationReason: defaultReason } : o))
      );

      dispatch(addNotification({
        type: 'cancel',
        title: `Order #${order.id} Cancelled ❌`,
        message: `Order #${order.id} was cancelled successfully. Receipt downloaded.`,
        link: '/orders'
      }));

      showToast('success', `❌ Order #${order.id} cancelled successfully.`);
    } catch (err) {
      const msg = err.response?.data?.message || 'Failed to cancel order.';
      showToast('error', msg);
    } finally {
      setCancellingId(null);
    }
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

      generateInvoice(currentOrder);

      dispatch(addNotification({
        type: 'invoice',
        title: `Invoice #${order.id} Downloaded 📄`,
        message: `Invoice PDF for Order #${order.id} was generated and email dispatched.`,
        link: '/orders'
      }));

      showToast('success', '✅ Invoice PDF downloaded! Email delivery dispatched.');

      orderService.sendGmailInvoice(order.id).catch((eErr) => {
        console.warn('Backend invoice email dispatch note:', eErr);
      });
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
    <div className="min-h-screen bg-slate-50 dark:bg-slate-900 py-8 px-4 transition-colors duration-300">
      {toast && (
        <div className={`fixed top-4 right-4 z-50 flex items-center gap-2 px-4 py-3 rounded-2xl shadow-xl text-xs font-bold text-white ${
          toast.type === 'error' ? 'bg-red-500' : 'bg-emerald-500'
        }`}>
          {toast.message}
        </div>
      )}



      <div className="max-w-4xl mx-auto">
        <h1 className="text-3xl font-black text-slate-800 dark:text-white mb-2">My Orders</h1>
        <p className="text-slate-400 text-sm mb-8">Track your live order progress and order history</p>

        {orders.length === 0 ? (
          <div className="bg-white dark:bg-slate-800 rounded-3xl p-12 text-center border border-slate-100 dark:border-slate-700">
            <div className="text-6xl mb-4">🛍️</div>
            <h3 className="text-xl font-bold text-slate-800 dark:text-white mb-2">No orders found</h3>
            <p className="text-slate-400 text-sm mb-6">Looks like you haven't placed any food orders yet.</p>
            <a href="/home" className="bg-primary text-white px-6 py-3 rounded-xl font-bold text-sm hover:bg-primary-dark transition-all inline-block">
              Explore Restaurants
            </a>
          </div>
        ) : (
          <div className="space-y-6">
            {orders.map((order, idx) => {
              const currentNorm = normalizeStatus(order.status);
              const activeIndex = STATUS_STEPS.indexOf(currentNorm);
              const isCancelled = currentNorm === 'CANCELLED';
              const isDelivered = currentNorm === 'DELIVERED';
              const isCancellable = !isCancelled;
              const currentConf = statusConfig[currentNorm] || statusConfig.ORDER_PLACED;

              return (
                <motion.div
                  key={order.id}
                  layout
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: idx * 0.08 }}
                  className="bg-white dark:bg-slate-800 rounded-3xl shadow-sm hover:shadow-md transition-all border border-slate-100 dark:border-slate-700 overflow-hidden"
                >
                  <div className="p-6 border-b border-slate-100 dark:border-slate-700 flex flex-wrap items-center justify-between gap-4">
                    <div>
                      <div className="flex items-center gap-3">
                        <span className="text-xs font-bold text-slate-400">Order #{order.id}</span>
                        <span className="text-xs text-slate-300">•</span>
                        <span className="text-xs text-slate-400">
                          {new Date(order.createdAt || Date.now()).toLocaleDateString()}
                        </span>
                      </div>
                      <h3 className="text-xl font-black text-slate-800 dark:text-white mt-1">
                        {order.restaurant?.name || 'Restaurant'}
                      </h3>
                      <div className="flex items-center gap-2 text-xs text-slate-400 mt-1">
                        <span>Payment: <strong className="text-slate-600 dark:text-slate-300">{order.paymentMethod}</strong></span>
                        <span>•</span>
                        <span>Status: <strong className={order.paymentStatus === 'PAID' ? 'text-green-500' : 'text-amber-500'}>{order.paymentStatus}</strong></span>
                        {order.cancellationReason && (
                          <>
                            <span>•</span>
                            <span className="text-red-400">Reason: {order.cancellationReason}</span>
                          </>
                        )}
                      </div>
                    </div>

                    <div className="text-right">
                      <div className={`inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-bold ${currentConf.bg} ${currentConf.color}`}>
                        {currentConf.icon}
                        {currentConf.label}
                      </div>
                      <p className="text-xl font-black text-primary mt-2">${Number(order.totalAmount || 0).toFixed(2)}</p>
                    </div>
                  </div>

                  <div className="p-6">
                    {isCancelled ? (
                      <div className="bg-red-50 dark:bg-red-950/20 border border-red-100 dark:border-red-900/30 rounded-2xl p-4 flex items-center gap-3 text-red-500 mb-6">
                        <FaTimes className="text-xl" />
                        <div>
                          <p className="text-xs font-bold">This order was cancelled</p>
                          <p className="text-[11px] text-red-400 mt-0.5">
                            {order.cancellationReason ? `Reason: ${order.cancellationReason}` : 'No payment was deducted or funds have been refunded.'}
                          </p>
                        </div>
                      </div>
                    ) : (
                      <div className="flex items-center justify-between mb-8 overflow-x-auto pb-2">
                        {STATUS_STEPS.map((s, i) => {
                          const stepConf = statusConfig[s];
                          const done = i <= activeIndex;
                          const active = i === activeIndex;
                          const stageTime = getStageTimestamp(s, order);

                          return (
                            <React.Fragment key={s}>
                              <div className="flex flex-col items-center min-w-[70px] text-center">
                                <div className={`w-8 h-8 rounded-full flex items-center justify-center text-xs transition-all ${
                                  done
                                    ? 'bg-green-500 text-white shadow-md shadow-green-500/20 scale-105'
                                    : 'bg-slate-100 dark:bg-slate-700 text-slate-400'
                                }`}>
                                  {done ? <FaCheckCircle /> : i + 1}
                                </div>
                                <p className={`text-[10px] font-bold mt-2 transition-colors ${
                                  active ? 'text-slate-800 dark:text-white font-black' : done ? 'text-green-600 dark:text-green-400' : 'text-slate-400'
                                }`}>
                                  {stepConf.label}
                                </p>
                                {(done || active) && stageTime && (
                                  <span className="text-[9px] text-slate-400 mt-0.5 font-medium">{stageTime}</span>
                                )}
                              </div>
                              {i < STATUS_STEPS.length - 1 && (
                                <div className={`flex-1 h-0.5 mx-2 min-w-[20px] ${i < activeIndex ? 'bg-green-500' : 'bg-slate-100 dark:bg-slate-700'}`} />
                              )}
                            </React.Fragment>
                          );
                        })}
                      </div>
                    )}

                    <div className="flex items-center justify-between border-t border-slate-100 dark:border-slate-700 pt-4">
                      <div className="flex items-center gap-2">
                        {isDelivered && (
                          <button className="flex items-center gap-1.5 text-xs font-bold text-slate-500 dark:text-slate-400 hover:text-primary transition-colors px-3 py-1.5 rounded-lg hover:bg-primary/5">
                            <FaStar className="text-amber-400" /> Rate Order
                          </button>
                        )}
                        {isCancellable && (
                          <button
                            onClick={() => handleDirectCancelOrder(order)}
                            disabled={cancellingId === order.id}
                            className="flex items-center gap-1.5 text-xs font-bold text-white bg-red-500 hover:bg-red-600 transition-all px-4 py-2 rounded-xl shadow-sm shadow-red-500/20 disabled:opacity-60 disabled:cursor-not-allowed"
                          >
                            {cancellingId === order.id ? <FaSpinner className="animate-spin" /> : <FaTimes />}
                            {cancellingId === order.id ? 'Cancelling...' : 'Cancel Order'}
                          </button>
                        )}
                      </div>

                      {isCancelled ? (
                        <button
                          onClick={() => generateCancellationReceipt(order)}
                          className="flex items-center gap-1.5 text-xs font-bold text-white bg-slate-800 hover:bg-slate-900 transition-all px-4 py-2 rounded-xl shadow-sm"
                        >
                          <FaFileDownload /> Cancellation Receipt
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
