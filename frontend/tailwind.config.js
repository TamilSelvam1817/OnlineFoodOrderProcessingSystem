/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#FF6B35',
          light: '#ff8558',
          dark: '#e04f19',
        },
        secondary: {
          DEFAULT: '#F7931E',
          light: '#f9a84b',
          dark: '#d67507',
        },
        customBg: {
          light: '#F8F9FA',
          dark: '#0f172a',
        },
        cardBg: {
          light: '#ffffff',
          dark: '#1e293b',
        }
      },
      borderRadius: {
        'custom': '16px',
      }
    },
  },
  plugins: [],
}
