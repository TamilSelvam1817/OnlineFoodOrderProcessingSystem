import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useSelector } from 'react-redux';
import { dashboardService, restaurantService, orderService } from '../services/api';
import Sidebar from '../components/Sidebar';
import { showToast } from '../components/Toast';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { FaPlus, FaEdit, FaTrash, FaToggleOn, FaToggleOff } from 'react-icons/fa';
import SkeletonLoader from '../components/SkeletonLoader';

const STATUS_OPTIONS = ['PLACED', 'PAYMENT_PROCESSING', 'KITCHEN_PREP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED'];

export default function RestaurantDashboardPage() {
  const navigate = useNavigate();
  const user = useSelector((s) => s.auth.user);

  const [activeTab, setActiveTab] = useState('stats');
  const [myRestaurants, setMyRestaurants] = useState([]);
  const [selectedRestaurant, setSelectedRestaurant] = useState(null);
  const [stats, setStats] = useState(null);
  const [menu, setMenu] = useState([]);
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);

  // Menu Form State
  const [showForm, setShowForm] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [formData, setFormData] = useState({ name: '', description: '', price: '', imageUrl: '', category: '', isVeg: true });

  useEffect(() => {
    restaurantService.getAll().then((res) => {
      const owned = res.data.filter((r) => r.ownerId === user?.id);
      setMyRestaurants(owned);
      if (owned.length > 0) {
        setSelectedRestaurant(owned[0]);
        loadRestaurantData(owned[0].id);
      } else {
        setLoading(false);
      }
    });
  }, []);

  const loadRestaurantData = async (restaurantId) => {
    setLoading(true);
    try {
      const [statsRes, menuRes, ordersRes] = await Promise.all([
        dashboardService.getRestaurantStats(restaurantId),
        restaurantService.getMenu(restaurantId),
        orderService.getMyOrders(),
      ]);
      setStats(statsRes.data);
      setMenu(menuRes.data);
      setOrders(ordersRes.data.filter((o) => o.restaurant?.id === restaurantId));
    } catch {
      showToast('Failed to load restaurant data', 'error');
    } finally {
      setLoading(false);
    }
  };

  const handleSaveMenuItem = async () => {
    if (!formData.name || !formData.price) {
      showToast('Name and price are required', 'error');
      return;
    }
    try {
      const payload = { ...formData, price: parseFloat(formData.price) };
      if (editingItem) {
        await restaurantService.updateMenuItem(selectedRestaurant.id, editingItem.id, payload);
        showToast('Menu item updated!', 'success');
      } else {
        await restaurantService.addMenuItem(selectedRestaurant.id, payload);
        showToast('Menu item added!', 'success');
      }
      setShowForm(false);
      setEditingItem(null);
      setFormData({ name: '', description: '', price: '', imageUrl: '', category: '', isVeg: true });
      const menuRes = await restaurantService.getMenu(selectedRestaurant.id);
      setMenu(menuRes.data);
    } catch {
      showToast('Failed to save item', 'error');
    }
  };

  const handleDeleteMenuItem = async (itemId) => {
    if (!window.confirm('Delete this menu item?')) return;
    try {
      await restaurantService.deleteMenuItem(selectedRestaurant.id, itemId);
      setMenu(menu.filter((i) => i.id !== itemId));
      showToast('Item deleted', 'info');
    } catch {
      showToast('Failed to delete item', 'error');
    }
  };

  const handleUpdateOrderStatus = async (orderId, status) => {
    try {
      await orderService.updateStatus(orderId, status);
      setOrders(orders.map((o) => o.id === orderId ? { ...o, status } : o));
      showToast('Order status updated!', 'success');
    } catch {
      showToast('Failed to update status', 'error');
    }
  };

  return (
    <div className="flex min-h-screen bg-slate-100 dark:bg-slate-950">
      <Sidebar activeTab={activeTab} setActiveTab={setActiveTab} role="ROLE_RESTAURANT" onBackToHome={() => navigate('/home')} />

      <main className="flex-1 p-8 overflow-auto">
        {/* Restaurant Selector */}
        {myRestaurants.length > 1 && (
          <div className="mb-6 flex items-center gap-3">
            <label className="text-sm font-bold text-slate-500 dark:text-slate-400">Restaurant:</label>
            <select className="px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 dark:text-slate-100 text-sm"
              value={selectedRestaurant?.id}
              onChange={(e) => { const r = myRestaurants.find((r) => r.id == e.target.value); setSelectedRestaurant(r); loadRestaurantData(r.id); }}>
              {myRestaurants.map((r) => <option key={r.id} value={r.id}>{r.name}</option>)}
            </select>
          </div>
        )}

        {/* Stats Tab */}
        {activeTab === 'stats' && (
          <div>
            <h1 className="text-2xl font-black text-slate-800 dark:text-white mb-2">Restaurant Dashboard</h1>
            <p className="text-slate-400 text-sm mb-6">{selectedRestaurant?.name || 'No restaurant found'}</p>

            {loading ? <SkeletonLoader type="card" count={4} /> : stats && (
              <>
                <div className="grid grid-cols-2 lg:grid-cols-3 gap-5 mb-8">
                  {[
                    { label: 'Total Revenue', value: `$${stats.totalRevenue?.toFixed(2)}`, color: 'text-green-500', bg: 'bg-green-50 dark:bg-green-950/20' },
                    { label: 'Total Orders', value: stats.ordersCount, color: 'text-blue-500', bg: 'bg-blue-50 dark:bg-blue-950/20' },
                    { label: 'Menu Items', value: stats.itemsCount, color: 'text-purple-500', bg: 'bg-purple-50 dark:bg-purple-950/20' },
                  ].map((c, i) => (
                    <div key={i} className="bg-white dark:bg-slate-800 rounded-3xl p-5 border border-slate-100 dark:border-slate-700 shadow-sm">
                      <p className="text-2xl font-black text-slate-800 dark:text-white">{c.value}</p>
                      <p className="text-xs text-slate-400 mt-1">{c.label}</p>
                    </div>
                  ))}
                </div>

                {stats.salesChart?.length > 0 && (
                  <div className="bg-white dark:bg-slate-800 rounded-3xl p-6 border border-slate-100 dark:border-slate-700 shadow-sm mb-8">
                    <h3 className="text-base font-black text-slate-800 dark:text-white mb-4">Sales Chart</h3>
                    <ResponsiveContainer width="100%" height={220}>
                      <AreaChart data={stats.salesChart}>
                        <defs>
                          <linearGradient id="revGrad" x1="0" y1="0" x2="0" y2="1">
                            <stop offset="5%" stopColor="#FF6B35" stopOpacity={0.3} />
                            <stop offset="95%" stopColor="#FF6B35" stopOpacity={0} />
                          </linearGradient>
                        </defs>
                        <CartesianGrid strokeDasharray="3 3" stroke="#f1f5f9" />
                        <XAxis dataKey="date" tick={{ fontSize: 10 }} />
                        <YAxis tick={{ fontSize: 10 }} />
                        <Tooltip formatter={(v) => [`$${v.toFixed(2)}`, 'Revenue']} />
                        <Area type="monotone" dataKey="revenue" stroke="#FF6B35" strokeWidth={2} fill="url(#revGrad)" />
                      </AreaChart>
                    </ResponsiveContainer>
                  </div>
                )}
              </>
            )}
          </div>
        )}

        {/* Orders Tab */}
        {activeTab === 'orders' && (
          <div>
            <h1 className="text-2xl font-black text-slate-800 dark:text-white mb-6">Active Orders</h1>
            {orders.length === 0 ? (
              <div className="text-center py-16 bg-white dark:bg-slate-800 rounded-3xl border border-slate-100 dark:border-slate-700">
                <p className="text-slate-400">No orders yet for this restaurant</p>
              </div>
            ) : (
              <div className="space-y-4">
                {orders.map((order) => (
                  <div key={order.id} className="bg-white dark:bg-slate-800 rounded-2xl p-5 border border-slate-100 dark:border-slate-700 shadow-sm flex items-center justify-between gap-4">
                    <div>
                      <p className="text-xs text-slate-400">Order #{order.id}</p>
                      <p className="font-bold text-slate-800 dark:text-white text-sm">{order.customer?.name}</p>
                      <p className="text-xs text-slate-400">${order.totalAmount?.toFixed(2)} • {order.paymentMethod}</p>
                    </div>
                    <select value={order.status}
                      onChange={(e) => handleUpdateOrderStatus(order.id, e.target.value)}
                      className="px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-xs font-bold focus:outline-none focus:border-primary">
                      {STATUS_OPTIONS.map((s) => <option key={s} value={s}>{s.replace('_', ' ')}</option>)}
                    </select>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* Menu CRUD Tab */}
        {activeTab === 'menu' && (
          <div>
            <div className="flex items-center justify-between mb-6">
              <h1 className="text-2xl font-black text-slate-800 dark:text-white">Menu Catalog</h1>
              <button onClick={() => { setEditingItem(null); setFormData({ name: '', description: '', price: '', imageUrl: '', category: '', isVeg: true }); setShowForm(true); }}
                className="flex items-center gap-2 bg-primary text-white px-5 py-2.5 rounded-xl text-sm font-bold hover:bg-primary-dark transition-all">
                <FaPlus /> Add Item
              </button>
            </div>

            {showForm && (
              <div className="bg-white dark:bg-slate-800 rounded-3xl p-6 border border-slate-100 dark:border-slate-700 shadow-sm mb-6">
                <h3 className="font-black text-slate-800 dark:text-white mb-5">{editingItem ? 'Edit Item' : 'Add New Item'}</h3>
                <div className="grid sm:grid-cols-2 gap-4">
                  {[
                    { key: 'name', label: 'Item Name', type: 'text', placeholder: 'e.g. Margherita Pizza' },
                    { key: 'price', label: 'Price ($)', type: 'number', placeholder: '9.99' },
                    { key: 'imageUrl', label: 'Image URL', type: 'text', placeholder: 'https://...' },
                    { key: 'category', label: 'Category', type: 'text', placeholder: 'Pizza, Burger, Dessert...' },
                  ].map((f) => (
                    <div key={f.key}>
                      <label className="block text-xs font-bold text-slate-400 mb-1.5 uppercase tracking-wider">{f.label}</label>
                      <input type={f.type} placeholder={f.placeholder} value={formData[f.key]}
                        onChange={(e) => setFormData({ ...formData, [f.key]: e.target.value })}
                        className="w-full px-4 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" />
                    </div>
                  ))}
                  <div className="sm:col-span-2">
                    <label className="block text-xs font-bold text-slate-400 mb-1.5 uppercase tracking-wider">Description</label>
                    <textarea rows={2} placeholder="Short description of the dish..." value={formData.description}
                      onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                      className="w-full px-4 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" />
                  </div>
                  <label className="flex items-center gap-3 cursor-pointer">
                    <input type="checkbox" checked={formData.isVeg} onChange={(e) => setFormData({ ...formData, isVeg: e.target.checked })} className="accent-green-500 w-4 h-4" />
                    <span className="text-sm font-bold text-slate-700 dark:text-slate-300">Vegetarian</span>
                  </label>
                </div>
                <div className="flex gap-3 mt-5">
                  <button onClick={handleSaveMenuItem} className="bg-primary text-white px-6 py-2.5 rounded-xl text-sm font-bold hover:bg-primary-dark transition-all">Save Item</button>
                  <button onClick={() => setShowForm(false)} className="border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 px-6 py-2.5 rounded-xl text-sm font-bold hover:bg-slate-50 dark:hover:bg-slate-700 transition-all">Cancel</button>
                </div>
              </div>
            )}

            <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
              {menu.map((item) => (
                <div key={item.id} className="bg-white dark:bg-slate-800 rounded-2xl overflow-hidden border border-slate-100 dark:border-slate-700 shadow-sm">
                  <div className="h-36 bg-slate-100 overflow-hidden">
                    <img src={item.imageUrl} alt={item.name} className="w-full h-full object-cover" />
                  </div>
                  <div className="p-4">
                    <div className="flex items-start justify-between mb-2">
                      <div>
                        <p className="text-sm font-bold text-slate-800 dark:text-white line-clamp-1">{item.name}</p>
                        <p className="text-xs text-slate-400 mt-0.5">{item.category}</p>
                      </div>
                      <span className="text-sm font-black text-primary">${item.price?.toFixed(2)}</span>
                    </div>
                    <div className="flex gap-2 mt-3">
                      <button onClick={() => { setEditingItem(item); setFormData({ name: item.name, description: item.description, price: item.price, imageUrl: item.imageUrl, category: item.category, isVeg: item.veg }); setShowForm(true); }}
                        className="flex-1 flex items-center justify-center gap-1 text-xs font-bold text-blue-500 bg-blue-50 dark:bg-blue-950/20 py-2 rounded-lg hover:bg-blue-100 transition-all">
                        <FaEdit /> Edit
                      </button>
                      <button onClick={() => handleDeleteMenuItem(item.id)}
                        className="flex-1 flex items-center justify-center gap-1 text-xs font-bold text-red-500 bg-red-50 dark:bg-red-950/20 py-2 rounded-lg hover:bg-red-100 transition-all">
                        <FaTrash /> Delete
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
