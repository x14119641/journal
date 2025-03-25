<template>
  <div class="flex flex-col h-screen">
    <!-- Navbar -->
    <Navbar></Navbar>

    <div class="flex flex-1 ">
      <!-- Sidebar -->
      <Sidebar class=""></Sidebar>

      <!-- Main Content -->
      <main class="flex-1 main-container   p-4">
        <router-view class=""/>
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
