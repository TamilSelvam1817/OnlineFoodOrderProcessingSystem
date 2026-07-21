import { createSlice } from '@reduxjs/toolkit';

const loadCart = () => {
  try {
    const serialized = localStorage.getItem('cart');
    if (serialized === null) return [];
    return JSON.parse(serialized);
  } catch (e) {
    return [];
  }
};

const saveCart = (items) => {
  try {
    localStorage.setItem('cart', JSON.stringify(items));
  } catch (e) {
    // ignore
  }
};

const calculateTotals = (items, couponCode = '') => {
  const subtotal = items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const deliveryCharge = subtotal > 0 ? 30.0 : 0.0;
  const gst = subtotal * 0.05; // 5% GST
  
  let discount = 0;
  if (couponCode === 'WELCOME50' && subtotal > 150) {
    discount = Math.min(50, subtotal * 0.5);
  } else if (couponCode === 'FOODIE10') {
    discount = subtotal * 0.1;
  }

  const total = Math.max(0, subtotal + deliveryCharge + gst - discount);
  
  return { subtotal, deliveryCharge, gst, discount, total };
};

const initialState = {
  items: loadCart(),
  couponCode: localStorage.getItem('couponCode') || '',
  ...calculateTotals(loadCart(), localStorage.getItem('couponCode') || ''),
};

const cartSlice = createSlice({
  name: 'cart',
  initialState,
  reducers: {
    addToCart: (state, action) => {
      const { id, name, price, imageUrl, restaurantId, restaurantName } = action.payload;
      
      const validRestId = restaurantId || state.items[0]?.restaurantId;
      const validRestName = restaurantName || state.items[0]?.restaurantName;

      // Reset cart if adding from a different restaurant
      if (state.items.length > 0 && validRestId && state.items[0].restaurantId && String(state.items[0].restaurantId) !== String(validRestId)) {
        state.items = [];
      }

      const existingIndex = state.items.findIndex(item => item.id === id);
      if (existingIndex > -1) {
        state.items[existingIndex].quantity += 1;
      } else {
        state.items.push({
          id,
          name,
          price,
          imageUrl,
          restaurantId: validRestId,
          restaurantName: validRestName,
          quantity: 1
        });
      }

      saveCart(state.items);
      Object.assign(state, calculateTotals(state.items, state.couponCode));
    },
    updateQuantity: (state, action) => {
      const { id, quantity } = action.payload;
      const existing = state.items.find(item => item.id === id);
      if (existing) {
        existing.quantity = Math.max(1, quantity);
      }
      saveCart(state.items);
      Object.assign(state, calculateTotals(state.items, state.couponCode));
    },
    removeFromCart: (state, action) => {
      state.items = state.items.filter(item => item.id !== action.payload);
      saveCart(state.items);
      Object.assign(state, calculateTotals(state.items, state.couponCode));
    },
    applyCoupon: (state, action) => {
      state.couponCode = action.payload;
      localStorage.setItem('couponCode', action.payload);
      Object.assign(state, calculateTotals(state.items, state.couponCode));
    },
    removeCoupon: (state) => {
      state.couponCode = '';
      localStorage.removeItem('couponCode');
      Object.assign(state, calculateTotals(state.items, ''));
    },
    clearCart: (state) => {
      state.items = [];
      state.couponCode = '';
      localStorage.removeItem('cart');
      localStorage.removeItem('couponCode');
      Object.assign(state, {
        items: [],
        subtotal: 0,
        deliveryCharge: 0,
        gst: 0,
        discount: 0,
        total: 0,
      });
    }
  }
});

export const { addToCart, updateQuantity, removeFromCart, applyCoupon, removeCoupon, clearCart } = cartSlice.actions;
export default cartSlice.reducer;
