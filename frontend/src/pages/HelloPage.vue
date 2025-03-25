<template>
  <div class="flex flex-col items-center space-y-6">
    <!-- Top Row: 3 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full">
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
        <!-- Box 1  -->
        <ProfileInfo />
      </div>

      <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
        <!-- Box 2  -->
        <FundsHeader />
      </div>
      <div class="flex flex-col gap-6 w-full">
        <!-- Box 3 (divided by two) -->
        <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
          <AddFunds />
        </div>
        <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
          <RemoveFunds />
        </div>
      </div>
    </div>

    <!-- Bottom Row: 2 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 w-full">
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
        <!-- Box 4 content goes here -->
      </div>
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
        <!-- Box 5 content goes here -->
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import ProfileInfo from "../components/ProfileInfo.vue"; // Import the Profile component
import FundsHeader from "../components/FundsHeader.vue";
import AddFunds from "../components/AddFunds.vue";
import RemoveFunds from "../components/RemoveFunds.vue";
</script>
