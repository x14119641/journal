<template>
  <nav class="navbar-style p-2 w-full">
    <div class="flex items-center justify-between w-full">
      
      <!-- Left Side: Icon and Title -->
      <div class="flex items-center">
        <span class="flex items-center space-x-2 mx-3">
          <img :src="ufoIcon" class="w-10 h-10 rotate-[290deg]" alt="Icon" />
          <span class="navbar-title">To The Moon !!</span>
        </span>
      </div>

      <!-- Right Side: Search and Dropdown -->
      <div class="flex items-center space-x-4 w-full max-w-3xl">
        <!--  Make the search bar expand -->
        <div class="flex-1">
          <SearchBar />
        </div>
        <DropdownMenu />
      </div>

    </div>
  </nav>
</template>

<script setup lang="ts">
import ufoIcon from "@/assets/img/ufo-alien-svgrepo-com.svg";
import DropdownMenu from "./DropdownMenu.vue";
import SearchBar from "./SearchBar.vue";
</script>

<style scoped>
.navbar-style{
  @apply bg-container-1 dark:bg-container-2;
}
.navbar-title{
  @apply text-primary font-bazooka text-2xl font-semibold whitespace-nowrap;
}

</style>
