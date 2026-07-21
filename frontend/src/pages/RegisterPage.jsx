import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { motion } from 'framer-motion';
import { authService } from '../services/api';
import { showToast } from '../components/Toast';
import { FaUser, FaEnvelope, FaLock, FaEye, FaEyeSlash, FaCheckCircle } from 'react-icons/fa';

export default function RegisterPage() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const { register, handleSubmit, watch, formState: { errors } } = useForm();
  const password = watch('password');

  const onSubmit = async (data) => {
    setLoading(true);
    try {
      await authService.register({ name: data.name, email: data.email, password: data.password, role: data.role });
      setSuccess(true);
      showToast('Account created successfully! 🎉', 'success');
      setTimeout(() => navigate('/login'), 2000);
    } catch (err) {
      const msg = err.response?.data?.message || 'Registration failed. Try again.';
      showToast(msg, 'error');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen grid lg:grid-cols-2">

      {/* Left Visual Panel */}
      <div className="hidden lg:flex flex-col justify-center items-center bg-gradient-to-br from-primary to-secondary relative overflow-hidden p-12">
        <div className="absolute inset-0 opacity-10" style={{ backgroundImage: 'radial-gradient(circle at 20% 30%, white 1px, transparent 1px), radial-gradient(circle at 80% 70%, white 1px, transparent 1px)', backgroundSize: '60px 60px' }}></div>
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.8 }} className="relative z-10 text-white text-center">
          <div className="text-7xl mb-6">🍔</div>
          <h2 className="text-4xl font-black mb-4">Join BiteBurst</h2>
          <p className="text-lg opacity-90 max-w-sm leading-relaxed">Unlock access to 500+ restaurants, exclusive offers, and real-time order tracking.</p>
          <div className="mt-10 grid grid-cols-2 gap-4 max-w-xs text-left">
            {['500+ Restaurants', 'Live Tracking', 'Exclusive Deals', 'Fast Delivery'].map((f, i) => (
              <div key={i} className="flex items-center gap-2 text-sm font-semibold bg-white/10 rounded-xl px-3 py-2">
                <span className="text-green-300">✓</span> {f}
              </div>
            ))}
          </div>
        </motion.div>
        {/* Floating Food Images */}
        <motion.img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=150&q=80" alt="food" animate={{ y: [0, -15, 0] }} transition={{ repeat: Infinity, duration: 3 }} className="absolute top-10 right-10 w-24 h-24 object-cover rounded-2xl shadow-2xl border-4 border-white/30" />
        <motion.img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=150&q=80" alt="food" animate={{ y: [0, 15, 0] }} transition={{ repeat: Infinity, duration: 4, delay: 1 }} className="absolute bottom-16 left-10 w-24 h-24 object-cover rounded-2xl shadow-2xl border-4 border-white/30" />
      </div>

      {/* Right Form Panel */}
      <div className="flex items-center justify-center p-8 bg-[#F8F9FA] dark:bg-slate-900">
        <motion.div initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} transition={{ duration: 0.6 }} className="w-full max-w-md">

          <div className="mb-8">
            <Link to="/" className="text-2xl font-black"><span className="text-primary">BITE</span><span className="text-secondary">BURST</span></Link>
            <h1 className="text-2xl font-black text-slate-800 dark:text-white mt-4">Create your account</h1>
            <p className="text-sm text-slate-400 mt-1">Start ordering in just 30 seconds</p>
          </div>

          {success ? (
            <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="text-center py-12">
              <FaCheckCircle className="text-green-500 text-6xl mx-auto mb-4" />
              <h3 className="text-xl font-black text-slate-800 dark:text-white">Account Created!</h3>
              <p className="text-slate-400 mt-2">Redirecting you to login...</p>
            </motion.div>
          ) : (
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-5" noValidate>

              {/* Name */}
              <div>
                <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-2 uppercase tracking-wider">Full Name</label>
                <div className="relative">
                  <FaUser className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-sm" />
                  <input type="text" placeholder="John Doe"
                    {...register('name', { required: 'Name is required', minLength: { value: 2, message: 'Name too short' } })}
                    className={`w-full pl-11 pr-4 py-3 rounded-xl border text-sm bg-white dark:bg-slate-800 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all ${errors.name ? 'border-red-400' : 'border-slate-200 dark:border-slate-700 focus:border-primary'}`}
                  />
                </div>
                {errors.name && <p className="text-xs text-red-500 mt-1">{errors.name.message}</p>}
              </div>

              {/* Email */}
              <div>
                <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-2 uppercase tracking-wider">Email Address</label>
                <div className="relative">
                  <FaEnvelope className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-sm" />
                  <input type="email" placeholder="you@example.com"
                    {...register('email', { required: 'Email is required', pattern: { value: /^\S+@\S+\.\S+$/, message: 'Enter a valid email' } })}
                    className={`w-full pl-11 pr-4 py-3 rounded-xl border text-sm bg-white dark:bg-slate-800 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all ${errors.email ? 'border-red-400' : 'border-slate-200 dark:border-slate-700 focus:border-primary'}`}
                  />
                </div>
                {errors.email && <p className="text-xs text-red-500 mt-1">{errors.email.message}</p>}
              </div>

              {/* Role */}
              <div>
                <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-2 uppercase tracking-wider">Register As</label>
                <select {...register('role')}
                  className="w-full px-4 py-3 rounded-xl border border-slate-200 dark:border-slate-700 text-sm bg-white dark:bg-slate-800 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary">
                  <option value="ROLE_CUSTOMER">Customer</option>
                  <option value="ROLE_RESTAURANT">Restaurant Partner</option>
                </select>
              </div>

              {/* Password */}
              <div>
                <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-2 uppercase tracking-wider">Password</label>
                <div className="relative">
                  <FaLock className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-sm" />
                  <input type={showPassword ? 'text' : 'password'} placeholder="Create a strong password"
                    {...register('password', { required: 'Password is required', minLength: { value: 6, message: 'Minimum 6 characters required' } })}
                    className={`w-full pl-11 pr-12 py-3 rounded-xl border text-sm bg-white dark:bg-slate-800 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all ${errors.password ? 'border-red-400' : 'border-slate-200 dark:border-slate-700 focus:border-primary'}`}
                  />
                  <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400">
                    {showPassword ? <FaEyeSlash size={14} /> : <FaEye size={14} />}
                  </button>
                </div>
                {errors.password && <p className="text-xs text-red-500 mt-1">{errors.password.message}</p>}
              </div>

              {/* Confirm Password */}
              <div>
                <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-2 uppercase tracking-wider">Confirm Password</label>
                <div className="relative">
                  <FaLock className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-sm" />
                  <input type="password" placeholder="Repeat your password"
                    {...register('confirmPassword', { required: 'Please confirm your password', validate: (v) => v === password || 'Passwords do not match' })}
                    className={`w-full pl-11 pr-4 py-3 rounded-xl border text-sm bg-white dark:bg-slate-800 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all ${errors.confirmPassword ? 'border-red-400' : 'border-slate-200 dark:border-slate-700 focus:border-primary'}`}
                  />
                </div>
                {errors.confirmPassword && <p className="text-xs text-red-500 mt-1">{errors.confirmPassword.message}</p>}
              </div>

              <button type="submit" disabled={loading}
                className="w-full bg-primary hover:bg-primary-dark text-white py-3.5 rounded-xl font-bold text-sm hover:shadow-xl hover:shadow-primary/30 transition-all disabled:opacity-70 mt-2">
                {loading ? 'Creating Account...' : 'Create Free Account →'}
              </button>

              <p className="text-center text-xs text-slate-400 pt-1">
                Already have an account?{' '}
                <Link to="/login" className="text-primary font-black hover:underline">Sign In</Link>
              </p>
            </form>
          )}
        </motion.div>
      </div>
    </div>
  );
}
