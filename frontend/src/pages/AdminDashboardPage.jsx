import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { dashboardService, orderService } from '../services/api';
import Sidebar from '../components/Sidebar';
import { AreaChart, Area, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';
import { FaRupeeSign, FaBoxOpen, FaUsers, FaUtensils } from 'react-icons/fa';
import SkeletonLoader from '../components/SkeletonLoader';
import { showToast } from '../components/Toast';

const COLORS = ['#FF6B35', '#F7931E', '#6366f1', '#10b981'];

export default function AdminDashboardPage() {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState('stats');
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    dashboardService.getAdminStats()
      .then((res) => setStats(res.data))
      .catch(() => showToast('Failed to load dashboard data', 'error'))
      .finally(() => setLoading(false));
  }, []);

  const statCards = stats ? [
    { label: 'Total Revenue', value: `$${stats.totalRevenue?.toFixed(2)}`, icon: <FaRupeeSign />, color: 'text-green-500', bg: 'bg-green-50 dark:bg-green-950/20' },
    { label: 'Total Orders', value: stats.ordersCount, icon: <FaBoxOpen />, color: 'text-blue-500', bg: 'bg-blue-50 dark:bg-blue-950/20' },
    { label: 'Total Customers', value: stats.customersCount, icon: <FaUsers />, color: 'text-purple-500', bg: 'bg-purple-50 dark:bg-purple-950/20' },
    { label: 'Restaurants', value: stats.restaurantsCount, icon: <FaUtensils />, color: 'text-primary', bg: 'bg-orange-50 dark:bg-orange-950/20' },
  ] : [];

  const statusLabels = { PLACED: 'Placed', CONFIRMED: 'Confirmed', PREPARING: 'Preparing', OUT_FOR_DELIVERY: 'On Way', DELIVERED: 'Delivered' };

  return (
    <div className="flex min-h-screen bg-slate-100 dark:bg-slate-950">
      <Sidebar activeTab={activeTab} setActiveTab={setActiveTab} role="ROLE_ADMIN" onBackToHome={() => navigate('/home')} />

      <main className="flex-1 p-8 overflow-auto">
        {activeTab === 'stats' && (
          <div>
            <div className="mb-8">
              <h1 className="text-2xl font-black text-slate-800 dark:text-white">Admin Overview</h1>
              <p className="text-slate-400 text-sm">Platform-wide performance summary</p>
            </div>

            {loading ? <SkeletonLoader type="card" count={4} /> : (
              <>
                {/* Stats Cards */}
                <div className="grid grid-cols-2 xl:grid-cols-4 gap-6 mb-8">
                  {statCards.map((card, i) => (
                    <div key={i} className="bg-white dark:bg-slate-800 rounded-3xl p-6 border border-slate-100 dark:border-slate-700 shadow-sm hover:shadow-lg transition-all">
                      <div className={`w-12 h-12 ${card.bg} ${card.color} rounded-2xl flex items-center justify-center text-xl mb-4`}>{card.icon}</div>
                      <p className="text-2xl font-black text-slate-800 dark:text-white">{card.value}</p>
                      <p className="text-xs text-slate-400 font-semibold mt-1">{card.label}</p>
                    </div>
                  ))}
                </div>

                {/* Charts Row */}
                <div className="grid lg:grid-cols-2 gap-6 mb-8">
                  {/* Revenue Chart */}
                  <div className="bg-white dark:bg-slate-800 rounded-3xl p-6 border border-slate-100 dark:border-slate-700 shadow-sm">
                    <h3 className="text-base font-black text-slate-800 dark:text-white mb-4">Revenue Trend</h3>
                    {stats.salesChart?.length > 0 ? (
                      <ResponsiveContainer width="100%" height={200}>
                        <AreaChart data={stats.salesChart}>
                          <defs>
                            <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
                              <stop offset="5%" stopColor="#FF6B35" stopOpacity={0.3} />
                              <stop offset="95%" stopColor="#FF6B35" stopOpacity={0} />
                            </linearGradient>
                          </defs>
                          <CartesianGrid strokeDasharray="3 3" stroke="#f1f5f9" />
                          <XAxis dataKey="date" tick={{ fontSize: 10 }} />
                          <YAxis tick={{ fontSize: 10 }} />
                          <Tooltip formatter={(v) => [`$${v.toFixed(2)}`, 'Revenue']} />
                          <Area type="monotone" dataKey="revenue" stroke="#FF6B35" strokeWidth={2} fill="url(#colorRevenue)" />
                        </AreaChart>
                      </ResponsiveContainer>
                    ) : <p className="text-slate-400 text-sm text-center py-8">No sales data yet</p>}
                  </div>

                  {/* Top Foods Bar Chart */}
                  <div className="bg-white dark:bg-slate-800 rounded-3xl p-6 border border-slate-100 dark:border-slate-700 shadow-sm">
                    <h3 className="text-base font-black text-slate-800 dark:text-white mb-4">Top Selling Items</h3>
                    {stats.topFoods?.length > 0 ? (
                      <ResponsiveContainer width="100%" height={200}>
                        <BarChart data={stats.topFoods} layout="vertical">
                          <CartesianGrid strokeDasharray="3 3" stroke="#f1f5f9" horizontal={false} />
                          <XAxis type="number" tick={{ fontSize: 10 }} />
                          <YAxis dataKey="name" type="category" tick={{ fontSize: 10 }} width={100} />
                          <Tooltip />
                          <Bar dataKey="sales" radius={[0, 8, 8, 0]}>
                            {stats.topFoods.map((_, i) => <Cell key={i} fill={COLORS[i % COLORS.length]} />)}
                          </Bar>
                        </BarChart>
                      </ResponsiveContainer>
                    ) : <p className="text-slate-400 text-sm text-center py-8">No food sales data yet</p>}
                  </div>
                </div>

                {/* Recent Orders Table */}
                <div className="bg-white dark:bg-slate-800 rounded-3xl p-6 border border-slate-100 dark:border-slate-700 shadow-sm">
                  <h3 className="text-base font-black text-slate-800 dark:text-white mb-4">Recent Orders</h3>
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm">
                      <thead>
                        <tr className="border-b border-slate-100 dark:border-slate-700">
                          <th className="text-left pb-3 text-xs font-bold text-slate-400 uppercase tracking-wider">Order ID</th>
                          <th className="text-left pb-3 text-xs font-bold text-slate-400 uppercase tracking-wider">Customer</th>
                          <th className="text-left pb-3 text-xs font-bold text-slate-400 uppercase tracking-wider">Restaurant</th>
                          <th className="text-left pb-3 text-xs font-bold text-slate-400 uppercase tracking-wider">Amount</th>
                          <th className="text-left pb-3 text-xs font-bold text-slate-400 uppercase tracking-wider">Status</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-slate-50 dark:divide-slate-700">
                        {stats.recentOrders?.map((o) => (
                          <tr key={o.id} className="hover:bg-slate-50 dark:hover:bg-slate-700/50 transition-colors">
                            <td className="py-3 text-xs font-bold text-slate-500 dark:text-slate-400">#{o.id}</td>
                            <td className="py-3 text-xs text-slate-700 dark:text-slate-300">{o.customer?.name}</td>
                            <td className="py-3 text-xs text-slate-700 dark:text-slate-300">{o.restaurant?.name}</td>
                            <td className="py-3 text-xs font-black text-slate-800 dark:text-white">${o.totalAmount?.toFixed(2)}</td>
                            <td className="py-3">
                              <span className={`text-[10px] font-black px-2.5 py-1 rounded-full ${o.status === 'DELIVERED' ? 'bg-green-100 text-green-600 dark:bg-green-950/30 dark:text-green-400' : o.status === 'PLACED' ? 'bg-blue-100 text-blue-600 dark:bg-blue-950/30 dark:text-blue-400' : 'bg-amber-100 text-amber-600 dark:bg-amber-950/30 dark:text-amber-400'}`}>
                                {statusLabels[o.status] || o.status}
                              </span>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </>
            )}
          </div>
        )}

        {activeTab === 'orders' && (
          <div>
            <h1 className="text-2xl font-black text-slate-800 dark:text-white mb-6">All Orders</h1>
            <p className="text-slate-400 text-sm">Manage all orders platform-wide</p>
          </div>
        )}

        {activeTab === 'restaurants' && (
          <div>
            <h1 className="text-2xl font-black text-slate-800 dark:text-white mb-6">Manage Restaurants</h1>
            <p className="text-slate-400 text-sm">Add, edit or remove restaurant partners</p>
          </div>
        )}
      </main>
    </div>
  );
}
