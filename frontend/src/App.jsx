import React, { useState, useEffect } from 'react';
import { Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { useSelector, useDispatch } from 'react-redux';
import { AnimatePresence, motion } from 'framer-motion';
import { initTheme } from './redux/slices/themeSlice';

import Navbar from './components/Navbar';
import Footer from './components/Footer';
import CartDrawer from './components/CartDrawer';
import Toast from './components/Toast';

import LandingPage from './pages/LandingPage';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import HomePage from './pages/HomePage';
import RestaurantDetailPage from './pages/RestaurantDetailPage';
import CheckoutPage from './pages/CheckoutPage';
import OrdersPage from './pages/OrdersPage';
import ProfilePage from './pages/ProfilePage';
import AdminDashboardPage from './pages/AdminDashboardPage';
import RestaurantDashboardPage from './pages/RestaurantDashboardPage';
import GoogleCallbackPage from './pages/GoogleCallbackPage';

// Page transition wrapper
const PageWrapper = ({ children }) => (
  <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -10 }} transition={{ duration: 0.25 }}>
    {children}
  </motion.div>
);

// Protected Route Guard
const ProtectedRoute = ({ children, allowedRoles }) => {
  const { isAuthenticated, user } = useSelector((s) => s.auth);
  if (!isAuthenticated) return <Navigate to="/login" replace />;
  if (allowedRoles && !allowedRoles.includes(user?.role)) return <Navigate to="/home" replace />;
  return children;
};

// Layout with Navbar, Footer and Cart Drawer
const MainLayout = ({ children }) => {
  const [cartOpen, setCartOpen] = useState(false);
  return (
    <>
      <Navbar onCartToggle={() => setCartOpen(true)} />
      <CartDrawer isOpen={cartOpen} onClose={() => setCartOpen(false)} />
      <main>{children}</main>
      <Footer />
    </>
  );
};

export default function App() {
  const dispatch = useDispatch();
  const location = useLocation();
  const themeMode = useSelector((s) => s.theme.mode);

  // Apply saved theme on mount
  useEffect(() => {
    dispatch(initTheme());
  }, [dispatch]);

  // Sync the HTML class for tailwind dark mode
  useEffect(() => {
    document.documentElement.classList.toggle('dark', themeMode === 'dark');
  }, [themeMode]);

  return (
    <div className="bg-[#F8F9FA] dark:bg-slate-900 min-h-screen font-[Outfit] transition-colors duration-300">
      <Toast />
      <AnimatePresence mode="wait">
        <Routes location={location} key={location.pathname}>
          {/* Public Routes (no layout) */}
          <Route path="/" element={<PageWrapper><LandingPage /></PageWrapper>} />
          <Route path="/login" element={<PageWrapper><LoginPage /></PageWrapper>} />
          <Route path="/register" element={<PageWrapper><RegisterPage /></PageWrapper>} />
          <Route path="/google-callback" element={<PageWrapper><GoogleCallbackPage /></PageWrapper>} />
          <Route path="/oauth/success" element={<PageWrapper><GoogleCallbackPage /></PageWrapper>} />

          {/* Protected Routes with Main Layout */}
          <Route path="/home" element={<ProtectedRoute><MainLayout><PageWrapper><HomePage /></PageWrapper></MainLayout></ProtectedRoute>} />
          <Route path="/restaurant/:id" element={<ProtectedRoute><MainLayout><PageWrapper><RestaurantDetailPage /></PageWrapper></MainLayout></ProtectedRoute>} />
          <Route path="/checkout" element={<ProtectedRoute><MainLayout><PageWrapper><CheckoutPage /></PageWrapper></MainLayout></ProtectedRoute>} />
          <Route path="/orders" element={<ProtectedRoute><MainLayout><PageWrapper><OrdersPage /></PageWrapper></MainLayout></ProtectedRoute>} />
          <Route path="/profile" element={<ProtectedRoute><MainLayout><PageWrapper><ProfilePage /></PageWrapper></MainLayout></ProtectedRoute>} />

          {/* Admin & Restaurant Dashboard (no footer/navbar) */}
          <Route path="/admin" element={<ProtectedRoute allowedRoles={['ROLE_ADMIN']}><PageWrapper><AdminDashboardPage /></PageWrapper></ProtectedRoute>} />
          <Route path="/restaurant-dashboard" element={<ProtectedRoute allowedRoles={['ROLE_RESTAURANT']}><PageWrapper><RestaurantDashboardPage /></PageWrapper></ProtectedRoute>} />

          {/* 404 Fallback */}
          <Route path="*" element={
            <div className="min-h-screen flex flex-col items-center justify-center text-center">
              <div className="text-8xl mb-6">🍽️</div>
              <h1 className="text-3xl font-black text-slate-800 dark:text-white mb-2">Page Not Found</h1>
              <p className="text-slate-400 mb-6">The page you're looking for doesn't exist.</p>
              <a href="/home" className="bg-primary text-white px-8 py-3 rounded-xl font-bold hover:bg-primary-dark transition-all">Go Home</a>
            </div>
          } />
        </Routes>
      </AnimatePresence>
    </div>
  );
}
