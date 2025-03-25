<template>
  <span v-if="authStore.username" class="navbar-text">
    Hello, {{ authStore.username }}
  </span>

  <div v-if="authStore.username" class="pr-2">
    <button
      @click="toggleDropdown"
      :class="[
        'focus:outline-none',
        isDropdownOpen ? 'text-lime-300' : 'text-lime-500',
        'hover:text-lime-400',
      ]"
    >
      <svg
        class="w-6 h-6"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="3"
          d="M19 9l-7 7-7-7"
        />
      </svg>
    </button>
    <div
      v-if="isDropdownOpen"
      v-click-away="closeDropdown"
      class="absolute right-4 mt-1 w-40 dropdown-style "
    >
      <router-link to="/funds" class="block px-4 py-2 dropdown-text rounded-t-lg">
        Funds
      </router-link>
      <router-link to="/transactions" class="block px-4 py-2 dropdown-text">
        Transactions
      </router-link>
      <router-link to="/profile" class="block px-4 py-2 dropdown-text">
        Profile
      </router-link>
      <!-- Dark Mode Toggle Row -->
      <div class="flex items-center justify-between px-4 py-2 dropdown-text"
                 @click.stop>  <!-- Stop propagation here -->
              <span class="select-none">Theme</span>
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" class="sr-only peer" />
                <DarkModeToggle />
            </label>
            </div>

      <router-link
        to="/logout"
        @click="closeDropdown"
        class="block px-4 py-2 dropdown-text rounded-b-lg"
      >
        Logout
      </router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useAuthStore } from "../stores/authStore";
import { useNavBarStore } from "../stores/navBarStore";
import { computed } from "vue";
import DarkModeToggle from "./DarkModeToggle.vue";

const authStore = useAuthStore();
const navBarStore = useNavBarStore();
const isDropdownOpen = computed(() => navBarStore.isDropdownOpen);
const toggleDropdown = () => {
  navBarStore.toggleDropdown();
};
const closeDropdown = () => {
  navBarStore.closeDropdown();
};
</script>
<style >
.navbar-text{
  @apply text-primary font-bazooka inline self-center font-semibold whitespace-nowrap;
}
.dropdown-style {
 @apply bg-gray-300 dark:bg-gray-700  border border-lime-300 rounded-lg shadow-lg z-10;
}
.dropdown-text{
  @apply dark:text-indigo-300 hover:bg-gray-100 hover:text-gray-800;
}
</style>
