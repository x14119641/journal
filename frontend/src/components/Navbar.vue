<template>
  <nav class="bg-gray-800 text-lime-400 p-2">
    <div class="flex items-center justify-between mx-auto">
      <!-- Icon and Text at the beginning -->
      <span class="flex items-center space-x-2 mx-3">
        <svg
          version="1.1"
          id="Layer_1"
          xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          viewBox="0 0 512 512"
          xml:space="preserve"
          class="w-10 h-10 rotate-[290deg]"
        >
          <path
            style="fill: #f9d026"
            d="M144.345,349.7l67.39,20.636L64.631,196.91l96.855,26.033L0,0l222.943,161.485l-26.034-96.853
	l173.427,147.103l-20.635-67.39c0,0,263.14,180.817,119.3,324.657C325.163,612.84,144.345,349.7,144.345,349.7z"
          />
          <path
            style="fill: #e7c224"
            d="M222.943,161.485l-26.034-96.853l173.427,147.103l-20.635-67.39c0,0,263.14,180.817,119.3,324.657
	L0,0L222.943,161.485z"
          />
          <path
            style="fill: #444242"
            d="M455.206,449.001c6.148-13.466,3.152-33.048-8.903-58.205c-8.332-17.388-18.028-31.314-18.436-31.9
	l-48.472-48.471l-48.472-48.472c-0.584-0.408-14.511-10.104-31.899-18.438c-25.157-12.055-44.74-15.052-58.205-8.903
	c-5.127,2.341-11.665,7.497-13.698,18.769c-3.626,20.097,9.855,49.041,18.214,64.505c13.906,25.727,33.132,51.462,54.134,72.465
	c21.002,21.002,46.738,40.228,72.465,54.134c15.465,8.359,44.408,21.84,64.505,18.214
	C447.71,460.664,452.865,454.127,455.206,449.001z"
          />
          <path
            style="fill: #3a3839"
            d="M455.206,449.001c6.148-13.466,3.152-33.048-8.903-58.205c-8.332-17.388-18.028-31.314-18.436-31.899
	l-48.472-48.471l-79.927,79.927c21.002,21.002,46.738,40.228,72.465,54.134c15.465,8.359,44.408,21.84,64.505,18.214
	C447.71,460.664,452.865,454.127,455.206,449.001z"
          />
          <circle style="fill: #f9d026" cx="287.277" cy="295.279" r="9.724" />
          <circle style="fill: #d3b121" cx="394.541" cy="402.543" r="9.724" />
          <path
            style="fill: #bce8f7"
            d="M435.546,364.074c6.86-15.203,8.968-31.955,6.097-48.446c-2.938-16.882-10.916-32.228-23.07-44.381
	l0,0c-12.154-12.154-27.501-20.132-44.383-23.07c-16.491-2.871-33.244-0.762-48.446,6.097l-3.957,1.785l-1.45,4.09
	c-0.56,1.579-3.201,10.159-0.178,23.957c3.812,17.402,14.759,35.24,32.536,53.016l0,0c17.777,17.778,35.615,28.724,53.018,32.536
	c13.797,3.023,22.378,0.381,23.957-0.178l4.092-1.45L435.546,364.074z"
          />
          <path
            style="fill: #8ec1d6"
            d="M435.546,364.074c6.86-15.203,8.968-31.955,6.097-48.446c-2.938-16.882-10.916-32.228-23.07-44.381
	l0,0l-65.877,65.878l0,0c17.778,17.777,35.615,28.724,53.018,32.536c13.797,3.023,22.378,0.381,23.957-0.178l4.092-1.45
	L435.546,364.074z"
          />
          <path
            style="fill: #f9d026"
            d="M336.78,353.04L336.78,353.04c-3.798-3.798-9.954-3.798-13.752,0c-3.798,3.798-3.798,9.954,0,13.752
	l0,0c3.798,3.798,9.954,3.798,13.752,0C340.577,362.994,340.577,356.836,336.78,353.04z"
          />
          <path
            style="fill: #d3b121"
            d="M336.78,366.79c3.798-3.798,3.798-9.954,0-13.752l-13.752,13.752
	C326.825,370.588,332.983,370.588,336.78,366.79z"
          />
        </svg>
        <span class="font-bazooka text-2xl font-semibold whitespace-nowrap">
          To The Moon !!
        </span>
      </span>
      
      <!-- Text at the end -->
      <span class="flex items-center space-x-2">
        <span v-if="authStore.username" class="font-bazooka inline mr-4 self-center font-semibold whitespace-nowrap">
          Hello, {{ authStore.username }}
        </span>
        <button
          class="bg-transparent font-semibold hover:text-white py-2 px-4 border  hover:border-transparent rounded-full"
          :class="authStore.username ? ' hover:bg-fuchsia-500 text-fuchsia-300 border-fuchsia-300' : ' hover:bg-lime-400 text-lime-300 border-lime-300'"
          >
        <router-link v-if="authStore.username" @click.native="authStore.logout" to="/logout" class="">Logout</router-link>
        <router-link v-else @click.native="authStore.login" to="/login" class="">Login</router-link>
        </button>
      </span>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { useAuthStore } from "../stores/authStore";
const authStore = useAuthStore();
</script>
