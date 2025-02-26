<template>
  <aside
    class="bg-gray-800 text-white p-4"
    :class="isSidebarOpen ? 'w-72' : 'w-20'"
  >
    <div class="relative">
      <!-- App Icon -->
      <div class="inline-flex">
        <svg
          version="1.1"
          id="Layer_1"
          xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          class="w-10 h-10 cursor-pointer mr-2 duration-500"
          :class="isSidebarOpen ? '' : 'animate-flip'"
          viewBox="0 0 512 512"
          xml:space="preserve"
        >
          <path
            style="fill: #6b6b6b"
            d="M44,0h375.952C446.488,0,468,21.512,468,48.048l0,0v415.904C468,490.488,446.488,512,419.952,512l0,0
              H44l0,0V0L44,0z"
          />
          <g style="opacity: 0.5">
            <rect
              x="44"
              y="163.056"
              style="fill: #ffffff"
              width="424"
              height="185.92"
            />
          </g>
          <rect
            x="357.952"
            y="0.048"
            style="fill: #e21b1b"
            width="38"
            height="511.808"
          />
        </svg>

        <!-- App Text -->
        <h1
          class="text-white origin-left font-mono font-medium text-3xl duration-200"
          :class="isSidebarOpen ? '' : 'scale-0'"
        >
          MyJournal
        </h1>
      </div>
      <!-- Alien -->
      <div
        @click="toggleSidebar"
        class="absolute top-1 -right-9 cursor-pointer"
      >
      <IconAlien class="w-10 h-10" alt="Icon" 
      base-color="#2ed422"
      :fill-color="isSidebarOpen ? '#2ed422' : '#e635e0'"
      :fill-color2="isSidebarOpen ? '#e635e0' : '#2ed422'"/>

      </div>
      <!-- Items in menu -->
      <div>
        <ul class="my-10 pt-2 space-y-4">
          <li
            class="text-sm flex items-center cursor-pointer select-none p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/demo" class="flex items-center w-full">
              <span class="text-2xl block float-left ">
                <!-- <img :src="testingFlasksIcon" class="w-10 h-10" alt="Icon" /> -->
                <IconDemo class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/>
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Demo</span
              >
            </router-link>
          </li>


          <li
            class="text-sm flex items-center cursor-pointer select-none p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/colors" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <IconColors class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/>
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Colors</span
              >
            </router-link>
          </li>

          <li
            class="text-sm flex items-center cursor-pointer select-none p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/profile" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <!-- <img :src="accountAvatarIcon" class="w-10 h-10" alt="Icon" /> -->
                <IconProfile class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/>
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Profile</span
              >
            </router-link>
          </li>

          <li
            class="text-sm flex items-center cursor-pointer select-none p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/dividends" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <!-- <img :src="moneyIcon" class="w-10 h-10" alt="Icon" /> -->
                <IconDollar class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/>
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Dividends</span
              >
            </router-link>
          </li>

          <li
            class="text-sm flex items-center cursor-pointer select-none p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/calendar" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <!-- <img :src="calendarIcon" class="w-10 h-10" alt="Icon" /> -->
                <IconCalendar class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/>
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Calendar</span
              >
            </router-link>
          </li>
          <li
            class="text-sm flex items-center cursor-pointer select-none p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/screener" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <!-- <img :src="binocularsIcon" class="w-10 h-10" alt="Icon" /> -->
                <IconSearch class="w-10 h-10" alt="Icon" strokeColor="#2ed422"/>
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
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
import testingFlasksIcon from "@/assets/img/testing-flasks-svgrepo-com.svg";
import bubbleMessageIcon from "@/assets/img/bubble-message-hi-svgrepo-com.svg";
import alienHeadIcon from "@/assets/img/alien-head-svgrepo-com.svg";
import accountAvatarIcon from "@/assets/img/account-avatar-profile-user-3-svgrepo-com.svg";
import moneyIcon from "@/assets/img/money-svgrepo-com.svg";
import calendarIcon from "@/assets/img/calendar-svgrepo-com.svg";
import IconSearch from "./IconScreener.vue";
import IconDollar from "./IconDividends.vue";
import IconProfile from "./IconProfile.vue";
import IconCalendar from "./IconCalendar.vue";
import IconDemo from "./IconDemo.vue";
import IconAlien from "./IconAlien.vue";
import IconColors from "./IconColors.vue";


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
