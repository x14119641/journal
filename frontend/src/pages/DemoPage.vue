<template>
  <div class="bg-gray-800 rounded-lg shadow-lg">
    <PieChartComponent :labels="chartLabels" :values="chartValues" :colors="chartColors"/>
  </div>
  <p class="text-white">{{ result }}</p>
</template>

<script setup lang="ts">

import { onMounted,computed, ref } from 'vue';
import PieChartComponent from '../components/PieChartComponent.vue';
import { usePortfolioStore } from '../stores/portfolioStore';

const portfolioStore = usePortfolioStore();

onMounted(portfolioStore.getPortfolio)
const result = computed(() => portfolioStore.portfolio)

const chartLabels = computed(() => result.value.map(item => item.ticker));
const chartValues = computed(() => result.value.map(item => item.totalValue));
// const chartLabels = ref<string[]>(["Stocks", "Bonds", "Real Estate", "Crypto", "Cash"]);
// const chartValues = ref<number[]>([5000, 3000, 2000, 1500, 1000]);
const chartColors = ref<string[]>(['#f87171', '#60a5fa', '#fbbf24', '#34d399', '#a78bfa']);
</script>