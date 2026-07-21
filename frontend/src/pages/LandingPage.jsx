import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { FaSearch, FaStar, FaClock, FaArrowRight, FaUtensils, FaMotorcycle, FaSmile } from 'react-icons/fa';

const categories = [
  { name: 'Pizza', emoji: '🍕', color: 'bg-orange-50 dark:bg-orange-950/20 text-orange-500' },
  { name: 'Burger', emoji: '🍔', color: 'bg-amber-50 dark:bg-amber-950/20 text-amber-500' },
  { name: 'Biryani', emoji: '🍛', color: 'bg-yellow-50 dark:bg-yellow-950/20 text-yellow-600' },
  { name: 'Sushi', emoji: '🍱', color: 'bg-green-50 dark:bg-green-950/20 text-green-500' },
  { name: 'Dessert', emoji: '🍰', color: 'bg-pink-50 dark:bg-pink-950/20 text-pink-500' },
  { name: 'Pasta', emoji: '🍝', color: 'bg-red-50 dark:bg-red-950/20 text-red-500' },
  { name: 'Tacos', emoji: '🌮', color: 'bg-lime-50 dark:bg-lime-950/20 text-lime-600' },
  { name: 'Coffee', emoji: '☕', color: 'bg-brown-50 dark:bg-stone-950/20 text-stone-600' },
];

const testimonials = [
  { name: 'Sarah Johnson', text: 'BiteBurst is simply amazing! Hot food delivered within 25 minutes, every single time. Best app in the city!', rating: 5, avatar: 'SJ' },
  { name: 'Raj Patel', text: 'Incredible restaurant selection and lightning-fast delivery. The tracking feature is so accurate and reassuring.', rating: 5, avatar: 'RP' },
  { name: 'Emily Chen', text: 'I love the variety! From local gems to premium chains — BiteBurst has it all. The UI is super slick too.', rating: 4, avatar: 'EC' },
];

const stats = [
  { icon: <FaUtensils />, value: '500+', label: 'Partner Restaurants' },
  { icon: <FaMotorcycle />, value: '2M+', label: 'Orders Delivered' },
  { icon: <FaSmile />, value: '98%', label: 'Happy Customers' },
  { icon: <FaClock />, value: '<30min', label: 'Avg. Delivery Time' },
];

