import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useSelector, useDispatch } from 'react-redux';
import { updateQuantity, removeFromCart, applyCoupon, removeCoupon } from '../redux/slices/cartSlice';
import { FaTrash, FaTimes, FaTags, FaArrowRight } from 'react-icons/fa';

export default function CartDrawer({ isOpen, onClose }) {
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const { items, subtotal, deliveryCharge, gst, discount, total, couponCode } = useSelector((state) => state.cart);
  const [promoInput, setPromoInput] = useState('');

  if (!isOpen) return null;

  const handleQtyChange = (id, currentQty, amount) => {
    dispatch(updateQuantity({ id, quantity: currentQty + amount }));
  };

  const handleApplyCoupon = (e) => {
    e.preventDefault();
    if (promoInput.trim()) {
      dispatch(applyCoupon(promoInput.trim().toUpperCase()));
      setPromoInput('');
    }
  };

  const handleCheckout = () => {
    onClose();
    navigate('/checkout');
  };

  return (
    <div className="fixed inset-0 z-50 overflow-hidden">
      {/* Overlay */}
      <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm transition-opacity" onClick={onClose}></div>

      <div className="absolute inset-y-0 right-0 max-w-full flex pl-10">
        <div className="w-screen max-w-md bg-white dark:bg-slate-900 shadow-2xl flex flex-col h-full border-l border-slate-100 dark:border-slate-800">
          
          {/* Drawer Header */}
          <div className="px-6 py-5 border-b border-slate-100 dark:border-slate-800 flex items-center justify-between">
            <h2 className="text-lg font-bold text-slate-800 dark:text-white flex items-center gap-2">
              My Cart
              <span className="text-xs bg-primary/10 text-primary px-2.5 py-0.5 rounded-full font-bold">
                {items.reduce((sum, item) => sum + item.quantity, 0)} Items
              </span>
            </h2>
            <button onClick={onClose} className="p-2 hover:bg-slate-50 dark:hover:bg-slate-800 rounded-full text-slate-400 dark:text-slate-200">
              <FaTimes />
            </button>
          </div>

          {/* Items List */}
          <div className="flex-1 overflow-y-auto p-6 space-y-4">
            {items.length === 0 ? (
              <div className="h-full flex flex-col items-center justify-center text-center">
                <img
                  src="https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?w=300&q=80"
                  alt="Empty Cart"
                  className="w-40 h-40 object-cover rounded-full mb-4 opacity-55"
                />
                <h3 className="font-bold text-slate-700 dark:text-slate-300">Your cart is empty</h3>
                <p className="text-sm text-slate-400 mt-1 max-w-xs">Browse menu items and add them to your cart to enjoy gourmet meals.</p>
              </div>
            ) : (
              items.map((item) => (
                <div key={item.id} className="flex gap-4 p-3 bg-slate-50 dark:bg-slate-800 rounded-2xl border border-slate-100 dark:border-slate-700/50">
                  <img src={item.imageUrl} alt={item.name} className="w-16 h-16 object-cover rounded-xl bg-slate-200" />
                  
                  <div className="flex-1 min-w-0">
                    <h4 className="text-sm font-bold text-slate-800 dark:text-slate-100 truncate">{item.name}</h4>
                    <p className="text-xs text-slate-400 truncate mb-2">{item.restaurantName}</p>
                    
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2.5 bg-white dark:bg-slate-700 px-2.5 py-1 rounded-full border border-slate-200 dark:border-slate-600">
                        <button onClick={() => handleQtyChange(item.id, item.quantity, -1)} className="text-slate-500 dark:text-slate-300 font-bold hover:text-primary">-</button>
                        <span className="text-xs font-bold dark:text-slate-100">{item.quantity}</span>
                        <button onClick={() => handleQtyChange(item.id, item.quantity, 1)} className="text-slate-500 dark:text-slate-300 font-bold hover:text-primary">+</button>
                      </div>
                      <span className="text-sm font-black text-slate-800 dark:text-slate-200">${(item.price * item.quantity).toFixed(2)}</span>
                    </div>
                  </div>

                  <button
                    onClick={() => dispatch(removeFromCart(item.id))}
                    className="self-start p-2 text-slate-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-950/20 rounded-full transition-all"
                  >
                    <FaTrash size={12} />
                  </button>
                </div>
              ))
            )}
          </div>

          {/* Pricing & Checkout */}
          {items.length > 0 && (
            <div className="border-t border-slate-100 dark:border-slate-800 p-6 bg-slate-50 dark:bg-slate-800/50 space-y-4">
              
              {/* Promo Input */}
              <form onSubmit={handleApplyCoupon} className="flex gap-2">
                <div className="relative flex-1">
                  <input
                    type="text"
                    placeholder="Enter Coupon (e.g. WELCOME50)"
                    value={promoInput}
                    onChange={(e) => setPromoInput(e.target.value)}
                    className="w-full pl-9 pr-3 py-2 text-xs rounded-xl bg-white dark:bg-slate-800 dark:text-white border border-slate-200 dark:border-slate-700 focus:outline-none focus:border-primary"
                  />
                  <FaTags className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xs" />
                </div>
                <button type="submit" className="bg-slate-800 hover:bg-slate-700 dark:bg-slate-700 dark:hover:bg-slate-600 text-white px-4 py-2 rounded-xl text-xs font-bold transition-all">
                  Apply
                </button>
              </form>

              {couponCode && (
                <div className="flex items-center justify-between bg-green-50 dark:bg-green-950/20 border border-green-200 dark:border-green-800 px-3 py-1.5 rounded-xl text-xs text-green-600 dark:text-green-400">
                  <span className="font-bold">Coupon "{couponCode}" Active</span>
                  <button onClick={() => dispatch(removeCoupon())} className="font-bold hover:underline">Remove</button>
                </div>
              )}

              {/* Price Calculations */}
              <div className="space-y-1.5 text-xs text-slate-500 dark:text-slate-400">
                <div className="flex justify-between">
                  <span>Subtotal</span>
                  <span className="font-semibold text-slate-700 dark:text-slate-300">${subtotal.toFixed(2)}</span>
                </div>
                <div className="flex justify-between">
                  <span>Delivery Fee</span>
                  <span className="font-semibold text-slate-700 dark:text-slate-300">${deliveryCharge.toFixed(2)}</span>
                </div>
                <div className="flex justify-between">
                  <span>GST (5%)</span>
                  <span className="font-semibold text-slate-700 dark:text-slate-300">${gst.toFixed(2)}</span>
                </div>
                {discount > 0 && (
                  <div className="flex justify-between text-green-600 dark:text-green-400 font-bold">
                    <span>Discount</span>
                    <span>-${discount.toFixed(2)}</span>
                  </div>
                )}
                <div className="flex justify-between text-sm font-black text-slate-800 dark:text-slate-100 pt-2 border-t border-slate-200 dark:border-slate-700">
                  <span>Grand Total</span>
                  <span>${total.toFixed(2)}</span>
                </div>
              </div>

              {/* Checkout CTA */}
              <button
                onClick={handleCheckout}
                className="w-full bg-primary hover:bg-primary-dark text-white py-3.5 rounded-xl font-bold flex items-center justify-center gap-2 hover:shadow-lg hover:shadow-primary/30 transition-all text-sm mt-2"
              >
                Proceed to Checkout
                <FaArrowRight />
              </button>
            </div>
          )}

        </div>
      </div>
    </div>
  );
}
