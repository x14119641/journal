<template>
  <div v-if="stockData" class="p-6 text-center">
      <h3 class="title-component">Portfolio</h3>

      <div class="flex justify-between">
          <span class="text-label">Capital</span>
          <span class="text-value">{{ stockData?.totalValue }}</span>
      </div>
      <div class="flex justify-between">
          <span class="text-label">Quantity</span>
          <span class="text-value">{{ stockData?.remainingQuantity  }}</span>
      </div>
      <div class="flex justify-between">
          <span class="text-label">Min Price</span>
          <span class="text-value">{{ stockData?.minPrice  }}</span>
      </div>
      <div class="flex justify-between">
          <span class="text-label">Max Price</span>
          <span class="text-value">{{ stockData?.maxPrice  }}</span>
      </div>
      <div class="flex justify-between">
          <span class="text-label">AvgPrice</span>
          <span class="text-value">{{ stockData?.avgBuyPrice  }}</span>
      </div>
      <div class="flex justify-between">
          <span class="text-label">BreakEven</span>
          <span class="text-value">{{ stockData?.breakeven  }}</span>
      </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import { useRoute } from "vue-router";

console.log("Portfolio Component Mounted");

const props = defineProps<{ ticker?: string }>();
const route = useRoute();

const ticker = computed(() => props.ticker || (route.params.ticker as string));

const portfolioStore = usePortfolioStore();
const stockData = computed(() => portfolioStore.getTickerInPortfolio(ticker.value))

onMounted(async () => {
  try {
    await portfolioStore.getPortfolioSummary();
  } catch (error) {
    console.error("Error Porfolio Summary:", error);
  }
});


</script>
