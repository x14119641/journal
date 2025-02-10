<template>
  <div class="flex flex-col items-center space-y-6">
    <!-- Top Row: 3 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full h-fit">
      <div class="bg-gray-800 rounded-lg shadow-lg row-span-2">
        <!-- Box 1  -->
        <ProfileInfo />
      </div>

      <div class="bg-gray-800 rounded-lg shadow-lg">
        <!-- Box 2  -->
        <FundsHeader />
      </div>
      <div class="bg-gray-800 rounded-lg shadow-lg row-span-2">
        <!-- Box 1  -->
        <ProfileInfo />
      </div>
    </div>

    <!-- Bottom Row: 2 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 w-full">
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
        <!-- Box 4 content goes here -->
      </div>
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg overflow-hidden">
        <!-- Box 5 content goes here -->
        <DataTable :headers="tableHeaders" :rows="tableData" />
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import ProfileInfo from "../components/ProfileInfo.vue"; // Import the Profile component
import FundsHeader from "../components/FundsHeader.vue";

import DataTable from "../components/DataTable.vue";

const tableHeaders = ['Name', 'Age', 'Email'];
const tableData = [
  { name: 'John Doe', age: 30, email: 'john@example.com' },
  { name: 'Jane Doe', age: 25, email: 'jane@example.com' },
  { name: 'Sam Smith', age: 35, email: 'sam@example.com' },
];
</script>
