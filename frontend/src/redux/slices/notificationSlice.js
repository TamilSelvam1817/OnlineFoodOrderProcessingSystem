import { createSlice } from '@reduxjs/toolkit';

const loadInitialNotifications = () => {
  try {
    const saved = localStorage.getItem('user_notifications');
    if (saved) return JSON.parse(saved);
  } catch (e) {
    console.error('Failed to load notifications from localStorage', e);
  }
  return [
    {
      id: 'welcome-1',
      type: 'welcome',
      title: 'Welcome to BiteBurst! 🎉',
      message: 'Explore top restaurants and order your favorite meals with fast delivery.',
      time: new Date().toISOString(),
      read: false,
      link: '/home'
    }
  ];
};

const notificationSlice = createSlice({
  name: 'notifications',
  initialState: {
    items: loadInitialNotifications(),
  },
  reducers: {
    addNotification: (state, action) => {
      const { title, message, type = 'info', link = null } = action.payload;
      const newNotif = {
        id: Date.now().toString() + Math.random().toString(36).substr(2, 4),
        type,
        title,
        message,
        time: new Date().toISOString(),
        read: false,
        link
      };
      state.items.unshift(newNotif);
      try {
        localStorage.setItem('user_notifications', JSON.stringify(state.items.slice(0, 30)));
      } catch (e) {
        console.error('Failed to save notification', e);
      }
    },
    markAsRead: (state, action) => {
      const id = action.payload;
      const target = state.items.find((n) => n.id === id);
      if (target) {
        target.read = true;
      }
      try {
        localStorage.setItem('user_notifications', JSON.stringify(state.items));
      } catch (e) {
        console.error('Failed to update notification status', e);
      }
    },
    markAllAsRead: (state) => {
      state.items.forEach((n) => { n.read = true; });
      try {
        localStorage.setItem('user_notifications', JSON.stringify(state.items));
      } catch (e) {
        console.error('Failed to mark all notifications as read', e);
      }
    },
    clearAllNotifications: (state) => {
      state.items = [];
      try {
        localStorage.setItem('user_notifications', JSON.stringify([]));
      } catch (e) {
        console.error('Failed to clear notifications', e);
      }
    }
  }
});

export const { addNotification, markAsRead, markAllAsRead, clearAllNotifications } = notificationSlice.actions;
export default notificationSlice.reducer;
