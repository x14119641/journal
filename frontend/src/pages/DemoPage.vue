<template>
  <div class="bg-gray-800 rounded-lg shadow-lg">
    <PortfolioBarChart />
  </div>
  <!-- <p class="text-white">{{ chartData }}</p> -->
</template>

<script setup lang="ts">

import PortfolioBarChart from '../components/PortfolioBarChart.vue';
// const portfolioStore = usePortfolioStore();

// onMounted(async () => {
//   await portfolioStore.getPortfolioAllocation();
// });
// const chartData = computed(() => portfolioStore.allocation_portfolio)

// const chartData = computed(() => result.value.map(item => item.totalValue));
// const chartLabels = ref<string[]>(["Stocks", "Bonds", "Real Estate", "Crypto", "Cash"]);
// const chartValues = ref<number[]>([5000, 3000, 2000, 1500, 1000]);
// const chartColors = ref<string[]>(['#f87171', '#60a5fa', '#fbbf24', '#34d399', '#a78bfa']);

// // Create a key from the labels and values. Whenever the data changes,
// // the key will change, forcing Vue to re-create the PieChartComponent.
// const chartKey = computed(() => {
//   return chartLabels.value.join('-') + '|' + chartValues.value.join('-');
// });
</script>