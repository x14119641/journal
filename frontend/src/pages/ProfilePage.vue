<template>
  <div class="flex flex-col items-center space-y-6">
    <!-- Top Row: 3 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full">
      <div class="bg-gray-800 rounded-lg shadow-lg">
        <!-- Box 1  -->
        <ProfileInfo />
      </div>

      <div class="bg-gray-800 rounded-lg shadow-lg">
        <!-- Box 2  -->
        <FundsHeader />
      </div>
      <div class="bg-gray-800 rounded-lg shadow-lg">
        <!-- Box 1  -->
        <ProfileInfo />
      </div>
    </div>

    <!-- Bottom Row: 2 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full">
      <div class="bg-gray-800 rounded-lg shadow-lg">
        <!-- Box 4 content goes here -->
        <AllocationDoughnout />
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
import { onMounted,computed, ref } from 'vue';
import AllocationDoughnout from "../components/AllocationDoughnout.vue";
import { usePortfolioStore } from '../stores/portfolioStore';

const tableHeaders = ['Name', 'Age', 'Email'];
const tableData = [
  { name: 'John Doe', age: 30, email: 'john@example.com' },
  { name: 'Jane Doe', age: 25, email: 'jane@example.com' },
  { name: 'Sam Smith', age: 35, email: 'sam@example.com' },
];

const portfolioStore = usePortfolioStore();

onMounted(()=>{portfolioStore.getPortfolio()})
const result = computed(() => portfolioStore.portfolio)

const chartLabels = computed(() => result.value.map(item => item.ticker));
const chartValues = computed(() => result.value.map(item => item.totalValue));
// const chartLabels = ref<string[]>(["Stocks", "Bonds", "Real Estate", "Crypto", "Cash"]);
// const chartValues = ref<number[]>([5000, 3000, 2000, 1500, 1000]);
const chartColors = ref<string[]>(['#001A6E', '#074799', '#009990', '#E1FFBB', '#536493']);
</script>