export default function LandingPage() {
  const [search, setSearch] = useState('');
  const navigate = useNavigate();

  const handleSearch = (e) => {
    e.preventDefault();
    navigate(search.trim() ? `/home?search=${encodeURIComponent(search)}` : '/home');
  };

  return (
    <div className="bg-[#F8F9FA] dark:bg-slate-900 min-h-screen font-[Outfit]">

      {/* Navbar */}
      <nav className="sticky top-0 z-40 bg-white/80 dark:bg-slate-900/80 backdrop-blur-md border-b border-slate-100 dark:border-slate-800">
        <div className="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
          <span className="text-2xl font-black text-primary">BITE<span className="text-secondary">BURST</span></span>
          <div className="flex items-center gap-4">
            <Link to="/login" className="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">Sign In</Link>
            <Link to="/register" className="bg-primary hover:bg-primary-dark text-white px-5 py-2 rounded-full text-sm font-bold transition-all hover:shadow-lg hover:shadow-primary/30">
              Get Started
            </Link>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative overflow-hidden py-24 lg:py-32">
        {/* Background Gradient */}
        <div className="absolute inset-0 bg-gradient-to-br from-orange-50 via-amber-50 to-white dark:from-slate-900 dark:via-orange-950/20 dark:to-slate-900"></div>
        {/* Decorative circles */}
        <div className="absolute top-20 right-0 w-96 h-96 bg-primary/10 rounded-full blur-3xl"></div>
        <div className="absolute bottom-0 left-0 w-72 h-72 bg-secondary/10 rounded-full blur-3xl"></div>

        <div className="relative max-w-7xl mx-auto px-4 grid lg:grid-cols-2 gap-12 items-center">
          <motion.div initial={{ opacity: 0, x: -40 }} animate={{ opacity: 1, x: 0 }} transition={{ duration: 0.7 }}>
            <span className="inline-block bg-primary/10 text-primary text-xs font-black uppercase tracking-widest px-4 py-1.5 rounded-full mb-6">
              🚀 Now delivering in 25+ cities
            </span>
            <h1 className="text-5xl lg:text-6xl font-black text-slate-900 dark:text-white leading-tight mb-6">
              Food You Love,<br />
              <span className="bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent">
                Delivered Fast
              </span>
            </h1>
            <p className="text-lg text-slate-500 dark:text-slate-400 mb-10 leading-relaxed max-w-lg">
              Discover the best restaurants near you. Order in seconds, track in real-time, and enjoy gourmet meals at your doorstep.
            </p>

            {/* Search Bar */}
            <form onSubmit={handleSearch} className="flex gap-3 max-w-lg">
              <div className="relative flex-1">
                <FaSearch className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
                <input
                  type="text"
                  placeholder='Try "Pizza", "Biryani", or "Burger"...'
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  className="w-full pl-11 pr-4 py-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 dark:text-slate-100 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary shadow-sm"
                />
              </div>
              <button type="submit" className="bg-primary hover:bg-primary-dark text-white px-6 py-4 rounded-2xl font-bold text-sm hover:shadow-xl hover:shadow-primary/30 transition-all flex items-center gap-2">
                Search <FaArrowRight />
              </button>
            </form>

            <div className="flex items-center gap-6 mt-8 text-sm text-slate-400">
              <span>🍕 25k+ Dishes</span>
              <span>⚡ Fast Delivery</span>
              <span>⭐ Top Rated</span>
            </div>
          </motion.div>

          {/* Hero Image Grid */}
          <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} transition={{ duration: 0.8, delay: 0.2 }} className="hidden lg:grid grid-cols-2 gap-4">
            {[
              'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300&q=80',
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&q=80',
              'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=300&q=80',
              'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=300&q=80',
            ].map((url, i) => (
              <motion.div key={i} animate={{ y: i % 2 === 0 ? [0, -10, 0] : [0, 10, 0] }} transition={{ repeat: Infinity, duration: 3 + i * 0.5 }} className="rounded-3xl overflow-hidden shadow-xl border border-white/50">
                <img src={url} alt="Food" className="w-full h-48 object-cover" />
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* Stats Banner */}
      <section className="py-12 bg-primary">
        <div className="max-w-7xl mx-auto px-4 grid grid-cols-2 lg:grid-cols-4 gap-8 text-center text-white">
          {stats.map((s, i) => (
            <motion.div key={i} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.1 }} viewport={{ once: true }}>
              <div className="text-3xl mb-2 flex justify-center opacity-80">{s.icon}</div>
              <p className="text-3xl font-black">{s.value}</p>
              <p className="text-sm opacity-80 font-medium">{s.label}</p>
            </motion.div>
          ))}
        </div>
      </section>

      {/* Food Categories */}
      <section className="py-20 max-w-7xl mx-auto px-4">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-black text-slate-800 dark:text-white mb-3">What Are You Craving?</h2>
          <p className="text-slate-400">Choose from hundreds of cuisines and dishes</p>
        </div>
        <div className="grid grid-cols-4 sm:grid-cols-8 gap-4">
          {categories.map((cat, i) => (
            <motion.button key={i} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.05 }} viewport={{ once: true }}
              onClick={() => navigate(`/home?search=${cat.name}`)}
              className={`${cat.color} p-4 rounded-2xl text-center hover:scale-110 hover:shadow-lg transition-all flex flex-col items-center gap-2 group`}>
              <span className="text-3xl">{cat.emoji}</span>
              <span className="text-xs font-bold">{cat.name}</span>
            </motion.button>
          ))}
        </div>
      </section>

      {/* How It Works */}
      <section className="py-20 bg-gradient-to-br from-slate-50 to-orange-50/50 dark:from-slate-900 dark:to-orange-950/10">
        <div className="max-w-7xl mx-auto px-4">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-black text-slate-800 dark:text-white mb-3">How BiteBurst Works</h2>
            <p className="text-slate-400">Three simple steps to gourmet food at your door</p>
          </div>
          <div className="grid md:grid-cols-3 gap-8">
            {[
              { step: '01', title: 'Choose a Restaurant', desc: 'Browse from 500+ top-rated restaurants nearby, filtered by cuisine, rating & delivery time.', emoji: '🔍' },
              { step: '02', title: 'Pick Your Favorites', desc: 'Add mouth-watering dishes to your cart and customize your order with special instructions.', emoji: '🛒' },
              { step: '03', title: 'Fast Delivery', desc: 'Track your order live as our dedicated delivery partner brings it piping hot to your door.', emoji: '🏍️' },
            ].map((s, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.15 }} viewport={{ once: true }}
                className="bg-white dark:bg-slate-800 rounded-3xl p-8 border border-slate-100 dark:border-slate-700 shadow-sm text-center hover:shadow-xl hover:-translate-y-1 transition-all">
                <div className="text-5xl mb-4">{s.emoji}</div>
                <div className="text-xs font-black text-primary/50 tracking-widest mb-2">STEP {s.step}</div>
                <h3 className="text-lg font-black text-slate-800 dark:text-white mb-3">{s.title}</h3>
                <p className="text-sm text-slate-400 leading-relaxed">{s.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Testimonials */}
      <section className="py-20 max-w-7xl mx-auto px-4">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-black text-slate-800 dark:text-white mb-3">Loved by Thousands</h2>
          <p className="text-slate-400">Real stories from our happy customers</p>
        </div>
        <div className="grid md:grid-cols-3 gap-6">
          {testimonials.map((t, i) => (
            <motion.div key={i} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.1 }} viewport={{ once: true }}
              className="bg-white dark:bg-slate-800 rounded-3xl p-6 border border-slate-100 dark:border-slate-700 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all">
              <div className="flex mb-3">
                {Array.from({ length: t.rating }).map((_, j) => <FaStar key={j} className="text-amber-400 text-xs" />)}
              </div>
              <p className="text-sm text-slate-500 dark:text-slate-400 italic leading-relaxed mb-5">"{t.text}"</p>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary to-secondary flex items-center justify-center text-white text-xs font-black">{t.avatar}</div>
                <span className="text-sm font-bold text-slate-800 dark:text-slate-200">{t.name}</span>
              </div>
            </motion.div>
          ))}
        </div>
      </section>

      {/* CTA Banner */}
      <section className="py-20 px-4">
        <div className="max-w-4xl mx-auto bg-gradient-to-r from-primary to-secondary rounded-3xl p-12 text-center text-white shadow-2xl shadow-primary/20">
          <h2 className="text-4xl font-black mb-4">Ready to Order? 🍽️</h2>
          <p className="text-lg opacity-90 mb-8">Join 2 million+ happy customers. Your first delivery fee is on us!</p>
          <Link to="/register" className="bg-white text-primary font-black px-10 py-4 rounded-2xl hover:bg-slate-100 transition-all text-base hover:shadow-lg inline-flex items-center gap-2">
            Start Ordering Free <FaArrowRight />
          </Link>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-slate-900 text-slate-400 py-10 text-center text-sm border-t border-slate-800">
        <p className="font-black text-2xl text-white mb-3">BITE<span className="text-primary">BURST</span></p>
        <p>&copy; {new Date().getFullYear()} BiteBurst Technologies. All rights reserved.</p>
        <div className="flex justify-center gap-6 mt-4 text-xs">
          <a href="#" className="hover:text-primary transition-colors">Privacy Policy</a>
          <a href="#" className="hover:text-primary transition-colors">Terms of Service</a>
          <a href="#" className="hover:text-primary transition-colors">Support</a>
        </div>
      </footer>
    </div>
  );
}
