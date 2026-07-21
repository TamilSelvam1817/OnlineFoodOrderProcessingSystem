import React, { useEffect, useRef } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { loginSuccess } from '../redux/slices/authSlice';
import { showToast } from '../components/Toast';
import { FaSpinner } from 'react-icons/fa';

export default function GoogleCallbackPage() {
  const navigate = useNavigate();
  const location = useLocation();
  const dispatch = useDispatch();
  const hasProcessed = useRef(false);

  useEffect(() => {
    if (hasProcessed.current) return;

    const params = new URLSearchParams(location.search);
    const token = params.get('token');
    const email = params.get('email');
    const name = params.get('name');
    const role = params.get('role');
    const userId = params.get('userId');

    if (token) {
      hasProcessed.current = true;

      // Successful Google Sign-In or Gmail Link
      dispatch(
        loginSuccess({
          token,
          email,
          name,
          role,
          userId: Number(userId),
        })
      );

      const pendingInvoiceOrderId = sessionStorage.getItem('pendingInvoiceOrderId');
      if (pendingInvoiceOrderId) {
        sessionStorage.removeItem('pendingInvoiceOrderId');
        navigate(`/orders?autoSendInvoice=${encodeURIComponent(pendingInvoiceOrderId)}`, { replace: true });
      } else {
        showToast(`Signed in with Google as ${name || email}! 🎉`, 'success');
        if (role === 'ROLE_ADMIN') {
          navigate('/admin', { replace: true });
        } else if (role === 'ROLE_RESTAURANT') {
          navigate('/restaurant-dashboard', { replace: true });
        } else {
          navigate('/home', { replace: true });
        }
      }
    } else if (params.has('error')) {
      hasProcessed.current = true;
      const errorMsg = params.get('error') || 'Google authentication failed';
      showToast(errorMsg, 'error');
      navigate('/login', { replace: true });
    }
  }, [location, dispatch, navigate]);

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-slate-50 dark:bg-slate-900 text-center px-4">
      <div className="bg-white dark:bg-slate-800 p-8 rounded-3xl shadow-xl border border-slate-100 dark:border-slate-700 flex flex-col items-center max-w-sm w-full">
        <FaSpinner className="animate-spin text-primary text-5xl mb-6" />
        <h3 className="text-xl font-black text-slate-800 dark:text-white mb-2">Authenticating...</h3>
        <p className="text-slate-400 text-sm">Finishing connection with Google OAuth 2.0</p>
      </div>
    </div>
  );
}
