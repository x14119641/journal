/** @type {import('tailwindcss').Config} */
export default {
  content:  ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}', ],
  darkMode: "class",
  theme: {
    extend: {
      fontFamily: {
        bazooka: ['Bazooka', 'sans-serif']
      },
      colors:{
        // light
        lightGreen:{
          // https://colorkit.co/color/daffcc/
          1:'#daffcc',
          2:'#bddeb1',
          3:'#a2be97',
        },
        lightBlack:{
          // https://colorkit.co/color/adadad/
          1:'#bdbdbd',
          2:'#b5b5b5',
          3:'#adadad',
        },
        lightCyan:{
          // https://colorkit.co/color/d2fff1/
          1:'#d2fff1',
          2:'#b6ded2',
          3:'#9bbeb3',
        },
        lightRose:{
          // https://colorkit.co/color/#ffc7d5/
          1:'#ffc7d5',
          2:'#deadb9',
          3:'#be939e',
        },
        lightGold:{
          // https://colorkit.co/color/fff4cb/
          1:'#daffcc',
          2:'#ded4b0',
          3:'#beb596',
        },
        // dark
        darkGreen:{
          // https://colorkit.co/color/72ff00/
          1:'#72ff00',
          2:'#62de00',
          3:'#53be00',
        },
        darkBlack:{
          // https://colorkit.co/color/0d0d0d/
          1:'#353535',
          2:'#202020',
          3:'#0d0d0d',
        },
        darkCyan:{
          // https://colorkit.co/color/00ffd1/
          1:'#00ffd1',
          2:'#00deb5',
          3:'#00be9b',
        },
        darkRose:{
          // https://colorkit.co/color/ff007a/
          1:'#ff3f86',
          2:'#ff5d93',
          3:'#ff007a',
          4:'#de0069',
          5:'#be0059',
        },
        darkGold:{
          // https://colorkit.co/color/ffd700/
          1:'#ffe064',
          2:'#ffdc45',
          3:'#ffd700',
          4:'#debb00',
          5:'#be9f00',
        },
        customFuchsia: {
          1: '#c444ff',
          2: '#202020',
          3: '#ffd700'
        }
      }
    },
  },

}

