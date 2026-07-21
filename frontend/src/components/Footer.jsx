import React from 'react';
import { Link } from 'react-router-dom';
import { FaFacebookF, FaTwitter, FaInstagram, FaPlay, FaApple } from 'react-icons/fa';

export default function Footer() {
  return (
    <footer className="bg-slate-900 text-slate-400 py-12 border-t border-slate-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 grid grid-cols-1 md:grid-cols-4 gap-8">
        
        {/* About */}
        <div className="flex flex-col gap-4">
          <Link to="/" className="text-2xl font-black tracking-tight text-white">
            BITE<span className="text-primary">BURST</span>
          </Link>
          <p className="text-sm text-slate-400">
            Delivering hot, freshly prepared premium meals from top-rated restaurants straight to your doorstep in minutes.
          </p>
          <div className="flex gap-4 mt-2">
            <a href="#" className="p-2.5 rounded-full bg-slate-800 hover:bg-primary text-white hover:scale-115 transition-all"><FaFacebookF /></a>
            <a href="#" className="p-2.5 rounded-full bg-slate-800 hover:bg-primary text-white hover:scale-115 transition-all"><FaTwitter /></a>
            <a href="#" className="p-2.5 rounded-full bg-slate-800 hover:bg-primary text-white hover:scale-115 transition-all"><FaInstagram /></a>
          </div>
        </div>

        {/* Cuisines */}
        <div>
          <h4 className="text-sm font-bold text-white uppercase tracking-wider mb-4">Quick Links</h4>
          <ul className="space-y-2 text-sm">
            <li><Link to="/home" className="hover:text-primary transition-colors">Order Now</Link></li>
            <li><Link to="/profile" className="hover:text-primary transition-colors">My Profile</Link></li>
            <li><Link to="/orders" className="hover:text-primary transition-colors">Track Orders</Link></li>
            <li><a href="#" className="hover:text-primary transition-colors">Help & Support</a></li>
          </ul>
        </div>

        {/* Legal */}
        <div>
          <h4 className="text-sm font-bold text-white uppercase tracking-wider mb-4">Legal</h4>
          <ul className="space-y-2 text-sm">
            <li><a href="#" className="hover:text-primary transition-colors">Terms of Service</a></li>
            <li><a href="#" className="hover:text-primary transition-colors">Privacy Policy</a></li>
            <li><a href="#" className="hover:text-primary transition-colors">Refund & Cancellation</a></li>
            <li><a href="#" className="hover:text-primary transition-colors">Cookie Policy</a></li>
          </ul>
        </div>

        {/* Download App */}
        <div>
          <h4 className="text-sm font-bold text-white uppercase tracking-wider mb-4">Download Our App</h4>
          <p className="text-sm mb-4">Get the best food experience on your mobile device.</p>
          <div className="space-y-3">
            <a href="#" className="flex items-center gap-3 bg-slate-800 text-white px-4 py-2.5 rounded-xl hover:bg-slate-700 transition-colors">
              <FaApple className="text-2xl" />
              <div className="text-left">
                <p className="text-[10px] uppercase text-slate-400">Download on the</p>
                <p className="text-xs font-bold leading-tight">App Store</p>
              </div>
            </a>
            <a href="#" className="flex items-center gap-3 bg-slate-800 text-white px-4 py-2.5 rounded-xl hover:bg-slate-700 transition-colors">
              <FaPlay className="text-2xl" />
              <div className="text-left">
                <p className="text-[10px] uppercase text-slate-400">Get it on</p>
                <p className="text-xs font-bold leading-tight">Google Play</p>
              </div>
            </a>
          </div>
        </div>

      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-12 pt-8 border-t border-slate-800 text-center text-xs">
        <p>&copy; {new Date().getFullYear()} BiteBurst Technologies Private Limited. All rights reserved.</p>
      </div>
    </footer>
  );
}
