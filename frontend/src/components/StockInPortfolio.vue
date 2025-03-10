<template>
  <div v-if="stockData" class="p-6 text-center">
      <h3 class="summary-title-2">Portfolio</h3>

      <div class="flex justify-between">
          <span class="summary-label">Capital</span>
          <span class="summary-value">{{ stockData?.totalValue }}</span>
      </div>
      <div class="flex justify-between">
          <span class="summary-label">Quantity</span>
          <span class="summary-value">{{ stockData?.remainingQuantity  }}</span>
      </div>
      <div class="flex justify-between">
          <span class="summary-label">Min Price</span>
          <span class="summary-value">{{ stockData?.minPrice  }}</span>
      </div>
      <div class="flex justify-between">
          <span class="summary-label">Max Price</span>
          <span class="summary-value">{{ stockData?.maxPrice  }}</span>
      </div>
      <div class="flex justify-between">
          <span class="summary-label">AvgPrice</span>
          <span class="summary-value">{{ stockData?.avgBuyPrice  }}</span>
      </div>
      <div class="flex justify-between">
          <span class="summary-label">BreakEven</span>
          <span class="summary-value">{{ stockData?.breakeven  }}</span>
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
