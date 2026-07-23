import React, { useState, useRef, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useSelector, useDispatch } from 'react-redux';
import { toggleTheme } from '../redux/slices/themeSlice';
import { logout } from '../redux/slices/authSlice';
import { markAsRead, markAllAsRead, clearAllNotifications } from '../redux/slices/notificationSlice';
import { FaShoppingCart, FaUser, FaSun, FaMoon, FaSearch, FaMapMarkerAlt, FaBell, FaSignOutAlt, FaCheckDouble, FaTrashAlt, FaBoxOpen, FaTimes, FaFileInvoice, FaTag, FaInfoCircle } from 'react-icons/fa';

const getNotifIcon = (type) => {
  switch (type) {
    case 'order': return <span className="p-2 rounded-xl bg-emerald-500/10 text-emerald-500 text-xs">📦</span>;
    case 'cancel': return <span className="p-2 rounded-xl bg-red-500/10 text-red-500 text-xs">❌</span>;
    case 'invoice': return <span className="p-2 rounded-xl bg-orange-500/10 text-orange-500 text-xs">📄</span>;
    case 'cart': return <span className="p-2 rounded-xl bg-blue-500/10 text-blue-500 text-xs">🛒</span>;
    case 'coupon': return <span className="p-2 rounded-xl bg-purple-500/10 text-purple-500 text-xs">🏷️</span>;
    default: return <span className="p-2 rounded-xl bg-primary/10 text-primary text-xs">🔔</span>;
  }
};

const formatTimeAgo = (isoTime) => {
  if (!isoTime) return 'Just now';
  const diffMs = Date.now() - new Date(isoTime).getTime();
  const diffMins = Math.floor(diffMs / 60000);
  if (diffMins < 1) return 'Just now';
  if (diffMins < 60) return `${diffMins}m ago`;
  const diffHours = Math.floor(diffMins / 60);
  if (diffHours < 24) return `${diffHours}h ago`;
  return `${Math.floor(diffHours / 24)}d ago`;
};

