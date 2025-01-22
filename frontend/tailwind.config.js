/** @type {import('tailwindcss').Config} */
export default {
  content:  ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}', 'node_modules/flowbite-vue/**/*.{js,ts}'],
  theme: {
    extend: {
      fontFamily: {
        bazooka: ['Bazooka', 'sans-serif']
      },
      colors:{
        customFuchsia: {
          1: '#FA2488',
          2: '#E1207A',
          3: '#C81C6C'
        }
      }
    },
  },
  plugins: [
    require('flowbite/plugin')
  ],
}

