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
        <svg
          version="1.1"
          id="Capa_1"
          xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          viewBox="0 0 15.741 15.741"
          xml:space="preserve"
          class="w-10 h-10"
        >
          <g>
            <g>
              <path
                style="fill: #44ff57"
                d="M8.472,0l-1.28,0.003c-2.02,0.256-3.679,1.104-4.671,2.386C1.685,3.47,1.36,4.78,1.553,6.283
                  c0.37,2.87,2.773,6.848,4.674,8.486c0.475,0.41,1.081,0.794,1.353,0.899c0.129,0.044,0.224,0.073,0.333,0.073
                  c0.11,0,0.217-0.031,0.319-0.091c1.234-0.603,2.438-1.88,3.788-4.02c0.936-1.485,2.032-3.454,2.2-5.495
                  C14.492,2.843,12.295,0.492,8.472,0z M8.435,0.69c3.431,0.447,5.337,2.462,5.097,5.391c-0.156,1.913-1.271,3.875-2.097,5.182
                  c-1.278,2.027-2.395,3.226-3.521,3.777c-0.005,0.002-0.009,0.004-0.012,0.005c-0.029-0.006-0.068-0.021-0.087-0.027
                  c-0.149-0.057-0.706-0.401-1.135-0.771c-1.771-1.525-4.095-5.375-4.44-8.052C2.07,4.879,2.348,3.741,3.068,2.812
                  c0.878-1.135,2.363-1.889,4.168-2.12L8.435,0.69z"
              />
              <path
                :fill="isSidebarOpen ? '#FA2488' : '#44FF57'"
                d="M3.504,6.83C3.421,6.857,3.37,6.913,3.373,7.024c0.308,1.938,1.616,3.536,3.842,3.126
                  C7.002,8.019,5.745,6.933,3.504,6.83z"
              />
              <path
                :fill="isSidebarOpen ? '#44FF57' : '#FA2488'"
                d="M8.778,10.215c2.196-0.125,3.61-1.379,3.776-3.319C10.321,6.727,8.55,7.923,8.778,10.215z"
              />
            </g>
          </g>
        </svg>
      </div>
      <!-- Items in menu -->
      <div>
        <ul class="my-10 pt-2 space-y-4">
          <li
            class="text-sm flex items-center cursor-pointer p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/demo" class="flex items-center w-full">
              <span class="text-2xl block float-left ">
                <img :src="testingFlasksIcon" class="w-10 h-10" alt="Icon" />
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Demo</span
              >
            </router-link>
          </li>

          <li
            class="text-sm flex items-center cursor-pointer p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/hello" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <img :src="bubbleMessageIcon" class="w-10 h-10" alt="Icon" />
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Hello</span
              >
            </router-link>
          </li>

          <li
            class="text-sm flex items-center cursor-pointer p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/table" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <img :src="alienHeadIcon" class="w-10 h-10" alt="Icon" />
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Table</span
              >
            </router-link>
          </li>

          <li
            class="text-sm flex items-center cursor-pointer p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/profile" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <img :src="accountAvatarIcon" class="w-10 h-10" alt="Icon" />
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Profile</span
              >
            </router-link>
          </li>

          <li
            class="text-sm flex items-center cursor-pointer p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/dividends" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <img :src="moneyIcon" class="w-10 h-10" alt="Icon" />
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Dividends</span
              >
            </router-link>
          </li>

          <li
            class="text-sm flex items-center cursor-pointer p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/calendar" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <img :src="calendarIcon" class="w-10 h-10" alt="Icon" />
              </span>
              <span
                class="text-base font-medium flex-1 ml-3"
                :class="isSidebarOpen ? '' : 'hidden'"
                >Calendar</span
              >
            </router-link>
          </li>
          <li
            class="text-sm flex items-center cursor-pointer p-1 text-blue-300 hover:bg-green-500 rounded mt-2"
          >
            <router-link to="/screener" class="flex items-center w-full">
              <span class="text-2xl block float-left">
                <img :src="binocularsIcon" class="w-10 h-10" alt="Icon" />
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
import binocularsIcon from "@/assets/img/binoculars-find-svgrepo-com.svg";


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
