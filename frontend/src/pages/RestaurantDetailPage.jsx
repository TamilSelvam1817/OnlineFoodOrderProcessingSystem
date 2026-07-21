import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { motion } from 'framer-motion';
import { restaurantService } from '../services/api';
import FoodCard from '../components/FoodCard';
import SkeletonLoader from '../components/SkeletonLoader';
import { useSelector } from 'react-redux';
import { FaStar, FaClock, FaSearch, FaLeaf } from 'react-icons/fa';

export default function RestaurantDetailPage() {
  const { id } = useParams();
  const [restaurant, setRestaurant] = useState(null);
  const [menu, setMenu] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [vegFilter, setVegFilter] = useState('all'); // all, veg, nonveg
  const [activeCategory, setActiveCategory] = useState('All');
  const cartItems = useSelector((state) => state.cart.items);
  const cartTotal = useSelector((state) => state.cart.total);
  const cartCount = cartItems.reduce((sum, i) => sum + i.quantity, 0);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [restRes, menuRes] = await Promise.all([
          restaurantService.getById(id),
          restaurantService.getMenu(id),
        ]);
        setRestaurant(restRes.data);
        setMenu(menuRes.data);
      } catch {
        setRestaurant(null);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  const categories = ['All', ...new Set(menu.map((item) => item.category).filter(Boolean))];

  const filteredMenu = menu.filter((item) => {
    const matchSearch = item.name.toLowerCase().includes(search.toLowerCase());
    const matchVeg = vegFilter === 'all' || (vegFilter === 'veg' ? item.veg : !item.veg);
    const matchCat = activeCategory === 'All' || item.category === activeCategory;
    return matchSearch && matchVeg && matchCat;
  });

  if (loading) {
    return (
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="h-64 shimmer rounded-3xl mb-8"></div>
        <SkeletonLoader type="card" count={6} />
      </div>
    );
  }

  if (!restaurant) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen">
        <div className="text-6xl mb-4">😕</div>
        <h2 className="text-xl font-black text-slate-700 dark:text-slate-300">Restaurant not found</h2>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#F8F9FA] dark:bg-slate-900">

      {/* Restaurant Hero */}
      <div className="relative h-64 sm:h-80 overflow-hidden">
        <img src={restaurant.imageUrl} alt={restaurant.name} className="w-full h-full object-cover" />
        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent"></div>
        <div className="absolute bottom-0 left-0 right-0 p-6 sm:p-10">
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
            <h1 className="text-3xl sm:text-4xl font-black text-white mb-2">{restaurant.name}</h1>
            <p className="text-sm text-white/70 max-w-xl mb-4">{restaurant.description}</p>
            <div className="flex flex-wrap gap-4 text-sm">
              <span className="flex items-center gap-1.5 bg-white/10 backdrop-blur-md text-white px-3 py-1.5 rounded-full border border-white/20">
                <FaStar className="text-amber-400" /> {restaurant.rating.toFixed(1)} Rating
              </span>
              <span className="flex items-center gap-1.5 bg-white/10 backdrop-blur-md text-white px-3 py-1.5 rounded-full border border-white/20">
                <FaClock /> {restaurant.deliveryTime} mins
              </span>
              <span className="bg-green-500 text-white px-3 py-1.5 rounded-full text-xs font-bold">
                {restaurant.active ? 'Open Now' : 'Closed'}
              </span>
            </div>
          </motion.div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

        {/* Filters Toolbar */}
        <div className="flex flex-col sm:flex-row gap-4 mb-8 p-4 bg-white dark:bg-slate-800 rounded-2xl border border-slate-100 dark:border-slate-700 shadow-sm">
          {/* Search */}
          <div className="relative flex-1">
            <FaSearch className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xs" />
            <input type="text" placeholder="Search menu items..."
              value={search} onChange={(e) => setSearch(e.target.value)}
              className="w-full pl-9 pr-4 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary"
            />
          </div>

          {/* Veg/Non-veg toggle */}
          <div className="flex gap-2">
            {['all', 'veg', 'nonveg'].map((f) => (
              <button key={f} onClick={() => setVegFilter(f)}
                className={`flex items-center gap-1.5 px-4 py-2.5 rounded-xl text-xs font-bold border transition-all ${vegFilter === f ? 'bg-primary text-white border-primary' : 'bg-slate-50 dark:bg-slate-900 text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-700 hover:border-primary'}`}>
                {f === 'veg' && <FaLeaf className="text-green-400" />}
                {f.charAt(0).toUpperCase() + f.slice(1)}
              </button>
            ))}
          </div>
        </div>

        {/* Category Tabs */}
        <div className="flex gap-3 overflow-x-auto pb-3 mb-8">
          {categories.map((cat) => (
            <button key={cat} onClick={() => setActiveCategory(cat)}
              className={`px-5 py-2 rounded-full text-sm font-bold whitespace-nowrap border transition-all ${activeCategory === cat ? 'bg-slate-800 dark:bg-white text-white dark:text-slate-900 border-transparent' : 'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:border-slate-400'}`}>
              {cat}
            </button>
          ))}
        </div>

        {/* Menu Grid */}
        {filteredMenu.length === 0 ? (
          <div className="text-center py-16">
            <div className="text-5xl mb-4">🍽️</div>
            <p className="text-slate-400">No items match your filters</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {filteredMenu.map((food, i) => (
              <motion.div key={food.id} initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.05 }}>
                <FoodCard food={food} restaurant={restaurant} />
              </motion.div>
            ))}
          </div>
        )}
      </div>

      {/* Sticky Cart Summary */}
      {cartCount > 0 && (
        <motion.div initial={{ y: 100 }} animate={{ y: 0 }} className="fixed bottom-6 left-1/2 -translate-x-1/2 z-30">
          <div className="bg-primary text-white px-6 py-4 rounded-2xl shadow-2xl flex items-center gap-8 min-w-[320px]">
            <div>
              <p className="text-xs font-bold opacity-80">{cartCount} Items in Cart</p>
              <p className="text-lg font-black">${cartTotal.toFixed(2)}</p>
            </div>
            <button onClick={() => window.location.href = '/checkout'} className="ml-auto bg-white text-primary font-black text-sm px-5 py-2 rounded-xl hover:bg-slate-100 transition-all">
              Checkout →
            </button>
          </div>
        </motion.div>
      )}
    </div>
  );
}
