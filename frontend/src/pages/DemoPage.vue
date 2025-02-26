<template>
  <div class="slate-container">
    <div class="p-6 text-center">
      <div class="grid grid-cols-2 gap-x-12 gap-y-4 w-fit mx-auto">
        <!-- Custom Colors Row -->
        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Custom</p>
          <div class="flex justify-center gap-1">
            <div
              v-for="(color, index) in colors"
              :key="index"
              :style="{ backgroundColor: color }"
              class="w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>
        <!-- Custom2 Colors Row -->
        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Custom2</p>
          <div class="flex justify-center gap-1">
            <div
              v-for="(color, index) in colors2"
              :key="index"
              :style="{ backgroundColor: color }"
              class="w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Red</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-red-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-red-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-red-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-red-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-red-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-red-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-red-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-red-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-red-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Orange</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-orange-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-orange-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-orange-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-orange-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-orange-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-orange-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-orange-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-orange-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-orange-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Amber</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-amber-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-amber-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-amber-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-amber-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-amber-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-amber-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-amber-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-amber-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-amber-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Yellow</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-yellow-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-yellow-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-yellow-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-yellow-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-yellow-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-yellow-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-yellow-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-yellow-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-yellow-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Lime</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-lime-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-lime-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-lime-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-lime-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-lime-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-lime-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-lime-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-lime-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-lime-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Green</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-green-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-green-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-green-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-green-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-green-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-green-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-green-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-green-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-green-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Emerald</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-emerald-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-emerald-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-emerald-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-emerald-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-emerald-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-emerald-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-emerald-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-emerald-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-emerald-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Teal</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-teal-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-teal-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-teal-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-teal-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-teal-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-teal-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-teal-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-teal-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-teal-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Cyan</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-cyan-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-cyan-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-cyan-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-cyan-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-cyan-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-cyan-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-cyan-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-cyan-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-cyan-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Sky</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-sky-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-sky-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-sky-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-sky-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-sky-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-sky-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-sky-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-sky-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-sky-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Blue</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-blue-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-blue-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-blue-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-blue-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-blue-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-blue-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-blue-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-blue-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-blue-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Indigo</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-indigo-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-indigo-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-indigo-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-indigo-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-indigo-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-indigo-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-indigo-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-indigo-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-indigo-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Violet</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-violet-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-violet-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-violet-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-violet-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-violet-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-violet-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-violet-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-violet-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-violet-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Purple</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-purple-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-purple-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-purple-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-purple-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-purple-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-purple-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-purple-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-purple-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-purple-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Fuchsia</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-fuchsia-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-fuchsia-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-fuchsia-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-fuchsia-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-fuchsia-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-fuchsia-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-fuchsia-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-fuchsia-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-fuchsia-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Pink</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-pink-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-pink-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-pink-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-pink-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-pink-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-pink-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-pink-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-pink-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-pink-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Rose</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-rose-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-rose-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-rose-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-rose-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-rose-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-rose-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-rose-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-rose-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-rose-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Slate</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-slate-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-slate-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-slate-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-slate-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-slate-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-slate-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-slate-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-slate-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-slate-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Gray</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-gray-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-gray-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-gray-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-gray-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-gray-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-gray-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-gray-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-gray-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-gray-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Zinc</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-zinc-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-zinc-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-zinc-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-zinc-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-zinc-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-zinc-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-zinc-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-zinc-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-zinc-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Neutral</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-neutral-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-neutral-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-neutral-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-neutral-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-neutral-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-neutral-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-neutral-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-neutral-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-neutral-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Stone</p>
          <div class="flex justify-center gap-1">
            <div
              class="bg-stone-100 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-stone-200 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-stone-300 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-stone-400 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-stone-500 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-stone-600 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-stone-700 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-stone-800 w-12 h-12 border border-white rounded-md"
            ></div>
            <div
              class="bg-stone-900 w-12 h-12 border border-white rounded-md"
            ></div>
          </div>
        </div>

        

      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";

const colors = ref([
  "#FF0000",
  "#00FF00",
  "#0000FF",
  "#FFFF00",
  "#FF00FF",
  "#00FFFF",
  "#FFA500",
  "#800080",
  "#008000",
]);

const colors2 = ref([
  "#FF0000",
  "#00FF00",
  "#0000FF",
  "#FFFF00",
  "#FF00FF",
  "#00FFFF",
  "#FFA500",
  "#800080",
  "#008000",
]);
</script>

<style scoped></style>
