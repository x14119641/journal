<template>
  <nav class="bg-gray-800 p-2 w-full">
    <div class="flex items-center justify-between mx-auto">
      <!-- Icon and Text at the beginning -->
      <span class="flex items-center space-x-2 mx-3">
        <img :src="ufoIcon" class="w-10 h-10 rotate-[290deg]" alt="Icon" />
        <span class="navbar-title">
          To The Moon !!
        </span>
      </span>

      <!-- Text at the end -->
      <span class="flex items-center space-x-2">
        <DropdownMenu />
      </span>
    </div>
  </nav>
</template>

<script setup lang="ts">
import ufoIcon from "@/assets/img/ufo-alien-svgrepo-com.svg";
import DropdownMenu from "./DropdownMenu.vue";
</script>
