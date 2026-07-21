import React, { useEffect, useState } from 'react';
import { FaCheckCircle, FaExclamationCircle, FaInfoCircle } from 'react-icons/fa';

let toastQueue = [];
let setToastsExternal = null;
let lastToastMessage = '';
let lastToastTime = 0;

export function showToast(message, type = 'success') {
  const now = Date.now();
  if (message === lastToastMessage && now - lastToastTime < 2000) {
    return; // Suppress rapid duplicate toasts
  }
  lastToastMessage = message;
  lastToastTime = now;

  const id = now + Math.random();
  const newToast = { id, message, type };
  toastQueue = [...toastQueue, newToast];
  if (setToastsExternal) setToastsExternal([...toastQueue]);
  setTimeout(() => {
    toastQueue = toastQueue.filter(t => t.id !== id);
    if (setToastsExternal) setToastsExternal([...toastQueue]);
  }, 3500);
}

export default function Toast() {
  const [toasts, setToasts] = useState([]);

  useEffect(() => {
    setToastsExternal = setToasts;
    return () => {
      setToastsExternal = null;
    };
  }, []);

  const icons = {
    success: <FaCheckCircle className="text-green-400" />,
    error: <FaExclamationCircle className="text-red-400" />,
    info: <FaInfoCircle className="text-blue-400" />,
  };

  const colors = {
    success: 'border-green-200 dark:border-green-800',
    error: 'border-red-200 dark:border-red-800',
    info: 'border-blue-200 dark:border-blue-800',
  };

  return (
    <div className="fixed bottom-6 right-6 z-[100] flex flex-col gap-3 pointer-events-none">
      {toasts.map((toast) => (
        <div
          key={toast.id}
          className={`flex items-center gap-3 bg-white dark:bg-slate-800 shadow-xl border ${colors[toast.type]} rounded-2xl px-4 py-3 min-w-[260px] max-w-sm pointer-events-auto`}
          style={{ animation: 'slideInRight 0.3s ease' }}
        >
          {icons[toast.type]}
          <span className="text-sm font-semibold text-slate-700 dark:text-slate-200 flex-1">{toast.message}</span>
        </div>
      ))}
      <style>{`@keyframes slideInRight { from { transform: translateX(100px); opacity:0; } to { transform: translateX(0); opacity:1; } }`}</style>
    </div>
  );
}
