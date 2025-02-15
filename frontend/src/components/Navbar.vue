<template>
  <nav class="bg-gray-800 text-lime-400 p-2 w-full ">
    <div class="flex items-center justify-between mx-auto">
      <!-- Icon and Text at the beginning -->
      <span class="flex items-center space-x-2 mx-3">
        <img :src="ufoIcon" class="w-10 h-10 rotate-[290deg]" alt="Icon" />
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
          :class="authStore.username ? ' hover:bg-customFuchsia-2 text-customFuchsia-2 border-customFuchsia-2' : ' hover:bg-lime-400 text-lime-300 border-lime-300'"
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
import ufoIcon from "@/assets/img/ufo-alien-svgrepo-com.svg";

const authStore = useAuthStore();
</script>
