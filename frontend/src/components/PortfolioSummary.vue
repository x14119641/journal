<template>
  <div class="p-6 text-center">
    <h3 class="text-xl text-gray-200">Summary</h3>
    <div v-if="stocks">
      <div class="flex justify-between">
      <span class="font-medium text-gray-400">Stocks</span>
      <span class="text-green-400">
        <template v-for="(stock, index) in stocks" :key="index">
          <!-- You can wrap item in a router-link if needed -->
          <router-link :to="`/stocks/${stock}`"
          class="font-medium text-blue-500"
          >{{ stock }}</router-link
          ><span v-if="index < stocks.length - 1">, </span>
        </template>
      </span>
    </div>
    <div class="flex justify-between mt-2">
      <span class="font-medium text-gray-400">Total</span>
      <span class="text-green-400">{{ numberStocks }}</span>
    </div>
    <div class="flex justify-between mt-2">
      <span class="font-medium text-gray-400">Market Value</span>
      <span class="text-green-200">$ {{ stocksMarketValue }}</span>
    </div>
    <div class="flex justify-between mt-2">
        <span class="font-medium text-gray-400">Unrealized Gains</span>
        <span :class="unRealizedGains >= 0 ? 'text-green-400' : 'text-red-400'">{{ unRealizedGains }}</span>
      </div>
    </div>
    <div v-else>
      <p  class="text-white">Loadings data...</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue";
// import { useTransactionsStore } from '../stores/transactionsStore';
import { usePortfolioStore } from "../stores/portfolioStore";

const portfolioStore = usePortfolioStore();
// const transactionsStore = useTransactionsStore();

const stocks = computed(() => portfolioStore.getTickersPortfolio);
const numberStocks = computed(() => portfolioStore.portfolio_summary.length);
const stocksMarketValue = computed(() => portfolioStore.sumTotalValue);
const unRealizedGains = computed(() => portfolioStore.getUnrealizedGains);

onMounted(async () => {
  try {
    await portfolioStore.getPortSummary();
  } catch (error) {
    console.error("Error fetching funds:", error);
  }
});
</script>
