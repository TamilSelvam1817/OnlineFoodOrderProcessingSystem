import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import { useForm } from 'react-hook-form';
import { motion } from 'framer-motion';
import { loginStart, loginSuccess, loginFailure } from '../redux/slices/authSlice';
import { authService } from '../services/api';
import { FaEye, FaEyeSlash, FaEnvelope, FaLock } from 'react-icons/fa';
import { showToast } from '../components/Toast';

export default function LoginPage() {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { loading, error } = useSelector((state) => state.auth);
  const [showPassword, setShowPassword] = useState(false);

  const { register, handleSubmit, formState: { errors } } = useForm();

  const onSubmit = async (data) => {
    dispatch(loginStart());
    try {
      const res = await authService.login({ email: data.email, password: data.password });
      dispatch(loginSuccess(res.data));
      showToast('Welcome back! 🎉', 'success');
      const role = res.data.role;
      if (role === 'ROLE_ADMIN') navigate('/admin');
      else if (role === 'ROLE_RESTAURANT') navigate('/restaurant-dashboard');
      else navigate('/home');
    } catch (err) {
      const msg = err.response?.data?.message || 'Login failed. Please try again.';
      dispatch(loginFailure(msg));
      showToast(msg, 'error');
    }
  };

  const handleGoogleSignIn = () => {
    const backend = import.meta.env.VITE_API_URL;
    window.location.href = `${backend.replace("/api", "")}/oauth2/authorization/google`;
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-orange-50 via-amber-50/50 to-white dark:from-slate-900 dark:via-orange-950/10 dark:to-slate-900 px-4 relative overflow-hidden">
      {/* Background blobs */}
      <div className="absolute top-0 left-0 w-80 h-80 bg-primary/10 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2 pointer-events-none"></div>
      <div className="absolute bottom-0 right-0 w-80 h-80 bg-secondary/10 rounded-full blur-3xl translate-x-1/2 translate-y-1/2 pointer-events-none"></div>

      <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }}
        className="w-full max-w-md">

        {/* Logo */}
        <div className="text-center mb-8">
          <Link to="/" className="text-3xl font-black tracking-tight">
            <span className="text-primary">BITE</span><span className="text-secondary">BURST</span>
          </Link>
          <p className="text-slate-400 text-sm mt-1">Your favorite food, delivered fast</p>
        </div>

        {/* Card */}
        <div className="bg-white dark:bg-slate-800 rounded-3xl shadow-xl border border-slate-100 dark:border-slate-700 p-8">
          <h2 className="text-2xl font-black text-slate-800 dark:text-white mb-2">Welcome Back! 👋</h2>
          <p className="text-sm text-slate-400 mb-8">Sign in to continue ordering your favorites</p>

          <form onSubmit={handleSubmit(onSubmit)} className="space-y-5" noValidate>

            {/* Email */}
            <div>
              <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-2 uppercase tracking-wider">Email Address</label>
              <div className="relative">
                <FaEnvelope className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-sm" />
                <input type="email" placeholder="you@example.com" autoComplete="email"
                  {...register('email', { required: 'Email is required', pattern: { value: /^\S+@\S+\.\S+$/, message: 'Enter a valid email' } })}
                  className={`w-full pl-11 pr-4 py-3 rounded-xl border text-sm bg-slate-50 dark:bg-slate-900 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all ${errors.email ? 'border-red-400' : 'border-slate-200 dark:border-slate-700 focus:border-primary'}`}
                />
              </div>
              {errors.email && <p className="text-xs text-red-500 mt-1">{errors.email.message}</p>}
            </div>

            {/* Password */}
            <div>
              <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-2 uppercase tracking-wider">Password</label>
              <div className="relative">
                <FaLock className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-sm" />
                <input type={showPassword ? 'text' : 'password'} placeholder="Enter your password" autoComplete="current-password"
                  {...register('password', { required: 'Password is required', minLength: { value: 6, message: 'Password must be at least 6 characters' } })}
                  className={`w-full pl-11 pr-12 py-3 rounded-xl border text-sm bg-slate-50 dark:bg-slate-900 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all ${errors.password ? 'border-red-400' : 'border-slate-200 dark:border-slate-700 focus:border-primary'}`}
                />
                <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200">
                  {showPassword ? <FaEyeSlash size={14} /> : <FaEye size={14} />}
                </button>
              </div>
              {errors.password && <p className="text-xs text-red-500 mt-1">{errors.password.message}</p>}
            </div>

            {/* Remember + Forgot */}
            <div className="flex items-center justify-between text-xs">
              <label className="flex items-center gap-2 text-slate-500 dark:text-slate-400 cursor-pointer">
                <input type="checkbox" {...register('remember')} className="rounded accent-primary" />
                Remember me
              </label>
              <a href="#" className="text-primary font-bold hover:underline">Forgot password?</a>
            </div>

            {error && <p className="text-xs text-red-500 bg-red-50 dark:bg-red-950/20 border border-red-200 dark:border-red-800 rounded-xl px-3 py-2">{error}</p>}

            <button type="submit" disabled={loading}
              className="w-full bg-primary hover:bg-primary-dark text-white py-3.5 rounded-xl font-bold text-sm hover:shadow-xl hover:shadow-primary/30 transition-all disabled:opacity-70 disabled:cursor-not-allowed">
              {loading ? 'Signing In...' : 'Sign In →'}
            </button>
          </form>

          <div className="relative my-6 text-center">
            <div className="absolute inset-0 flex items-center"><div className="w-full border-t border-slate-200 dark:border-slate-700"></div></div>
            <span className="relative bg-white dark:bg-slate-800 px-4 text-xs text-slate-400">or continue with</span>
          </div>

          <button
            type="button"
            onClick={handleGoogleSignIn}
            className="w-full flex items-center justify-center gap-3 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 text-slate-700 dark:text-slate-200 py-3 rounded-xl font-bold text-sm hover:bg-slate-50 dark:hover:bg-slate-800 hover:shadow-md transition-all mb-6"
          >
            <svg className="w-5 h-5" viewBox="0 0 24 24">
              <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
              <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
              <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z" />
              <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z" />
            </svg>
            Sign in with Google
          </button>

          {/* Demo Credentials */}
          <div className="bg-slate-50 dark:bg-slate-900/60 rounded-2xl p-4 text-xs text-slate-500 dark:text-slate-400 space-y-1 border border-slate-100 dark:border-slate-700">
            <p className="font-bold text-slate-700 dark:text-slate-300 mb-2">🔑 Demo Credentials</p>
            <p>👤 Customer: customer@food.com / password</p>
            <p>🏪 Owner: owner@food.com / password</p>
            <p>🛡️ Admin: admin@food.com / password</p>
          </div>

          <p className="text-center text-sm text-slate-400 mt-6">
            New to BiteBurst?{' '}
            <Link to="/register" className="text-primary font-black hover:underline">Create Account</Link>
          </p>
        </div>
      </motion.div>
    </div>
  );
}
