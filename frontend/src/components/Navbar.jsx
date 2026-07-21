import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useSelector, useDispatch } from 'react-redux';
import { toggleTheme } from '../redux/slices/themeSlice';
import { logout } from '../redux/slices/authSlice';
import { FaShoppingCart, FaUser, FaSun, FaMoon, FaSearch, FaMapMarkerAlt, FaBell, FaSignOutAlt } from 'react-icons/fa';

export default function Navbar({ onCartToggle }) {
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  const cartItems = useSelector((state) => state.cart.items);
  const themeMode = useSelector((state) => state.theme.mode);
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const [searchVal, setSearchVal] = useState('');
  const [showDropdown, setShowDropdown] = useState(false);

  const cartCount = cartItems.reduce((acc, item) => acc + item.quantity, 0);

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
        <div className="flex items-center gap-4">
          
          {/* Dark Mode Toggle */}
          <button
            onClick={() => dispatch(toggleTheme())}
            className="p-2 rounded-full hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-600 dark:text-slate-300 transition-colors"
            title="Toggle Theme"
          >
            {themeMode === 'dark' ? <FaSun className="text-amber-400" /> : <FaMoon />}
          </button>

          {/* Notification Button */}
          <button className="relative p-2 rounded-full hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-600 dark:text-slate-300 transition-colors">
            <FaBell />
            <span className="absolute top-1 right-1 w-2 h-2 bg-primary rounded-full"></span>
          </button>

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
            <div className="relative">
              <button
                onClick={() => setShowDropdown(!showDropdown)}
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
