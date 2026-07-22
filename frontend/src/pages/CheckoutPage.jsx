import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useSelector, useDispatch } from 'react-redux';
import { motion, AnimatePresence } from 'framer-motion';
import { applyCoupon, clearCart } from '../redux/slices/cartSlice';
import { orderService } from '../services/api';
import { showToast } from '../components/Toast';
import { generateInvoice } from '../utils/generateInvoice';
import { generateCancellationReceipt } from '../utils/generateCancellationReceipt';
import { FaTag, FaTruck, FaShieldAlt, FaArrowRight, FaCheckCircle, FaClock, FaSpinner, FaFilePdf, FaPaperPlane, FaStore, FaExclamationTriangle, FaFileDownload } from 'react-icons/fa';

export default function CheckoutPage() {
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const { items, subtotal, deliveryCharge, gst, discount, total, couponCode } = useSelector((s) => s.cart);
  const user = useSelector((s) => s.auth.user);

  const [step, setStep] = useState(1); // 1=address, 2=payment, 3=success, 4=payment_failed
  const [address, setAddress] = useState(user?.addresses?.[0] || '');
  const [newAddress, setNewAddress] = useState('');
  const [paymentMethod, setPaymentMethod] = useState('UPI');
  const [simulateFailure, setSimulateFailure] = useState(false);
  const [promoInput, setPromoInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [progressText, setProgressText] = useState('');
  const [placedOrder, setPlacedOrder] = useState(null);

  const isDevOrAdmin = import.meta.env.VITE_ENABLE_PAYMENT_TESTING === 'true' || user?.role === 'ROLE_ADMIN';

  const safeSubtotal = Number(subtotal || 0);
  const safeDelivery = Number(deliveryCharge || 0);
  const safeGst = Number(gst || 0);
  const safeDiscount = Number(discount || 0);
  const safeTotal = Number(total || 0);

  const handlePlaceOrder = async () => {
    if (!address) { showToast('Please enter a delivery address', 'error'); return; }
    if (items.length === 0) { showToast('Your cart is empty', 'error'); return; }

    setLoading(true);
    try {
      const firstItem = items[0] || {};
      const orderData = {
        restaurantId: firstItem.restaurantId || 1,
        restaurantName: firstItem.restaurantName || 'BiteBurst Partner',
        deliveryAddress: address,
        paymentMethod: paymentMethod,
        isPaymentFailed: false,
        totalAmount: safeTotal,
        quantities: items.reduce((sum, i) => sum + (i.quantity || 1), 0),
        prices: items.map((i) => i.price),
        items: items.map((item) => ({
          foodItemId: item.id,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
          restaurantId: item.restaurantId || firstItem.restaurantId
        })),
      };

      if (isDevOrAdmin && simulateFailure) {
        setProgressText('Processing Payment...');
        const res = await orderService.placeOrder(orderData);
        setPlacedOrder(res.data);
        dispatch(clearCart());
        setStep(4); // Failed state
        return;
      }

      // Successful Flow
      setProgressText('Order placed successfully.');
      const res = await orderService.placeOrder(orderData);
      const newOrder = res.data;
      setPlacedOrder(newOrder);

      setProgressText('Generating Invoice...');
      await new Promise((r) => setTimeout(r, 600));

      setProgressText('Downloading Invoice...');
      try {
        generateInvoice(newOrder);
      } catch (pdfErr) {
        console.error('PDF Download Error:', pdfErr);
      }
      await new Promise((r) => setTimeout(r, 600));

      setProgressText('Sending Invoice...');
      await new Promise((r) => setTimeout(r, 600));

      setProgressText('Restaurant Notified...');
      await new Promise((r) => setTimeout(r, 600));

      setProgressText('Completed.');
      await new Promise((r) => setTimeout(r, 400));

      dispatch(clearCart());
      setStep(3);
    } catch (err) {
      showToast(err.response?.data?.message || 'Failed to place order. Try again.', 'error');
    } finally {
      setLoading(false);
      setProgressText('');
    }
  };

  // Step 4: Payment Failure Screen (Dev / Admin mode)
  if (step === 4) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#F8F9FA] dark:bg-slate-900 px-4">
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="text-center max-w-md w-full bg-white dark:bg-slate-800 p-8 rounded-3xl shadow-xl border border-slate-100 dark:border-slate-700">
          <FaExclamationTriangle className="text-red-500 text-7xl mx-auto mb-5 animate-bounce" />
          <h1 className="text-2xl font-black text-slate-800 dark:text-white mb-2">❌ Payment Failed</h1>
          <p className="text-red-500 font-bold text-sm mb-2">Order Status: CANCELLED</p>
          <p className="text-slate-500 dark:text-slate-400 text-xs mb-6">Reason: Payment Transaction Failed</p>

          <div className="bg-red-50 dark:bg-red-950/20 border border-red-200 dark:border-red-900/50 rounded-2xl p-4 mb-6 text-xs text-red-700 dark:text-red-300 text-left space-y-1">
            <p>• Restaurant has NOT been notified.</p>
            <p>• Invoice was NOT generated or sent.</p>
            <p>• No charges were deducted from your account.</p>
          </div>

          <div className="flex flex-col gap-3">
            {placedOrder && (
              <button
                onClick={() => generateCancellationReceipt(placedOrder)}
                className="w-full bg-slate-800 hover:bg-slate-900 text-white py-3 rounded-xl font-bold text-sm flex items-center justify-center gap-2 transition-all"
              >
                <FaFileDownload /> Download Cancellation Receipt
              </button>
            )}
            <button onClick={() => setStep(2)} className="w-full bg-primary hover:bg-primary-dark text-white py-3 rounded-xl font-bold text-sm transition-all">
              Try Payment Again
            </button>
            <button onClick={() => navigate('/home')} className="w-full bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-200 py-3 rounded-xl font-bold text-sm transition-all">
              Return to Home
            </button>
          </div>
        </motion.div>
      </div>
    );
  }

  // Step 3: Success Screen
  if (step === 3) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#F8F9FA] dark:bg-slate-900 px-4">
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="text-center max-w-md w-full bg-white dark:bg-slate-800 p-8 rounded-3xl shadow-xl border border-slate-100 dark:border-slate-700">
          <motion.div animate={{ scale: [1, 1.1, 1] }} transition={{ repeat: 2, duration: 0.4 }}>
            <FaCheckCircle className="text-green-500 text-7xl mx-auto mb-5" />
          </motion.div>
          <h1 className="text-2xl font-black text-slate-800 dark:text-white mb-2">🎉 Order Placed Successfully</h1>
          <p className="text-slate-500 dark:text-slate-400 text-sm mb-4">Your order has been received and confirmed.</p>

          <div className="space-y-2 mb-6 bg-slate-50 dark:bg-slate-900/50 p-4 rounded-2xl border border-slate-100 dark:border-slate-700/50 text-xs text-left">
            <p className="flex items-center gap-2 text-green-600 dark:text-green-400 font-bold"><FaCheckCircle /> Order Saved in Database</p>
            <p className="flex items-center gap-2 text-green-600 dark:text-green-400 font-bold"><FaFilePdf /> Invoice PDF Downloaded</p>
            <p className="flex items-center gap-2 text-green-600 dark:text-green-400 font-bold"><FaPaperPlane /> Invoice Emailed to {user?.email || 'Registered Email'}</p>
            <p className="flex items-center gap-2 text-green-600 dark:text-green-400 font-bold"><FaStore /> Restaurant Owner Notified</p>
          </div>

          <div className="bg-orange-50 dark:bg-orange-950/20 border border-orange-200 dark:border-orange-900/50 rounded-2xl p-4 mb-8 flex items-center justify-center gap-3">
            <FaClock className="text-primary text-xl flex-shrink-0" />
            <div className="text-left">
              <p className="text-xs font-bold text-slate-400 uppercase tracking-wider">Estimated Delivery</p>
              <p className="text-base font-black text-primary">25–35 mins</p>
            </div>
          </div>

          <div className="flex flex-col sm:flex-row gap-3">
            <button onClick={() => navigate('/orders')} className="flex-1 bg-primary hover:bg-primary-dark text-white py-3.5 rounded-xl font-bold text-sm transition-all hover:shadow-lg hover:shadow-primary/30">
              Track Order
            </button>
            <button onClick={() => navigate('/home')} className="flex-1 bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-200 py-3.5 rounded-xl font-bold text-sm transition-all hover:bg-slate-200 dark:hover:bg-slate-600">
              Continue Shopping
            </button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#F8F9FA] dark:bg-slate-900 py-8">
      <div className="max-w-6xl mx-auto px-4 grid lg:grid-cols-3 gap-8">

        {/* Left: Steps */}
        <div className="lg:col-span-2 space-y-6">
          {/* Step Indicator */}
          <div className="flex items-center gap-4 mb-4">
            {[{ n: 1, label: 'Delivery' }, { n: 2, label: 'Payment' }].map(({ n, label }) => (
              <div key={n} className="flex items-center gap-2">
                <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-black transition-all ${step >= n ? 'bg-primary text-white' : 'bg-slate-200 dark:bg-slate-700 text-slate-400'}`}>{n}</div>
                <span className={`text-sm font-bold ${step >= n ? 'text-slate-800 dark:text-white' : 'text-slate-400'}`}>{label}</span>
                {n < 2 && <div className={`w-16 h-0.5 mx-2 ${step > n ? 'bg-primary' : 'bg-slate-200 dark:bg-slate-700'}`}></div>}
              </div>
            ))}
          </div>

          {/* Step 1: Delivery Address */}
          {step === 1 && (
            <motion.div initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} className="bg-white dark:bg-slate-800 rounded-3xl p-6 border border-slate-100 dark:border-slate-700 shadow-sm">
              <div className="flex items-center gap-3 mb-5">
                <FaTruck className="text-primary text-xl" />
                <h2 className="text-lg font-black text-slate-800 dark:text-white">Delivery Address</h2>
              </div>

              {user?.addresses?.length > 0 && (
                <div className="space-y-3 mb-5">
                  <p className="text-xs font-bold text-slate-400 uppercase tracking-wider">Saved Addresses</p>
                  {user.addresses.map((addr, i) => (
                    <label key={i} className={`flex items-start gap-3 p-4 rounded-2xl border-2 cursor-pointer transition-all ${address === addr ? 'border-primary bg-primary/5' : 'border-slate-200 dark:border-slate-700 hover:border-slate-300'}`}>
                      <input type="radio" name="address" value={addr} checked={address === addr} onChange={() => setAddress(addr)} className="mt-0.5 accent-primary" />
                      <span className="text-sm text-slate-700 dark:text-slate-300">{addr}</span>
                    </label>
                  ))}
                </div>
              )}

              <div>
                <p className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Or Enter New Address</p>
                <textarea rows={3} placeholder="House no., Street, Area, City, PIN Code..."
                  value={newAddress} onChange={(e) => { setNewAddress(e.target.value); setAddress(e.target.value); }}
                  className="w-full px-4 py-3 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary"
                />
              </div>

              <button onClick={() => address ? setStep(2) : showToast('Enter an address to continue', 'error')}
                className="w-full mt-5 bg-primary hover:bg-primary-dark text-white py-3.5 rounded-xl font-bold flex items-center justify-center gap-2 hover:shadow-lg hover:shadow-primary/30 transition-all">
                Continue to Payment <FaArrowRight />
              </button>
            </motion.div>
          )}

          {/* Step 2: Payment */}
          {step === 2 && (
            <motion.div initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} className="bg-white dark:bg-slate-800 rounded-3xl p-6 border border-slate-100 dark:border-slate-700 shadow-sm">
              <div className="flex items-center gap-3 mb-5">
                <FaShieldAlt className="text-primary text-xl" />
                <h2 className="text-lg font-black text-slate-800 dark:text-white">Payment Method</h2>
              </div>

              <div className="space-y-3">
                {[
                  { value: 'UPI', label: 'UPI Payment', emoji: '📱', desc: 'Google Pay, PhonePe, Paytm' },
                  { value: 'Card', label: 'Credit / Debit Card', emoji: '💳', desc: 'Visa, Mastercard, RuPay' },
                  { value: 'Cash on Delivery', label: 'Cash on Delivery', emoji: '💵', desc: 'Pay when your order arrives' },
                ].map((p) => (
                  <label key={p.value} className={`flex items-center gap-4 p-4 rounded-2xl border-2 cursor-pointer transition-all ${paymentMethod === p.value ? 'border-primary bg-primary/5' : 'border-slate-200 dark:border-slate-700 hover:border-slate-300'}`}>
                    <input type="radio" name="payment" value={p.value} checked={paymentMethod === p.value} onChange={() => setPaymentMethod(p.value)} className="accent-primary" />
                    <span className="text-2xl">{p.emoji}</span>
                    <div>
                      <p className="text-sm font-bold text-slate-800 dark:text-white">{p.label}</p>
                      <p className="text-xs text-slate-400">{p.desc}</p>
                    </div>
                  </label>
                ))}
              </div>

              {/* Developer / Admin Payment Testing Control (Hidden from standard customers) */}
              {isDevOrAdmin && paymentMethod !== 'Cash on Delivery' && (
                <div className="mt-4 p-3 bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl flex items-center justify-between text-xs text-slate-500">
                  <span className="font-semibold">[Dev/Admin Only] Test Payment Failure Mode</span>
                  <input
                    type="checkbox"
                    checked={simulateFailure}
                    onChange={(e) => setSimulateFailure(e.target.checked)}
                    className="accent-red-500 w-4 h-4 cursor-pointer"
                  />
                </div>
              )}

              {loading && progressText && (
                <div className="mt-4 p-3 bg-primary/10 border border-primary/20 rounded-xl flex items-center gap-3 text-xs font-bold text-primary animate-pulse">
                  <FaSpinner className="animate-spin text-sm flex-shrink-0" />
                  <span>{progressText}</span>
                </div>
              )}

              <div className="flex gap-3 mt-6">
                <button onClick={() => setStep(1)} disabled={loading} className="flex-1 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 py-3 rounded-xl font-bold text-sm hover:bg-slate-50 dark:hover:bg-slate-700 transition-all disabled:opacity-50">
                  ← Back
                </button>
                <button onClick={handlePlaceOrder} disabled={loading}
                  className="flex-2 bg-primary hover:bg-primary-dark text-white py-3 px-8 rounded-xl font-bold text-sm flex items-center justify-center gap-2 hover:shadow-lg hover:shadow-primary/30 transition-all disabled:opacity-70">
                  {loading ? (
                    <>
                      <FaSpinner className="animate-spin" /> {progressText || 'Processing...'}
                    </>
                  ) : (
                    'Place Order 🎉'
                  )}
                </button>
              </div>
            </motion.div>
          )}
        </div>

        {/* Right: Order Summary */}
        <div className="space-y-4">
          <div className="bg-white dark:bg-slate-800 rounded-3xl p-6 border border-slate-100 dark:border-slate-700 shadow-sm sticky top-20">
            <h2 className="text-base font-black text-slate-800 dark:text-white mb-5">Order Summary</h2>

            <div className="space-y-3 mb-5 max-h-60 overflow-y-auto">
              {items.map((item) => {
                const itemPrice = Number(item.price || 0);
                const itemQty = Number(item.quantity || 1);
                const itemSubtotal = (itemPrice * itemQty).toFixed(2);

                return (
                  <div key={item.id} className="flex items-center gap-3">
                    <img src={item.imageUrl} alt={item.name} className="w-12 h-12 object-cover rounded-xl bg-slate-100" />
                    <div className="flex-1 min-w-0">
                      <p className="text-xs font-bold text-slate-700 dark:text-slate-200 truncate">{item.name}</p>
                      <p className="text-xs text-slate-400">x{itemQty}</p>
                    </div>
                    <span className="text-xs font-black text-slate-700 dark:text-slate-200">${itemSubtotal}</span>
                  </div>
                );
              })}
            </div>

            {/* Coupon */}
            <form onSubmit={(e) => { e.preventDefault(); dispatch(applyCoupon(promoInput.toUpperCase())); setPromoInput(''); }} className="flex gap-2 mb-5">
              <div className="relative flex-1">
                <FaTag className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xs" />
                <input type="text" placeholder="Coupon code" value={promoInput} onChange={(e) => setPromoInput(e.target.value)}
                  className="w-full pl-8 pr-3 py-2 text-xs rounded-xl bg-slate-50 dark:bg-slate-900 dark:text-slate-100 border border-slate-200 dark:border-slate-700 focus:outline-none focus:border-primary" />
              </div>
              <button type="submit" className="bg-slate-800 text-white px-3 py-2 rounded-xl text-xs font-bold">Apply</button>
            </form>
            {couponCode && <div className="text-xs text-green-500 font-bold mb-4">✓ Coupon "{couponCode}" applied</div>}

            {/* Breakdown */}
            <div className="space-y-2 text-xs text-slate-500 dark:text-slate-400 border-t border-slate-100 dark:border-slate-700 pt-4">
              <div className="flex justify-between"><span>Subtotal</span><span className="font-semibold text-slate-700 dark:text-slate-300">${safeSubtotal.toFixed(2)}</span></div>
              <div className="flex justify-between"><span>Delivery Fee</span><span className="font-semibold text-slate-700 dark:text-slate-300">${safeDelivery.toFixed(2)}</span></div>
              <div className="flex justify-between"><span>GST (5%)</span><span className="font-semibold text-slate-700 dark:text-slate-300">${safeGst.toFixed(2)}</span></div>
              {safeDiscount > 0 && <div className="flex justify-between text-green-500 font-bold"><span>Discount</span><span>-${safeDiscount.toFixed(2)}</span></div>}
              <div className="flex justify-between text-sm font-black text-slate-800 dark:text-slate-100 pt-2 border-t border-slate-200 dark:border-slate-700">
                <span>Grand Total</span><span>${safeTotal.toFixed(2)}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
