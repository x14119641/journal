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
        <!-- Box 3  -->
        <PortfolioSummary />
      </div>
    </div>

    <!-- Bottom Row: 2 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-6 w-full">
      <div class="bg-gray-800 rounded-lg shadow-lg">
        <!-- Box 4 content goes here -->
        <AllocationDoughnout />
      </div>
      <div class="bg-gray-800  rounded-lg shadow-lg ">
        <!-- Box 5 content goes here -->
        <PortfolioBarChart />
      </div>
    </div>
  </div>
</template> 
<script setup lang="ts">
import ProfileInfo from "../components/ProfileInfo.vue"; // Import the Profile component
import FundsHeader from "../components/FundsHeader.vue";

import { onMounted,computed, ref } from 'vue';
import AllocationDoughnout from "../components/AllocationDoughnout.vue";
import { usePortfolioStore } from '../stores/portfolioStore';
import PortfolioBarChart from '../components/PortfolioBarChart.vue';
import PortfolioSummary from '../components/PortfolioSummary.vue';


const portfolioStore = usePortfolioStore();

onMounted(()=>{portfolioStore.getPortfolio()})
const result = computed(() => portfolioStore.portfolio)

const chartLabels = computed(() => result.value.map(item => item.ticker));
const chartValues = computed(() => result.value.map(item => item.totalValue));
// const chartLabels = ref<string[]>(["Stocks", "Bonds", "Real Estate", "Crypto", "Cash"]);
// const chartValues = ref<number[]>([5000, 3000, 2000, 1500, 1000]);
const chartColors = ref<string[]>(['#001A6E', '#074799', '#009990', '#E1FFBB', '#536493']);
</script>
