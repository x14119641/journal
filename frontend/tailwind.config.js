/** @type {import('tailwindcss').Config} */
export default {
  content:  ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}', 'node_modules/flowbite-vue/**/*.{js,ts}'],
  darkMode: "class",
  theme: {
    extend: {
      fontFamily: {
        bazooka: ['Bazooka', 'sans-serif']
      },
      colors:{
        customFuchsia: {
          1: '#c444ff',
          2: '#ff44ec',
          3: '#ff449e'
        }
      }
    },
  },
  plugins: [
    require('flowbite/plugin')
  ],
}

