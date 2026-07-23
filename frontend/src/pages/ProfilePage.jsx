import React, { useState, useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { logout, updateProfile as updateAuthProfile } from '../redux/slices/authSlice';
import { useNavigate, Link } from 'react-router-dom';
import { showToast } from '../components/Toast';
import { authService } from '../services/api';
import { FaUser, FaMapMarkerAlt, FaClipboardList, FaHeart, FaSignOutAlt, FaPlus, FaEdit, FaSave, FaTimes, FaLock, FaEnvelope, FaSpinner, FaTrashAlt } from 'react-icons/fa';
import { motion } from 'framer-motion';

export default function ProfilePage() {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const user = useSelector((s) => s.auth.user);
  const [activeTab, setActiveTab] = useState('personal');
  const [newAddress, setNewAddress] = useState('');
  const [addingAddress, setAddingAddress] = useState(false);

  // Profile Edit State
  const [isEditingProfile, setIsEditingProfile] = useState(false);
  const [editName, setEditName] = useState(user?.name || '');
  const [editPassword, setEditPassword] = useState('');
  const [updatingProfile, setUpdatingProfile] = useState(false);

  // Fetch current user from DB on mount to ensure fresh state
  useEffect(() => {
    authService.getCurrentUser()
      .then((res) => {
        if (res.data) {
          dispatch(updateAuthProfile(res.data));
        }
      })
      .catch(() => {});
  }, [dispatch]);

  const handleLogout = () => {
    dispatch(logout());
    showToast('Logged out successfully', 'info');
    navigate('/');
  };

  const handleAddAddress = async () => {
    if (!newAddress.trim()) return;
    try {
      const res = await authService.addAddress(newAddress.trim());
      const updatedAddresses = res.data;
      dispatch(updateAuthProfile({ addresses: updatedAddresses }));
      setNewAddress('');
      setAddingAddress(false);
      showToast('Address added successfully! 📍', 'success');
    } catch {
      showToast('Failed to add address', 'error');
    }
  };

  const handleDeleteAddress = async (index) => {
    try {
      const res = await authService.deleteAddress(index);
      const updatedAddresses = res.data;
      dispatch(updateAuthProfile({ addresses: updatedAddresses }));
      showToast('Address removed', 'info');
    } catch {
      showToast('Failed to remove address', 'error');
    }
  };

  const handleSaveProfile = async (e) => {
    e.preventDefault();
    if (!editName.trim()) {
      showToast('Name cannot be empty', 'error');
      return;
    }

    setUpdatingProfile(true);
    try {
      const payload = { name: editName.trim() };
      if (editPassword.trim()) {
        payload.password = editPassword.trim();
      }

      await authService.updateProfile(payload);
      dispatch(updateAuthProfile({ name: editName.trim() }));
      setIsEditingProfile(false);
      setEditPassword('');
      showToast('Profile updated successfully! 🎉', 'success');
    } catch (err) {
      const msg = err.response?.data?.message || 'Failed to update profile';
      showToast(msg, 'error');
    } finally {
      setUpdatingProfile(false);
    }
  };

  if (!user) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-slate-400">Please login to view profile</p>
      </div>
    );
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
            <div className="w-20 h-20 rounded-full bg-gradient-to-br from-primary to-secondary flex items-center justify-center text-white text-2xl font-black mx-auto mb-4 shadow-lg shadow-primary/20">
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
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-sm font-semibold transition-all ${
                  activeTab === tab.id ? 'bg-primary text-white shadow-md shadow-primary/20' : 'text-slate-500 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-700'
                }`}
              >
                {tab.icon} {tab.label}
              </button>
            ))}
            <button
              onClick={handleLogout}
              className="w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-sm font-semibold text-red-500 hover:bg-red-50 dark:hover:bg-red-950/20 transition-all mt-2 border-t border-slate-100 dark:border-slate-700 pt-3"
            >
              <FaSignOutAlt /> Logout
            </button>
          </nav>
        </div>

        {/* Right Panel */}
        <div className="lg:col-span-3">
          <motion.div
            key={activeTab}
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="bg-white dark:bg-slate-800 rounded-3xl border border-slate-100 dark:border-slate-700 shadow-sm p-6"
          >

            {/* Personal Information Tab */}
            {activeTab === 'personal' && (
              <div>
                <div className="flex items-center justify-between mb-6">
                  <h2 className="text-lg font-black text-slate-800 dark:text-white">Personal Information</h2>
                  {!isEditingProfile && (
                    <button
                      onClick={() => {
                        setEditName(user.name || '');
                        setIsEditingProfile(true);
                      }}
                      className="flex items-center gap-2 bg-primary/10 hover:bg-primary/20 text-primary px-4 py-2 rounded-xl text-sm font-bold transition-all"
                    >
                      <FaEdit /> Edit Profile
                    </button>
                  )}
                </div>

                {isEditingProfile ? (
                  <form onSubmit={handleSaveProfile} className="bg-slate-50 dark:bg-slate-900 rounded-2xl p-6 border border-slate-200 dark:border-slate-700 space-y-4">
                    <div>
                      <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider mb-2">
                        Full Name
                      </label>
                      <div className="relative">
                        <input
                          type="text"
                          value={editName}
                          onChange={(e) => setEditName(e.target.value)}
                          className="w-full pl-10 pr-4 py-3 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-800 dark:text-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary font-bold"
                          placeholder="Enter your full name"
                          required
                        />
                        <FaUser className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-sm" />
                      </div>
                    </div>

                    <div>
                      <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider mb-2">
                        Email Address <span className="text-[10px] text-slate-400 font-normal lowercase">(read-only)</span>
                      </label>
                      <div className="relative">
                        <input
                          type="email"
                          value={user.email}
                          disabled
                          className="w-full pl-10 pr-4 py-3 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-100 dark:bg-slate-800/50 text-slate-500 dark:text-slate-400 text-sm font-medium cursor-not-allowed"
                        />
                        <FaEnvelope className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-sm" />
                      </div>
                    </div>

                    <div>
                      <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider mb-2">
                        New Password <span className="text-[10px] text-slate-400 font-normal lowercase">(leave blank to keep current)</span>
                      </label>
                      <div className="relative">
                        <input
                          type="password"
                          value={editPassword}
                          onChange={(e) => setEditPassword(e.target.value)}
                          className="w-full pl-10 pr-4 py-3 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-800 dark:text-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary font-bold"
                          placeholder="Enter new password"
                        />
                        <FaLock className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-sm" />
                      </div>
                    </div>

                    <div className="flex items-center gap-3 pt-2">
                      <button
                        type="submit"
                        disabled={updatingProfile}
                        className="flex items-center gap-2 bg-primary hover:bg-primary-dark text-white px-6 py-2.5 rounded-xl text-sm font-bold shadow-md shadow-primary/20 transition-all disabled:opacity-50"
                      >
                        {updatingProfile ? <FaSpinner className="animate-spin" /> : <FaSave />}
                        {updatingProfile ? 'Saving...' : 'Save Changes'}
                      </button>
                      <button
                        type="button"
                        onClick={() => {
                          setIsEditingProfile(false);
                          setEditName(user.name || '');
                          setEditPassword('');
                        }}
                        className="flex items-center gap-2 bg-slate-200 dark:bg-slate-700 hover:bg-slate-300 dark:hover:bg-slate-600 text-slate-700 dark:text-slate-200 px-5 py-2.5 rounded-xl text-sm font-bold transition-all"
                      >
                        <FaTimes /> Cancel
                      </button>
                    </div>
                  </form>
                ) : (
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
                )}
              </div>
            )}

            {/* Saved Addresses Tab */}
            {activeTab === 'addresses' && (
              <div>
                <div className="flex items-center justify-between mb-6">
                  <h2 className="text-lg font-black text-slate-800 dark:text-white">Saved Addresses</h2>
                  <button onClick={() => setAddingAddress(!addingAddress)} className="flex items-center gap-2 bg-primary text-white px-4 py-2 rounded-xl text-sm font-bold hover:bg-primary-dark transition-all shadow-md shadow-primary/20">
                    <FaPlus /> Add New
                  </button>
                </div>
                {addingAddress && (
                  <div className="mb-6 flex gap-3">
                    <input
                      type="text"
                      placeholder="Enter full address (e.g. Guindy, Chennai)..."
                      value={newAddress}
                      onChange={(e) => setNewAddress(e.target.value)}
                      onKeyDown={(e) => e.key === 'Enter' && handleAddAddress()}
                      className="flex-1 px-4 py-3 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary font-bold"
                    />
                    <button onClick={handleAddAddress} className="bg-primary text-white px-5 py-3 rounded-xl text-sm font-bold hover:bg-primary-dark transition-all shadow-md shadow-primary/20">
                      Save
                    </button>
                  </div>
                )}
                <div className="space-y-3">
                  {user.addresses?.length > 0 ? (
                    user.addresses.map((addr, i) => (
                      <div key={i} className="flex items-center gap-4 p-4 bg-slate-50 dark:bg-slate-900 rounded-2xl border border-slate-100 dark:border-slate-700 transition-all hover:border-slate-200 dark:hover:border-slate-600">
                        <FaMapMarkerAlt className="text-primary flex-shrink-0 text-lg" />
                        <p className="text-sm font-bold text-slate-700 dark:text-slate-200 flex-1">{addr}</p>
                        <button
                          onClick={() => handleDeleteAddress(i)}
                          className="p-2 text-slate-400 hover:text-red-500 rounded-xl hover:bg-red-50 dark:hover:bg-red-950/30 transition-all"
                          title="Remove address"
                        >
                          <FaTrashAlt className="text-sm" />
                        </button>
                      </div>
                    ))
                  ) : (
                    <div className="text-center py-12 text-slate-400">
                      <FaMapMarkerAlt className="text-4xl mx-auto mb-3 opacity-30" />
                      <p className="font-bold text-sm text-slate-600 dark:text-slate-300">No saved addresses yet</p>
                      <p className="text-xs text-slate-400 mt-1">Add your address to speed up checkout</p>
                    </div>
                  )}
                </div>
              </div>
            )}

            {/* Order History Tab */}
            {activeTab === 'orders' && (
              <div>
                <h2 className="text-lg font-black text-slate-800 dark:text-white mb-6">Order History</h2>
                <div className="text-center py-12">
                  <FaClipboardList className="text-5xl text-slate-200 dark:text-slate-700 mx-auto mb-4" />
                  <p className="text-slate-400 mb-4">View your full order history</p>
                  <Link to="/orders" className="bg-primary text-white px-6 py-2.5 rounded-xl text-sm font-bold inline-block hover:bg-primary-dark transition-all shadow-md shadow-primary/20">
                    Go to Orders
                  </Link>
                </div>
              </div>
            )}

            {/* Wishlist Tab */}
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
