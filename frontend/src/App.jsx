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

  // Routes that should NOT have the standard Navbar/Footer layout
  const noLayoutRoutes = ['/', '/login', '/register', '/admin', '/restaurant-dashboard'];
  const useLayout = !noLayoutRoutes.some((r) => location.pathname === r || location.pathname.startsWith('/admin') || location.pathname.startsWith('/restaurant-dashboard'));

  return (
  <div className="min-h-screen">
    <Toast />

    <AnimatePresence mode="wait">
      <Routes location={location} key={location.pathname}>

        <Route path="/" element={<LandingPage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="/google-callback" element={<GoogleCallbackPage />} />
        <Route path="/oauth/success" element={<Navigate to="/home" replace />} />

        <Route
          path="/home"
          element={
            <ProtectedRoute>
              <MainLayout>
                <PageWrapper>
                  <HomePage />
                </PageWrapper>
              </MainLayout>
            </ProtectedRoute>
          }
        />

        {/* other routes */}

      </Routes>
    </AnimatePresence>
  </div>
);
}
