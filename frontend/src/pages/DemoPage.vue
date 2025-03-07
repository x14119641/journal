<template>
  <div class="slate-container">
    <div class="p-6 text-center">
      <div class="grid grid-cols-2 gap-x-12 gap-y-4 w-fit mx-auto">
        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Basic</p>
          <div class="flex justify-center gap-1">
            <input
              type="datetime-local"
              class="border border-gray-300 rounded-lg p-2 text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">DarkFriendly</p>
          <div class="flex justify-center gap-1">
            <input
              type="datetime-local"
              class="border border-gray-500 dark:border-gray-300 bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100 rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-purple-500"
            />
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">SoftShadows</p>
          <div class="flex justify-center gap-1">
            <input
              type="datetime-local"
              class="border border-gray-300 shadow-md rounded-lg p-3 text-gray-700 focus:ring focus:ring-blue-300 focus:outline-none"
            />
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Glassmophism</p>
          <div class="flex justify-center gap-1">
            <input
              type="datetime-local"
              class="bg-white/30 backdrop-blur-lg border border-white/20 rounded-lg p-2 text-gray-900 focus:ring focus:ring-blue-400"
            />
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Minimalist</p>
          <div class="flex justify-center gap-1">
            <input
              type="datetime-local"
              class="border-b-2 border-gray-400 focus:border-blue-500 focus:outline-none text-gray-700 p-2 w-full"
            />
          </div>
        </div>
        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">
            RoundedFullBackground
          </p>
          <div class="flex justify-center gap-1">
            <input
              type="datetime-local"
              class="bg-gray-200 text-gray-900 rounded-full px-4 py-2 focus:bg-white focus:ring focus:ring-blue-300"
            />
          </div>
        </div>
        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">ErrorStyyke</p>
          <div class="flex justify-center gap-1">
            <input
              type="datetime-local"
              class="border border-red-500 bg-red-50 text-red-700 rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-red-500"
            />
          </div>
        </div>
        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Tailwind with icon</p>
          <div class="flex justify-center gap-1">
            <div class="relative">
              <input
                type="datetime-local"
                class="border border-gray-300 rounded-lg p-2 pl-10 text-gray-700 focus:ring focus:ring-blue-300"
              />
              <svg
                class="w-5 h-5 text-gray-400 absolute left-3 top-3"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M8 7V3m8 4V3m-9 4h10M5 11h14M5 15h14M5 19h14"
                />
              </svg>
            </div>
          </div>
        </div>
        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Custom Styling</p>
          <div class="flex justify-center gap-1"><input type="datetime-local" 
  class="appearance-none border border-gray-300 rounded-lg p-2 text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
</div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Hidding icon</p>
          <div class="flex justify-center gap-1"><input type="datetime-local"
  class="border border-gray-300 rounded-lg p-2 text-gray-700 focus:ring-2 focus:ring-blue-500" 
  onfocus="this.showPicker()"
  style="position: relative; appearance: none; -webkit-appearance: none; -moz-appearance: none;">
</div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">flicker</p>
          <div class="flex justify-center gap-1" > <input type="text" id="custom-datetime" class="border border-gray-300 rounded-lg p-2 w-full text-gray-700 focus:ring-2 focus:ring-blue-500">
          </div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Custom</p>
          <div class="flex justify-center gap-1"></div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Custom</p>
          <div class="flex justify-center gap-1"></div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Custom</p>
          <div class="flex justify-center gap-1"></div>
        </div>

        <div class="flex items-center gap-4">
          <p class="text-white font-bold w-24 text-right">Custom</p>
          <div class="flex justify-center gap-1"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from "vue";
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css"; // Import styles
onMounted(() => {
  flatpickr("#custom-datetime", {
    enableTime: true,
    dateFormat: "Y-m-d H:i",
  });
});
</script>
