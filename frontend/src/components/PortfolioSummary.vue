<template>
  <div class="p-6 text-center">
    <h3 class="title-component">Summary</h3>
    <div v-if="stocks">
      <div class="mt-2 space-y-2">
        <div class="flex justify-between">
          <span class="text-label">Stocks</span>
          <span class="">
            <template v-for="(stock, index) in stocks" :key="index">
              <router-link :to="`/stocks/${stock}`" 
              class="ticker-link">{{
                stock 
              }}</router-link
              ><span class="select-none ticker-commas" v-if="index < stocks.length - 1">, </span>
            </template>
          </span>
        </div>
        <div class="flex justify-between">
          <span class="text-label">Total</span>
          <span class="summary-value">{{ numberStocks }}</span>
        </div>
        <div class="flex justify-between">
          <span class="text-label">Market Value</span>
          <span class="summary-value money-positive-style">
            <!-- <span class="dolar-style">$</span>  -->
            {{ stocksMarketValue }}</span
          >
        </div>
        <div class="flex justify-between">
          <span class="text-label">Unrealized Gains</span>
          <span
            :class="
              unRealizedGains >= 0
                ? 'summary-value money-positive-style'
                : 'summary-value money-negative-style'
            "
            >{{ unRealizedGains.toFixed(2) }}</span
          >
        </div>
      </div>
    </div>
    <div v-else>
      <LoadingComponent />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import LoadingComponent from "./LoadingComponent.vue";

const portfolioStore = usePortfolioStore();

const stocks = computed(() => portfolioStore.getTickersPortfolio);
const numberStocks = computed(() => portfolioStore.portfolio_summary.length);
const stocksMarketValue = computed(() => portfolioStore.sumTotalValue);
const unRealizedGains = computed(() => portfolioStore.unrealizedMoney);

onMounted(async () => {
  try {
    await portfolioStore.getPortfolio();
  } catch (error) {
    console.error("Error fetching funds:", error);
  }
});
</script>
<style scoped>
.ticker-link{
  @apply font-medium text-blue-600 dark:text-blue-500 hover:text-lime-500 dark:hover:text-lime-400;
}
</style>