export default function Navbar({ onCartToggle }) {
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  const cartItems = useSelector((state) => state.cart.items);
  const themeMode = useSelector((state) => state.theme.mode);
  const notifications = useSelector((state) => state.notifications?.items || []);
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const [searchVal, setSearchVal] = useState('');
  const [showDropdown, setShowDropdown] = useState(false);
  const [showNotifDropdown, setShowNotifDropdown] = useState(false);

  const notifRef = useRef(null);
  const profileRef = useRef(null);

  const unreadCount = notifications.filter((n) => !n.read).length;
  const cartCount = cartItems.reduce((acc, item) => acc + item.quantity, 0);

  useEffect(() => {
    const handleClickOutside = (e) => {
      if (notifRef.current && !notifRef.current.contains(e.target)) {
        setShowNotifDropdown(false);
      }
      if (profileRef.current && !profileRef.current.contains(e.target)) {
        setShowDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    document.addEventListener('touchstart', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      document.removeEventListener('touchstart', handleClickOutside);
    };
  }, []);

  const handleSearch = (e) => {
    e.preventDefault();
    if (searchVal.trim()) {
      navigate(`/home?search=${encodeURIComponent(searchVal)}`);
    }
  };

  const handleLogout = () => {
    dispatch(logout());
    navigate('/');
  };

  const handleNotifClick = (n) => {
    if (!n.read) {
      dispatch(markAsRead(n.id));
    }
    if (n.link) {
      setShowNotifDropdown(false);
      navigate(n.link);
    }
  };

  return (
    <header className="sticky top-0 z-40 w-full transition-all duration-200 bg-white/80 dark:bg-slate-900/80 backdrop-blur-md border-b border-slate-100 dark:border-slate-800 shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between gap-4">
        
        {/* Brand Logo & Location */}
        <div className="flex items-center gap-6">
          <Link to={isAuthenticated ? "/home" : "/"} className="flex items-center gap-2">
            <span className="text-2xl font-black tracking-tight text-primary">
              BITE<span className="text-secondary">BURST</span>
            </span>
          </Link>

          {/* Location Picker (Desktop) */}
          <div className="hidden md:flex items-center gap-2 text-xs font-semibold bg-slate-50 dark:bg-slate-800 px-3 py-1.5 rounded-full text-slate-600 dark:text-slate-300">
            <FaMapMarkerAlt className="text-primary" />
            <span>Silicon Valley, USA</span>
          </div>
        </div>

        {/* Search Bar (Desktop) */}
        <form onSubmit={handleSearch} className="hidden sm:flex flex-1 max-w-md relative">
          <input
            type="text"
            placeholder="Search restaurants or cuisines..."
            value={searchVal}
            onChange={(e) => setSearchVal(e.target.value)}
            className="w-full bg-slate-50 dark:bg-slate-800 dark:text-slate-100 text-sm pl-10 pr-4 py-2 rounded-full border border-transparent focus:border-primary/50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-primary/20 transition-all"
          />
          <FaSearch className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
        </form>

        {/* Action Controls */}
        <div className="flex items-center gap-2 sm:gap-4">
          
          {/* Dark Mode Toggle */}
          <button
            onClick={() => dispatch(toggleTheme())}
            className="p-2 rounded-full hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-600 dark:text-slate-300 transition-colors"
            title="Toggle Theme"
          >
            {themeMode === 'dark' ? <FaSun className="text-amber-400" /> : <FaMoon />}
          </button>

          {/* Notification Bell Dropdown */}
          <div className="relative" ref={notifRef}>
            <button
              onClick={() => {
                setShowNotifDropdown(!showNotifDropdown);
                setShowDropdown(false);
              }}
              className="relative p-2 rounded-full hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-600 dark:text-slate-300 transition-colors"
              title="Notifications"
            >
              <FaBell className={unreadCount > 0 ? 'text-primary animate-bounce' : ''} />
              {unreadCount > 0 && (
                <span className="absolute -top-0.5 -right-0.5 bg-primary text-white text-[10px] font-black w-4 h-4 rounded-full flex items-center justify-center border-2 border-white dark:border-slate-900">
                  {unreadCount > 9 ? '9+' : unreadCount}
                </span>
              )}
            </button>

            {showNotifDropdown && (
              <>
                {/* Mobile Backdrop Overlay */}
                <div 
                  className="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-40 sm:hidden"
                  onClick={() => setShowNotifDropdown(false)}
                />

                {/* Responsive Notification Modal Panel */}
                <div className="fixed top-16 left-3 right-3 max-w-md mx-auto sm:absolute sm:top-full sm:right-0 sm:left-auto sm:mt-2 sm:w-96 sm:max-w-none sm:mx-0 bg-white dark:bg-slate-800 rounded-3xl shadow-2xl border border-slate-100 dark:border-slate-700 py-3 z-50 overflow-hidden transition-all">
                  <div className="px-4 py-2 border-b border-slate-100 dark:border-slate-700 flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <h3 className="text-sm font-black text-slate-800 dark:text-white">Notifications</h3>
                      {unreadCount > 0 && (
                        <span className="bg-primary/10 text-primary text-[10px] font-bold px-2 py-0.5 rounded-full">
                          {unreadCount} new
                        </span>
                      )}
                    </div>
                    <div className="flex items-center gap-2 text-xs">
                      {unreadCount > 0 && (
                        <button
                          onClick={() => dispatch(markAllAsRead())}
                          className="text-primary hover:underline font-bold text-[11px] flex items-center gap-1"
                        >
                          <FaCheckDouble /> Read All
                        </button>
                      )}
                      {notifications.length > 0 && (
                        <button
                          onClick={() => dispatch(clearAllNotifications())}
                          className="text-slate-400 hover:text-red-500 font-medium text-[11px] flex items-center gap-1"
                        >
                          <FaTrashAlt /> Clear
                        </button>
                      )}
                      <button
                        onClick={() => setShowNotifDropdown(false)}
                        className="sm:hidden text-slate-400 hover:text-slate-600 p-1 rounded-full text-sm"
                        title="Close"
                      >
                        <FaTimes />
                      </button>
                    </div>
                  </div>

                  <div className="max-h-80 overflow-y-auto divide-y divide-slate-100 dark:divide-slate-700/60">
                    {notifications.length === 0 ? (
                      <div className="p-8 text-center">
                        <div className="text-3xl mb-2">🔔</div>
                        <p className="text-xs font-bold text-slate-600 dark:text-slate-300">No notifications yet</p>
                        <p className="text-[11px] text-slate-400 mt-1">We'll alert you when orders or updates occur</p>
                      </div>
                    ) : (
                      notifications.map((n) => (
                        <div
                          key={n.id}
                          onClick={() => handleNotifClick(n)}
                          className={`p-3.5 flex items-start gap-3 cursor-pointer transition-all hover:bg-slate-50 dark:hover:bg-slate-700/50 ${
                            !n.read ? 'bg-primary/5 dark:bg-primary/10' : ''
                          }`}
                        >
                          {getNotifIcon(n.type)}
                          <div className="flex-1 min-w-0">
                            <div className="flex items-center justify-between gap-2">
                              <p className={`text-xs font-bold truncate ${!n.read ? 'text-slate-900 dark:text-white font-black' : 'text-slate-700 dark:text-slate-300'}`}>
                                {n.title}
                              </p>
                              <span className="text-[10px] text-slate-400 flex-shrink-0">{formatTimeAgo(n.time)}</span>
                            </div>
                            <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-0.5 line-clamp-2">
                              {n.message}
                            </p>
                          </div>
                          {!n.read && (
                            <span className="w-2 h-2 rounded-full bg-primary flex-shrink-0 mt-1.5" />
                          )}
                        </div>
                      ))
                    )}
                  </div>
                </div>
              </>
            )}
          </div>

          {/* Cart Button */}
          <button
            onClick={onCartToggle}
            className="relative p-2 rounded-full hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-600 dark:text-slate-300 transition-colors"
          >
            <FaShoppingCart />
            {cartCount > 0 && (
              <span className="absolute -top-1 -right-1 bg-primary text-white text-[10px] font-bold w-5 h-5 rounded-full flex items-center justify-center border-2 border-white dark:border-slate-900 animate-pulse">
                {cartCount}
              </span>
            )}
          </button>

          {/* Profile Dropdown */}
          {isAuthenticated ? (
            <div className="relative" ref={profileRef}>
              <button
                onClick={() => {
                  setShowDropdown(!showDropdown);
                  setShowNotifDropdown(false);
                }}
                className="flex items-center gap-2 p-1 rounded-full border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors"
              >
                <div className="w-8 h-8 rounded-full bg-primary/10 text-primary font-bold flex items-center justify-center text-sm uppercase">
                  {user.name.charAt(0)}
                </div>
              </button>

              {showDropdown && (
                <div className="absolute right-0 mt-2 w-52 bg-white dark:bg-slate-800 rounded-2xl shadow-xl border border-slate-100 dark:border-slate-700 py-2 z-50">
                  <div className="px-4 py-2 border-b border-slate-100 dark:border-slate-700">
                    <p className="text-sm font-bold text-slate-800 dark:text-slate-100 truncate">{user.name}</p>
                    <p className="text-xs text-slate-400 truncate">{user.email}</p>
                  </div>
                  
                  {user.role === 'ROLE_ADMIN' && (
                    <Link to="/admin" className="block px-4 py-2 text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700">
                      Admin Dashboard
                    </Link>
                  )}
                  {user.role === 'ROLE_RESTAURANT' && (
                    <Link to="/restaurant-dashboard" className="block px-4 py-2 text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700">
                      Restaurant Dashboard
                    </Link>
                  )}
                  
                  <Link to="/profile" className="block px-4 py-2 text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700">
                    My Profile
                  </Link>
                  <Link to="/orders" className="block px-4 py-2 text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700">
                    My Orders
                  </Link>
                  
                  <button
                    onClick={handleLogout}
                    className="w-full text-left px-4 py-2 text-sm text-red-500 hover:bg-red-50 dark:hover:bg-red-950/30 flex items-center gap-2 border-t border-slate-100 dark:border-slate-700 mt-1"
                  >
                    <FaSignOutAlt />
                    Logout
                  </button>
                </div>
              )}
            </div>
          ) : (
            <Link
              to="/login"
              className="bg-primary hover:bg-primary-dark text-white px-5 py-2 rounded-full text-sm font-semibold hover:shadow-lg hover:shadow-primary/20 transition-all"
            >
              Sign In
            </Link>
          )}

        </div>
      </div>
    </header>
  );
}
