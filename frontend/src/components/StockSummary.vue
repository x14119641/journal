<template>
  <div class="p-6 text-center">
    <h3 class="title-component">{{ ticker?.toUpperCase() }}</h3>

    <!-- Info Labels -->
    <div class="grid grid-cols-1 sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-x-12">
      <div v-if="stockData" class="mt-2" v-for="(value, key) in stockData" :key="key">
        <div class="flex justify-between">
          <span class="text-label">{{ key }}</span>
          <span class="text-value">{{ value }}</span>
        </div>
      </div>
      <div v-else class="">
        Loading stock data...
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import api from "../services/api";
import { ref, onMounted, computed, watch } from "vue";
import { useRoute } from "vue-router";
import { type StockMetadata } from "../models/models";

const props = defineProps<{
  ticker?: string; 
}>();

const route = useRoute();
const stockData = ref<StockMetadata | null>(null);

const customHeaders= ["Name", "Exchange", "Industry", "Avg Volume", "MarketCap", "Forward PE 1y", "Annualized Dividend",
  "OutstandingShares %", "isNasdaq100", "Sector", "OneYearTarger", "52 week High/Low", "PE", "Yield", "Buy/Sold holdersRatio"
]

const ticker = computed(() => props.ticker || (route.params.ticker as string));


const fetchStockData = async () => {
  if (!ticker.value) {
    console.error("No ticker provided!");
    return;
  }

  try {
    console.log("Fetching data for:", ticker.value); // Debugging
    const response = await api.get(`/stocks/${ticker.value}`);

    stockData.value = response.data;
  } catch (error) {
    console.error("Error fetching stock data:", error);
  }
};


onMounted(fetchStockData);

watch(ticker, () => {
  fetchStockData();
});
</script>
