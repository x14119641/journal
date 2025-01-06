<!-- Copy sideBar -->
<template>
  <div class="flex">
    <!-- Sidebar -->
    <div
      class="h-screen bg-gray-800 text-white p-5 pt-8 relative duration-300"
      :class="isSidebarOpen ? 'w-72' : 'w-20'"
    >
      <!-- Arrow -->
      <div @click="toggleSidebar">
        <span
          class="bg-white text-black top-8 -right-3 text-3xl absolute border border-gray-800 cursor-pointer"
        >
          <i
            class="pi pi-arrow-left"
            :class="isSidebarOpen ? '' : 'rotate-180'"
          ></i
        ></span>
      </div>
      <!-- App Icon -->
      <div class="inline-flex">
        <span
          class="bg-amber-300 text-4xl rounded cursor-pointer block float-left mr-2 duration-500"
          :class="isSidebarOpen ? '' : 'rotate-[360deg]'"
          ><i class="pi pi-book"></i
        ></span>
        <h1
          class="text-white origin-left font-medium text-3xl duration-300"
          :class="isSidebarOpen ? '' : 'scale-0'"
        >
          MyJournal
        </h1>
      </div>

      <!-- Items in menu -->
       <ul class="my-10 pt-2 space-y-4">
        <li v-for="(menu, index) in Menus" :key="index"
        class="text-sm flex items-center cursor-pointer p-2 text-gray-300 hover:bg-lime-50 rounded mt-2"
        :class="{'bg-blue-500 text-white': menu.isSpecial, 'text-gray-700': !menu.isSpecial}">
          <router-link :to="menu.link" exact  class="flex items-center w-full">
            <span class="text-2xl block float-left mr-3"><i :class="menu.icon"></i></span>
          <span class="text-base font-medium flex-1"
          :class="isSidebarOpen ? '' : 'hidden'">{{ menu.title }}</span>
          </router-link>
        </li>

       </ul>
    </div>
    <div class="p-8">
     
      <router-view />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const isOpen = ref(false);

// Toggle sidebar open/close state
const toggleSidebar = () => {
  isOpen.value = !isOpen.value;
};
</script>

<style scoped>
/* Add transition for smooth opening/closing of the sidebar */
.transition-transform {
  transition: transform 0.3s ease-in-out;
}
</style>