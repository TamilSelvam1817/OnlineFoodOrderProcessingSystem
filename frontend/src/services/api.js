import axios from 'axios';
import { store } from '../redux/store';
import { logout } from '../redux/slices/authSlice';
import { MOCK_RESTAURANTS, MOCK_MENUS } from './mockData';

const API = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'https://onlinefoodorderprocessingsystem-production.up.railway.app/api',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to attach JWT token
API.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor to handle token expiry / 401 unauthorized requests
API.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response && error.response.status === 401) {
      const requestUrl = error.config?.url || '';
      if (
        requestUrl.includes('/auth/login') ||
        requestUrl.includes('/auth/register') ||
        (error.response.data && error.response.data.requiresGoogleAuth)
      ) {
        return Promise.reject(error);
      }
      // Auto logout on token expiry
      store.dispatch(logout());
      window.location.href = '/login?expired=true';
    }
    return Promise.reject(error);
  }
);

export const authService = {
  register: (userData) => API.post('/auth/register', userData),
  login: (credentials) => API.post('/auth/login', credentials),
  getCurrentUser: () => API.get('/auth/me'),
  addAddress: (address) => API.post('/auth/address', { address }),
  getGoogleStatus: async () => {
    try {
      return await API.get('/auth/google-status');
    } catch {
      return { data: { connected: false, googleEmail: '', isOffline: true } };
    }
  },
  logout: () => API.post('/auth/logout'),
};

export const restaurantService = {
  getAll: async (search = '') => {
    try {
      return await API.get(`/restaurants${search ? `?search=${encodeURIComponent(search)}` : ''}`);
    } catch (e) {
      if (e.response) throw e;
      let filtered = MOCK_RESTAURANTS;
      if (search) {
        const q = search.toLowerCase();
        filtered = filtered.filter(
          (r) =>
            r.name.toLowerCase().includes(q) ||
            r.cuisine.toLowerCase().includes(q) ||
            r.description.toLowerCase().includes(q)
        );
      }
      return { data: filtered };
    }
  },
  getById: async (id) => {
    try {
      return await API.get(`/restaurants/${id}`);
    } catch (e) {
      if (e.response) throw e;
      const item = MOCK_RESTAURANTS.find((r) => String(r.id) === String(id)) || MOCK_RESTAURANTS[0];
      return { data: item };
    }
  },
  create: (data) => API.post('/restaurants', data),
  update: (id, data) => API.put(`/restaurants/${id}`, data),
  delete: (id) => API.delete(`/restaurants/${id}`),

  getMenu: async (id) => {
    try {
      return await API.get(`/restaurants/${id}/menu`);
    } catch (e) {
      if (e.response) throw e;
      const menu = MOCK_MENUS[id] || MOCK_MENUS[1] || [];
      return { data: menu };
    }
  },
  addMenuItem: (id, data) => API.post(`/restaurants/${id}/menu`, data),
  updateMenuItem: (id, itemId, data) => API.put(`/restaurants/${id}/menu/${itemId}`, data),
  deleteMenuItem: (id, itemId) => API.delete(`/restaurants/${id}/menu/${itemId}`),
};

export const orderService = {
  placeOrder: (orderData) => API.post('/orders', orderData),
  getMyOrders: () => API.get('/orders'),
  getOrderById: (id) => API.get(`/orders/${id}`),
  updateStatus: (id, status) => API.put(`/orders/${id}/status`, { status }),
  sendGmailInvoice: (orderId) => API.post(`/orders/${orderId}/invoice`),
};

export const dashboardService = {
  getAdminStats: () => API.get('/dashboard/admin'),
  getRestaurantStats: (restaurantId) => API.get(`/dashboard/restaurant/${restaurantId}`),
};

export default API;
