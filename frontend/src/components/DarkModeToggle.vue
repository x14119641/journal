<template>
    <div class="flex items-center justify-center">
      <button
        @click="toggleDarkMode"
        class="relative inline-flex items-center h-6 w-12 rounded-full focus:outline-none"
        :class="isDark ? 'bg-container-2' : 'bg-container-1'"
      >
        <!-- The toggle knob -->
        <span
          :class="[
            'absolute top-1 left-1 h-4 w-4 rounded-full bg-white transition-transform duration-300',
            isDark ? 'translate-x-6' : 'translate-x-0'
          ]"
        >
          <template v-if="isDark">
            <!-- Sun Icon when dark mode is active -->
            <img :src="sunIcon" alt="Sun" class="w-4 h-4" />
          </template>
          <template v-else>
            <!-- Moon Icon when light mode is active -->
            <img :src="moonIcon" alt="Moon" class="w-4 h-4" />
          </template>
        </span>
      </button>
    </div>
    
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted } from "vue";
  import sunIcon from "@/assets/img/sun-svgrepo-com.svg";
  import moonIcon from "@/assets/img/moon-svgrepo-com.svg";
  import { applyTheme, getUserTheme } from "../services/theme";

  const isDark = ref(getUserTheme() ==="dark")
  
  const toggleDarkMode = () => {
    const newTheme = isDark.value ? "light" : "dark";  applyTheme(newTheme);
    applyTheme(newTheme);
    isDark.value = newTheme === "dark";
};
onMounted(() => {
  isDark.value = getUserTheme() === "dark";
});
  </script>
  
  <style scoped>

  </style>