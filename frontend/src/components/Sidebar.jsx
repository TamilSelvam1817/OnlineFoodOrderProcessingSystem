import React from 'react';
import { FaChartBar, FaUtensils, FaClipboardList, FaUsers, FaArrowLeft } from 'react-icons/fa';

export default function Sidebar({ activeTab, setActiveTab, role, onBackToHome }) {
  const adminMenuItems = [
    { id: 'stats', label: 'Stats Overview', icon: <FaChartBar /> },
    { id: 'orders', label: 'Manage All Orders', icon: <FaClipboardList /> },
    { id: 'restaurants', label: 'Manage Restaurants', icon: <FaUtensils /> },
  ];

  const restaurantMenuItems = [
    { id: 'stats', label: 'Store Stats', icon: <FaChartBar /> },
    { id: 'orders', label: 'Active Orders', icon: <FaClipboardList /> },
    { id: 'menu', label: 'Menu Catalog (CRUD)', icon: <FaUtensils /> },
  ];

  const menu = role === 'ROLE_ADMIN' ? adminMenuItems : restaurantMenuItems;

  return (
    <aside className="w-64 bg-slate-900 text-slate-300 min-h-screen p-6 border-r border-slate-800 flex flex-col justify-between">
      <div>
        <div className="mb-8">
          <span className="text-xl font-black text-white tracking-tight">
            BITE<span className="text-primary">BURST</span>
          </span>
          <p className="text-[10px] text-primary font-bold uppercase tracking-widest mt-1">
            {role === 'ROLE_ADMIN' ? 'Admin Portal' : 'Partner Dashboard'}
          </p>
        </div>

        <nav className="space-y-2">
          {menu.map((item) => (
            <button
              key={item.id}
              onClick={() => setActiveTab(item.id)}
              className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-semibold transition-all ${
                activeTab === item.id
                  ? 'bg-primary text-white shadow-lg shadow-primary/20'
                  : 'hover:bg-slate-800 text-slate-400 hover:text-white'
              }`}
            >
              {item.icon}
              {item.label}
            </button>
          ))}
        </nav>
      </div>

      <button
        onClick={onBackToHome}
        className="flex items-center justify-center gap-2 w-full bg-slate-800 hover:bg-slate-700 text-white py-2.5 rounded-xl text-xs font-bold transition-all mt-8"
      >
        <FaArrowLeft />
        Back to App Home
      </button>
    </aside>
  );
}
