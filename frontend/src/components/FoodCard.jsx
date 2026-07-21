import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { addToCart, updateQuantity } from '../redux/slices/cartSlice';
import { FaRegHeart } from 'react-icons/fa';

export default function FoodCard({ food, restaurant }) {
  const dispatch = useDispatch();
  const cartItems = useSelector((state) => state.cart.items);
  
  const cartItem = cartItems.find((item) => item.id === food.id);
  const isVeg = food.veg;

  const handleAdd = () => {
    const targetRestId = restaurant?.id || food.restaurant?.id;
    const targetRestName = restaurant?.name || food.restaurant?.name;

    dispatch(addToCart({
      id: food.id,
      name: food.name,
      price: food.price,
      imageUrl: food.imageUrl,
      restaurantId: targetRestId,
      restaurantName: targetRestName
    }));
  };

  const handleQtyChange = (amount) => {
    if (cartItem) {
      dispatch(updateQuantity({ id: food.id, quantity: cartItem.quantity + amount }));
    }
  };

  return (
    <div className="bg-white dark:bg-slate-800 rounded-3xl overflow-hidden border border-slate-100 dark:border-slate-700/60 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300 flex flex-col justify-between group">
      
      {/* Food Image & Favorite Button */}
      <div className="relative h-44 overflow-hidden bg-slate-100">
        <img
          src={food.imageUrl}
          alt={food.name}
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
        />
        
        {/* Veg/Non-veg Indicator */}
        <span className={`absolute top-3 left-3 px-2.5 py-0.5 rounded-full text-[9px] font-extrabold uppercase tracking-wider text-white shadow-md ${
          isVeg ? 'bg-green-500' : 'bg-red-500'
        }`}>
          {isVeg ? 'Veg' : 'Non-Veg'}
        </span>

        {/* Favorite Icon */}
        <button className="absolute top-3 right-3 p-2 bg-white/70 backdrop-blur-md rounded-full text-slate-700 hover:text-red-500 hover:bg-white hover:scale-110 transition-all shadow-sm">
          <FaRegHeart size={14} />
        </button>
      </div>

      {/* Details */}
      <div className="p-4 flex-1 flex flex-col justify-between">
        <div className="mb-4">
          <div className="flex items-start justify-between gap-2 mb-1">
            <h3 className="text-sm font-bold text-slate-800 dark:text-white line-clamp-1 group-hover:text-primary transition-colors">
              {food.name}
            </h3>
            <span className="text-xs bg-amber-50 dark:bg-amber-950/20 text-amber-500 font-extrabold px-1.5 py-0.5 rounded">
              ★ 4.5
            </span>
          </div>
          <p className="text-xs text-slate-400 dark:text-slate-400 line-clamp-2 mt-1">
            {food.description}
          </p>
        </div>

        {/* Action Bottom */}
        <div className="flex items-center justify-between mt-auto">
          <span className="text-base font-black text-slate-800 dark:text-white">
            ${food.price.toFixed(2)}
          </span>

          {cartItem ? (
            <div className="flex items-center gap-3.5 bg-primary/10 text-primary border border-primary/20 px-3 py-1 rounded-full">
              <button onClick={() => handleQtyChange(-1)} className="font-extrabold text-sm hover:scale-110 transition-transform">-</button>
              <span className="text-xs font-bold">{cartItem.quantity}</span>
              <button onClick={() => handleQtyChange(1)} className="font-extrabold text-sm hover:scale-110 transition-transform">+</button>
            </div>
          ) : (
            <button
              onClick={handleAdd}
              disabled={!food.available}
              className="bg-primary hover:bg-primary-dark text-white px-4 py-1.5 rounded-full text-xs font-bold hover:shadow-lg hover:shadow-primary/20 transition-all disabled:bg-slate-300 dark:disabled:bg-slate-700 dark:disabled:text-slate-500"
            >
              {food.available ? 'Add to Cart' : 'Out of Stock'}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
