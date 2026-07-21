import React, { useState, useEffect, useRef } from 'react';
import { useSearchParams } from 'react-router-dom';
import { motion } from 'framer-motion';
import { restaurantService } from '../services/api';
import RestaurantCard from '../components/RestaurantCard';
import SkeletonLoader from '../components/SkeletonLoader';
import { FaSearch, FaFire, FaStar, FaClock } from 'react-icons/fa';

const categories = [
  { name: 'All', emoji: '🍽️' },
  { name: 'Pizza', emoji: '🍕' },
  { name: 'Burger', emoji: '🍔' },
  { name: 'Biryani', emoji: '🍛' },
  { name: 'Dessert', emoji: '🍰' },
  { name: 'Sushi', emoji: '🍱' },
];

const bannerOffers = [
  { title: '50% OFF', subtitle: 'On your first order', color: 'from-primary to-orange-400', emoji: '🎉' },
  { title: 'FREE Delivery', subtitle: 'Orders above $20', color: 'from-secondary to-amber-400', emoji: '🏍️' },
  { title: 'BOGO Deal', subtitle: 'Buy 1 Get 1 Free', color: 'from-purple-500 to-pink-500', emoji: '🍕' },
];

export default function HomePage() {
  const [searchParams] = useSearchParams();
  const [restaurants, setRestaurants] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState(searchParams.get('search') || '');
  const [activeCategory, setActiveCategory] = useState('All');
  const [bannerIndex, setBannerIndex] = useState(0);
  const restaurantSectionRef = useRef(null);

  const handleOrderNow = () => {
    restaurantSectionRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' });
  };

  useEffect(() => {
    fetchRestaurants(search);
  }, []);

  useEffect(() => {
    const interval = setInterval(() => setBannerIndex((i) => (i + 1) % bannerOffers.length), 4000);
    return () => clearInterval(interval);
  }, []);

  const fetchRestaurants = async (q = '') => {
    setLoading(true);
    try {
      const res = await restaurantService.getAll(q);
      setRestaurants(res.data);
    } catch {
      setRestaurants([]);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = (e) => {
    e.preventDefault();
    fetchRestaurants(search);
  };

  return (
    <div className="min-h-screen bg-[#F8F9FA] dark:bg-slate-900">

      {/* Hero Banner Slider */}
      <section className="relative h-52 sm:h-64 overflow-hidden">
        {bannerOffers.map((b, i) => (
          <motion.div key={i} initial={{ opacity: 0 }} animate={{ opacity: i === bannerIndex ? 1 : 0 }} transition={{ duration: 0.7 }}
            className={`absolute inset-0 bg-gradient-to-r ${b.color} flex items-center justify-between px-8 sm:px-16 ${i === bannerIndex ? 'z-10' : 'z-0'}`}>
            <div className="text-white">
              <p className="text-4xl sm:text-5xl font-black">{b.title}</p>
              <p className="text-lg opacity-90 font-semibold mt-1">{b.subtitle}</p>
              <button
                onClick={handleOrderNow}
                className="mt-4 bg-white/20 hover:bg-white/30 active:scale-95 text-white text-sm font-bold px-5 py-2 rounded-full transition-all border border-white/30 cursor-pointer"
              >
                Order Now →
              </button>
            </div>
            <div className="hidden sm:block text-8xl">{b.emoji}</div>
          </motion.div>
        ))}
        {/* Slider Dots */}
        <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2 z-20">
          {bannerOffers.map((_, i) => (
            <button key={i} onClick={() => setBannerIndex(i)} className={`h-1.5 rounded-full transition-all ${i === bannerIndex ? 'w-6 bg-white' : 'w-1.5 bg-white/50'}`}></button>
          ))}
        </div>
      </section>

      <div ref={restaurantSectionRef} className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

        {/* Search Bar */}
        <form onSubmit={handleSearch} className="flex gap-3 mb-8">
          <div className="relative flex-1 max-w-2xl">
            <FaSearch className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
            <input type="text" placeholder='Search restaurants, cuisines, dishes...'
              value={search} onChange={(e) => setSearch(e.target.value)}
              className="w-full pl-11 pr-4 py-3.5 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 dark:text-slate-100 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary shadow-sm transition-all"
            />
          </div>
          <button type="submit" className="bg-primary hover:bg-primary-dark text-white px-6 py-3.5 rounded-2xl font-bold text-sm hover:shadow-lg hover:shadow-primary/20 transition-all">
            Search
          </button>
        </form>

        {/* Categories */}
        <div className="flex gap-3 overflow-x-auto pb-3 mb-8 scrollbar-hide">
          {categories.map((cat) => (
            <button key={cat.name} onClick={() => { setActiveCategory(cat.name); fetchRestaurants(cat.name === 'All' ? '' : cat.name); }}
              className={`flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-bold whitespace-nowrap transition-all border ${activeCategory === cat.name ? 'bg-primary text-white border-primary shadow-lg shadow-primary/20' : 'bg-white dark:bg-slate-800 text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-700 hover:border-primary hover:text-primary'}`}>
              <span>{cat.emoji}</span> {cat.name}
            </button>
          ))}
        </div>

        {/* Trending Section */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-2">
            <FaFire className="text-primary" />
            <h2 className="text-xl font-black text-slate-800 dark:text-white">Trending Restaurants</h2>
          </div>
          <span className="text-xs text-slate-400">{restaurants.length} found</span>
        </div>

        {loading ? (
          <SkeletonLoader type="card" count={6} />
        ) : restaurants.length === 0 ? (
          <div className="text-center py-24">
            <div className="text-6xl mb-4">🔍</div>
            <h3 className="text-xl font-black text-slate-700 dark:text-slate-300">No restaurants found</h3>
            <p className="text-slate-400 mt-2">Try a different search or category</p>
          </div>
        ) : (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {restaurants.map((r, i) => (
              <motion.div key={r.id} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.07 }}>
                <RestaurantCard restaurant={r} />
              </motion.div>
            ))}
          </motion.div>
        )}

        {/* Offers Section */}
        <div className="mt-16 mb-8">
          <div className="flex items-center gap-2 mb-6">
            <FaStar className="text-amber-500" />
            <h2 className="text-xl font-black text-slate-800 dark:text-white">Exclusive Offers</h2>
          </div>
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {[
              { code: 'WELCOME50', desc: '50% off up to $50 on first order', bg: 'from-orange-500 to-red-500' },
              { code: 'FOODIE10', desc: '10% off on all orders today!', bg: 'from-blue-500 to-purple-500' },
              { code: 'FREEDELIVERY', desc: 'Free delivery on weekend orders', bg: 'from-green-500 to-teal-500' },
            ].map((offer, i) => (
              <div key={i} className={`bg-gradient-to-r ${offer.bg} rounded-2xl p-5 text-white`}>
                <p className="font-black text-xl tracking-wider mb-1">{offer.code}</p>
                <p className="text-sm opacity-90">{offer.desc}</p>
              </div>
            ))}
          </div>
        </div>

      </div>
    </div>
  );
}
