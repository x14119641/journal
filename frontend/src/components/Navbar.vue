<template>
  <nav class="bg-gray-800 p-2 w-full">
    
    <div class="flex items-center justify-between w-full">
      <!-- Icon and Text at the beginning -->
       <div class="flex items-center">
        <span class="flex items-center space-x-2 mx-3">
        <img :src="ufoIcon" class="w-10 h-10 rotate-[290deg]" alt="Icon" />
        <span class="navbar-title">
          To The Moon !!
        </span>
      </span>
       </div>
      

      <!-- Search Box -->
      <span class="flex-1 items-center  space-x-2 max-w-lg">
        <SearchBar />
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
import SearchBar from "./SearchBar.vue";
</script>
