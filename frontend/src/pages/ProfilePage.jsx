import React, { useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { logout } from '../redux/slices/authSlice';
import { useNavigate, Link } from 'react-router-dom';
import { showToast } from '../components/Toast';
import { authService } from '../services/api';
import { FaUser, FaMapMarkerAlt, FaClipboardList, FaHeart, FaSignOutAlt, FaPlus, FaEdit } from 'react-icons/fa';
import { motion } from 'framer-motion';

export default function ProfilePage() {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const user = useSelector((s) => s.auth.user);
  const [activeTab, setActiveTab] = useState('personal');
  const [newAddress, setNewAddress] = useState('');
  const [addingAddress, setAddingAddress] = useState(false);

  const handleLogout = () => {
    dispatch(logout());
    showToast('Logged out successfully', 'info');
    navigate('/');
  };

  const handleAddAddress = async () => {
    if (!newAddress.trim()) return;
    try {
      await authService.addAddress(newAddress.trim());
      setNewAddress('');
      setAddingAddress(false);
      showToast('Address added!', 'success');
    } catch {
      showToast('Failed to add address', 'error');
    }
  };

  if (!user) {
    return <div className="min-h-screen flex items-center justify-center"><p className="text-slate-400">Please login to view profile</p></div>;
  }

  const tabs = [
    { id: 'personal', label: 'Personal Info', icon: <FaUser /> },
    { id: 'addresses', label: 'Saved Addresses', icon: <FaMapMarkerAlt /> },
    { id: 'orders', label: 'Order History', icon: <FaClipboardList /> },
    { id: 'wishlist', label: 'Wishlist', icon: <FaHeart /> },
  ];

  return (
    <div className="min-h-screen bg-[#F8F9FA] dark:bg-slate-900 py-8">
      <div className="max-w-5xl mx-auto px-4 grid lg:grid-cols-4 gap-8">

        {/* Left Panel */}
        <div className="lg:col-span-1">
          <div className="bg-white dark:bg-slate-800 rounded-3xl border border-slate-100 dark:border-slate-700 shadow-sm p-6 text-center mb-4">
            <div className="w-20 h-20 rounded-full bg-gradient-to-br from-primary to-secondary flex items-center justify-center text-white text-2xl font-black mx-auto mb-4">
              {user.name?.charAt(0)?.toUpperCase()}
            </div>
            <h2 className="text-base font-black text-slate-800 dark:text-white">{user.name}</h2>
            <p className="text-xs text-slate-400 mt-1">{user.email}</p>
            <span className="mt-2 inline-block text-[10px] font-black uppercase tracking-widest bg-primary/10 text-primary px-3 py-1 rounded-full">
              {user.role?.replace('ROLE_', '')}
            </span>
          </div>

          {/* Nav */}
          <nav className="space-y-1.5 bg-white dark:bg-slate-800 rounded-3xl border border-slate-100 dark:border-slate-700 shadow-sm p-3">
            {tabs.map((tab) => (
              <button key={tab.id} onClick={() => setActiveTab(tab.id)}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-sm font-semibold transition-all ${activeTab === tab.id ? 'bg-primary text-white' : 'text-slate-500 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-700'}`}>
                {tab.icon} {tab.label}
              </button>
            ))}
            <button onClick={handleLogout} className="w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-sm font-semibold text-red-500 hover:bg-red-50 dark:hover:bg-red-950/20 transition-all mt-2 border-t border-slate-100 dark:border-slate-700 pt-3">
              <FaSignOutAlt /> Logout
            </button>
          </nav>
        </div>

        {/* Right Panel */}
        <div className="lg:col-span-3">
          <motion.div key={activeTab} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="bg-white dark:bg-slate-800 rounded-3xl border border-slate-100 dark:border-slate-700 shadow-sm p-6">

            {activeTab === 'personal' && (
              <div>
                <h2 className="text-lg font-black text-slate-800 dark:text-white mb-6">Personal Information</h2>
                <div className="grid sm:grid-cols-2 gap-5">
                  {[
                    { label: 'Full Name', value: user.name },
                    { label: 'Email Address', value: user.email },
                    { label: 'Account Role', value: user.role?.replace('ROLE_', '') },
                    { label: 'User ID', value: `#${user.id}` },
                  ].map((field) => (
                    <div key={field.label} className="bg-slate-50 dark:bg-slate-900 rounded-2xl px-4 py-4 border border-slate-100 dark:border-slate-700">
                      <p className="text-xs text-slate-400 font-bold uppercase tracking-wider mb-1">{field.label}</p>
                      <p className="text-sm font-bold text-slate-800 dark:text-white">{field.value}</p>
                    </div>
                  ))}
                </div>
                <button className="mt-6 flex items-center gap-2 bg-primary/10 hover:bg-primary/20 text-primary px-5 py-2.5 rounded-xl text-sm font-bold transition-all">
                  <FaEdit /> Edit Profile
                </button>
              </div>
            )}

            {activeTab === 'addresses' && (
              <div>
                <div className="flex items-center justify-between mb-6">
                  <h2 className="text-lg font-black text-slate-800 dark:text-white">Saved Addresses</h2>
                  <button onClick={() => setAddingAddress(!addingAddress)} className="flex items-center gap-2 bg-primary text-white px-4 py-2 rounded-xl text-sm font-bold hover:bg-primary-dark transition-all">
                    <FaPlus /> Add New
                  </button>
                </div>
                {addingAddress && (
                  <div className="mb-6 flex gap-3">
                    <input type="text" placeholder="Enter full address..." value={newAddress} onChange={(e) => setNewAddress(e.target.value)}
                      className="flex-1 px-4 py-3 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary"
                    />
                    <button onClick={handleAddAddress} className="bg-primary text-white px-5 py-3 rounded-xl text-sm font-bold">Save</button>
                  </div>
                )}
                <div className="space-y-3">
                  {user.addresses?.length > 0 ? user.addresses.map((addr, i) => (
                    <div key={i} className="flex items-center gap-4 p-4 bg-slate-50 dark:bg-slate-900 rounded-2xl border border-slate-100 dark:border-slate-700">
                      <FaMapMarkerAlt className="text-primary flex-shrink-0" />
                      <p className="text-sm text-slate-700 dark:text-slate-300 flex-1">{addr}</p>
                    </div>
                  )) : (
                    <div className="text-center py-12 text-slate-400">
                      <FaMapMarkerAlt className="text-4xl mx-auto mb-3 opacity-30" />
                      <p>No saved addresses yet</p>
                    </div>
                  )}
                </div>
              </div>
            )}

            {activeTab === 'orders' && (
              <div>
                <h2 className="text-lg font-black text-slate-800 dark:text-white mb-6">Order History</h2>
                <div className="text-center py-12">
                  <FaClipboardList className="text-5xl text-slate-200 dark:text-slate-700 mx-auto mb-4" />
                  <p className="text-slate-400 mb-4">View your full order history</p>
                  <Link to="/orders" className="bg-primary text-white px-6 py-2.5 rounded-xl text-sm font-bold inline-block hover:bg-primary-dark transition-all">Go to Orders</Link>
                </div>
              </div>
            )}

            {activeTab === 'wishlist' && (
              <div>
                <h2 className="text-lg font-black text-slate-800 dark:text-white mb-6">Wishlist</h2>
                <div className="text-center py-12">
                  <FaHeart className="text-5xl text-slate-200 dark:text-slate-700 mx-auto mb-4" />
                  <p className="text-slate-400">No favorites saved yet</p>
                  <p className="text-xs text-slate-400 mt-1">Tap the ♡ on any restaurant to save it here</p>
                </div>
              </div>
            )}
          </motion.div>
        </div>
      </div>
    </div>
  );
}
