<template>
  <div class="flex justify-center w-full transition-all">
    <div class="container-component w-full  sm:w-96 md:w-2/3 lg:w-1/2 xl:w-1/3">
      <LoginComponent />
    </div>
  </div>
</template>

<script setup lang="ts">
import LoginComponent from '../components/LoginComponent.vue';
// import { useSidebarStore } from "../stores/sideBarStore";
// import { computed } from "vue";

// const sidebarStore = useSidebarStore();

// const isSidebarOpen = computed(() => sidebarStore.isSidebarOpen);
</script>
