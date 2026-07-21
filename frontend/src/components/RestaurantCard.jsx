import React from 'react';
import { Link } from 'react-router-dom';
import { FaClock, FaStar, FaTags } from 'react-icons/fa';

export default function RestaurantCard({ restaurant }) {
  return (
    <Link
      to={`/restaurant/${restaurant.id}`}
      className="bg-white dark:bg-slate-800 rounded-3xl overflow-hidden border border-slate-100 dark:border-slate-700/60 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300 flex flex-col justify-between group"
    >
      {/* Thumbnail */}
      <div className="relative h-44 bg-slate-100 overflow-hidden">
        <img
          src={restaurant.imageUrl}
          alt={restaurant.name}
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
        />
        
        {/* Rating Overlay */}
        <div className="absolute bottom-3 left-3 bg-white/90 dark:bg-slate-900/90 backdrop-blur-md px-2.5 py-1 rounded-lg flex items-center gap-1 shadow-sm">
          <FaStar className="text-amber-500 text-xs" />
          <span className="text-xs font-black text-slate-800 dark:text-slate-100">{restaurant.rating.toFixed(1)}</span>
        </div>
      </div>

      {/* Details */}
      <div className="p-5 flex-1 flex flex-col justify-between">
        <div>
          <h3 className="text-base font-bold text-slate-800 dark:text-white line-clamp-1 group-hover:text-primary transition-colors mb-1">
            {restaurant.name}
          </h3>
          <p className="text-xs text-slate-400 dark:text-slate-400 line-clamp-2 mb-4 leading-relaxed">
            {restaurant.description}
          </p>
        </div>

        {/* Footer info line */}
        <div className="flex items-center justify-between text-[11px] font-bold text-slate-500 dark:text-slate-400 pt-3 border-t border-slate-100 dark:border-slate-700">
          <div className="flex items-center gap-1.5">
            <FaClock className="text-primary text-xs" />
            <span>{restaurant.deliveryTime} Mins</span>
          </div>

          <div className="flex items-center gap-1">
            <FaTags className="text-secondary text-xs" />
            <span>{restaurant.openingHours || restaurant.cuisine || 'Fast Food'}</span>
          </div>
        </div>
      </div>
    </Link>
  );
}
