<template>
  <div class="flex flex-col h-screen">
    <!-- Navbar -->
    <Navbar></Navbar>

    <div class="flex flex-1">
      <!-- Sidebar -->
      <Sidebar></Sidebar>

      <!-- Main Content -->
      <main class="flex-1 bg-slate-700  p-4">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import Sidebar from "./components/Sidebar.vue";
import Navbar from "./components/Navbar.vue";
import { useSidebarStore } from "./stores/sideBarStore";
import { computed } from "vue";


// Access the store
const sidebarStore = useSidebarStore();

// Computed properties to use store values
const isSidebarOpen = computed(() => sidebarStore.isSidebarOpen);
const toggleSidebar = () => {
  sidebarStore.toggleSidebar();
};

// Here is the items in sidebar
const Menus = [
  {
    title: "Hello",
    link: "/hello",
    icon: "w-6 h-6 text-gray-600 hover:text-indigo-600",
    isSpecial: false,
  },
  {
    title: "Demo",
    link: "/demo",
    icon: "w-6 h-6 text-gray-600 hover:text-indigo-600",
    isSpecial: false,
  },
  {
    title: "Profile",
    link: "/profile",
    icon: "w-6 h-6 text-gray-600 hover:text-indigo-600",
    isSpecial: true,
  },
  {
    title: "Table",
    link: "/table",
    icon: "w-6 h-6 text-gray-600 hover:text-indigo-600",
    isSpecial: false,
  },
];
</script>

<style scoped>
@keyframes flip {
  0%,
  100% {
    transform: scaleX(1);
  }
  25%,
  75% {
    transform: scaleX(-1);
  }
}

.animate-flip {
  animation: flip 0.5s ease-in-out 1; /* 1s for each flip, repeated 2 times */
}
</style>
