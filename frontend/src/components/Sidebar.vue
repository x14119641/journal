<template>
  <aside class="sidebar-style p-4" :class="isSidebarOpen ? 'w-80' : 'w-24'">
    <div class="relative">
      <!-- App Icon -->
      <div class="mt-2 inline-flex">
        <!-- <Notebook
          class="notebook-icon cursor-pointer mr-2 duration-500"
          :class="isSidebarOpen ? '' : 'animate-flip'"
        /> -->
        <img :src="notebookIcon" alt="Notebook Icon"  class="size-14 cursor-pointer mr-2 duration-400"
        :class="isSidebarOpen ? '' : 'animate-flip'" />
        <!-- App Text -->
        <h1
          class="text-white origin-left ml-1 mt-2 font-bazooka font-medium text-3xl duration-200"
          :class="isSidebarOpen ? '' : 'scale-0'"
        >
          Jornolio
        </h1>
      </div>
      <!-- Alien -->
      <div
        @click="toggleSidebar"
        class="absolute top-1 -right-9 cursor-pointer"
      >
        <!-- <IconAlien class="w-10 h-10" alt="Icon" 
      base-color="#2ed422"
      :fill-color="isSidebarOpen ? '#2ed422' : '#e635e0'"
      :fill-color2="isSidebarOpen ? '#e635e0' : '#2ed422'"/> -->
        <EllipsisVertical class="w-10 h-10 stroke-lime-400 stroke-primary" />
      </div>
      <!-- Items in menu -->
      <div>
        <ul class="my-10 space-y-4">
          <!-- Demo -->
          <li
            class="sidebar-li-style group flex items-center cursor-pointer select-none p-1 rounded-lg mt-2"
          >
            <router-link to="/demo" class="flex items-center w-full">
              <span class="block float-left">
                <!-- <img :src="testingFlasksIcon" class="w-10 h-10" alt="Icon" /> -->
                <!-- <IconDemo class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/> -->
                <Gamepad2 class="side-icons" />
              </span>
              <span class="flex-1 ml-3" :class="isSidebarOpen ? '' : 'hidden'"
                >Demo</span
              >
            </router-link>
          </li>
          <!-- Colors -->
          <li
            class="sidebar-li-style group flex items-center cursor-pointer select-none p-1 rounded-lg mt-2"
          >
            <router-link to="/colors" class="flex items-center w-full">
              <span class="block float-left">
                <!-- <img :src="testingFlasksIcon" class="w-10 h-10" alt="Icon" /> -->
                <!-- <IconDemo class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/> -->
                <Palette class="side-icons" />
              </span>
              <span class="flex-1 ml-3" :class="isSidebarOpen ? '' : 'hidden'"
                >Colors</span
              >
            </router-link>
          </li>
          <!-- PRofile -->
          <li
            class="sidebar-li-style group flex items-center cursor-pointer select-none p-1 rounded-lg mt-2"
          >
            <router-link to="/profile" class="flex items-center w-full">
              <span class="block float-left">
                <!-- <img :src="testingFlasksIcon" class="w-10 h-10" alt="Icon" /> -->
                <!-- <IconDemo class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/> -->
                <ContactRound class="side-icons" />
              </span>
              <span class="flex-1 ml-3" :class="isSidebarOpen ? '' : 'hidden'"
                >Profile</span
              >
            </router-link>
          </li>
          <!-- PRofile -->
          <li
            class="sidebar-li-style group flex items-center cursor-pointer select-none p-1 rounded-lg mt-2"
          >
            <router-link to="/dashboard" class="flex items-center w-full">
              <span class="block float-left">
                <!-- <img :src="testingFlasksIcon" class="w-10 h-10" alt="Icon" /> -->
                <!-- <IconDemo class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/> -->
                <LayoutDashboard class="side-icons" />
              </span>
              <span class="flex-1 ml-3" :class="isSidebarOpen ? '' : 'hidden'"
                >Dashboard</span
              >
            </router-link>
          </li>
          <!-- Dividends -->
          <li
            class="sidebar-li-style group flex items-center cursor-pointer select-none p-1 rounded-lg mt-2"
          >
            <router-link to="/dividends" class="flex items-center w-full">
              <span class="block float-left">
                <!-- <img :src="testingFlasksIcon" class="w-10 h-10" alt="Icon" /> -->
                <!-- <IconDemo class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/> -->
                <HandCoins class="side-icons" />
              </span>
              <span class="flex-1 ml-3" :class="isSidebarOpen ? '' : 'hidden'"
                >Dividends</span
              >
            </router-link>
          </li>
          <!-- Calendar -->
          <li
            class="sidebar-li-style group flex items-center cursor-pointer select-none p-1 rounded-lg mt-2"
          >
            <router-link to="/calendar" class="flex items-center w-full">
              <span class="block float-left">
                <!-- <img :src="testingFlasksIcon" class="w-10 h-10" alt="Icon" /> -->
                <!-- <IconDemo class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/> -->
                <CalendarDays class="side-icons" />
              </span>
              <span class="flex-1 ml-3" :class="isSidebarOpen ? '' : 'hidden'"
                >Calendar</span
              >
            </router-link>
          </li>
          <!-- Screener -->
          <li
            class="sidebar-li-style group flex items-center cursor-pointer select-none p-1 rounded-lg mt-2"
          >
            <router-link to="/screener" class="flex items-center w-full">
              <span class="block float-left">
                <!-- <img :src="testingFlasksIcon" class="w-10 h-10" alt="Icon" /> -->
                <!-- <IconDemo class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/> -->
                <Binoculars class="side-icons" />
              </span>
              <span class="flex-1 ml-3" :class="isSidebarOpen ? '' : 'hidden'"
                >Screener</span
              >
            </router-link>
          </li>
        </ul>
      </div>
    </div>
  </aside>
</template>

<script setup lang="ts">
import { useSidebarStore } from "../stores/sideBarStore";
import { computed } from "vue";
import {
  Gamepad2,
  Palette,
  ContactRound,
  HandCoins,
  CalendarDays,
  Binoculars,
  Notebook,
  EllipsisVertical,
  LayoutDashboard,
} from "lucide-vue-next";
import notebookIcon from '../assets/img/notebook-svgrepo-com.svg'

// Access the store
const sidebarStore = useSidebarStore();

// Computed properties to use store values
const isSidebarOpen = computed(() => sidebarStore.isSidebarOpen);
const toggleSidebar = () => {
  sidebarStore.toggleSidebar();
};
</script>

<style scoped>
.sidebar-style {
  @apply  backdrop-blur-sm;
}
.sidebar-li-style {
  @apply text-2xl font-semibold text-gray-800 hover:bg-green-200 dark:text-blue-300 hover:dark:text-gray-300 dark:hover:bg-green-500;
}
/* Icons */
.side-icons {
  /* Change this! */
  @apply text-blue-600 dark:text-lime-400 w-14 h-14 group-hover:stroke-cyan-300 stroke-lime-400;
  /* color: #ffadff;
  width: 24px;
  height: 24px;*/
  stroke-width: 1.5px;
}
.notebook-icon {
  /* Change this! */
  @apply size-14 group-hover:stroke-cyan-300 dark:stroke-gray-200;
  /* color: #ffadff;
  width: 24px;
  height: 24px;*/
  stroke-width: 1.5px;
}
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
