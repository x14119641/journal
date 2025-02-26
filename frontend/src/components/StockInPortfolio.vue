<template>
  <div class="p-6 text-center">
      <h3 class="summary-title-2">Portfolio</h3>

      <div class="flex justify-between">
          <span class="summary-label">Capital</span>
          <span class="summary-value">{{ totalValue }}</span>
      </div>
      <div class="flex justify-between">
          <span class="summary-label">Quantity</span>
          <span class="summary-value">{{ stockData?.totalQuantity  }}</span>
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
          <span class="summary-label">BreakEven</span>
          <span class="summary-value">{{ stockData?.breakeven  }}</span>
      </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, watch } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import { type PortfolioItemAgreggate } from "../models/models";
import { useRoute } from "vue-router";

console.log("Portfolio Component Mounted");

const props = defineProps<{ ticker?: string }>();
const route = useRoute();

const ticker = computed(() => props.ticker || (route.params.ticker as string));

const portfolioStore = usePortfolioStore();
const stockData = ref<PortfolioItemAgreggate | null>(null);
const totalValue = computed(() => portfolioStore.accountValue);

const fetchStockAggregate = async () => {

  if (!ticker.value) {
      console.error("No ticker provided!");
      return;
  }

  try {
      await portfolioStore.getFundsTotals();
      const response = await portfolioStore.getPortfolioTickerAggregate(ticker.value);
      stockData.value = response;
  } catch (error) {

  }
};

onMounted(fetchStockAggregate);

watch(ticker, () => {
  fetchStockAggregate();
});
</script>
