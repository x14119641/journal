<template>
  <div class="flex flex-col items-center space-y-6">
    
    <!-- Top row -->
    <div class="grid grid-cols-2 sm:grid-cols-1 lg:grid-cols-3 gap-6 w-full">
      <div class="container-component col-span-2 row-span-2 ">
        <StockSummary :ticker="ticker" />
      </div>
      <div class="container-component ">
        <!-- <FundsHeader /> -->
        <StockInPortfolio :ticker="ticker"/>
      </div>
      <div v-if="showRiskHeader"  class="container-component ">
        <RiskDataHeader />
      </div>
    </div>
    <div class="grid grid-cols-2 sm:grid-cols-1 lg:grid-cols-3 gap-6 w-full">
      <div class="container-component col-span-2 row-span-2 w-full">
        <DataTable :headers="tableHeaders" :rows="stockDividends" :formattedHeaders="formattedHeaders"/>
         <!-- <p>{{ stockDividends }}</p> -->
      </div>
      <div class="container-component">
        <RiskCalculator />
      </div>
    </div>
    <p>{{ showRiskHeader }}</p>
  </div>
</template>
<script setup lang="ts">
import StockSummary from "../components/StockSummary.vue";
import DataTable from "../components/DataTable.vue";
import RiskCalculator from '../components/RiskCalculator.vue';
import StockInPortfolio from "../components/StockInPortfolio.vue";
import { ref, computed, watch } from "vue";
import RiskDataHeader from "../components/RiskDataHeader.vue";
import { type StockDividend } from "../models/models";
import api from "../services/api";
import { useRoute } from "vue-router";
import { useRiskHeaderStore } from "../stores/riskHeaderStore";



const riskHeaderStore = useRiskHeaderStore();
const showRiskHeader = computed(() => riskHeaderStore.showRiskHeader)
// Route Handling
const route = useRoute();
const ticker = computed(() => route.params.ticker as string); 

// Data Variables
const stockDividends = ref<StockDividend[]>([]);
const error_message = ref<String>("");

// Table Headers
const tableHeaders = computed(() => {
  return stockDividends.value.length > 0 ? Object.keys(stockDividends.value[0]) : [];
});
const formattedHeaders = ["ExDate", "PaymentType", "Amount","DeclarationDate", "RecordDate", "PaymentDate", "Currency"]

// Fetch Stock Data
const fetchStockDividends = async () => {
  if (!ticker.value) return; // Prevent API call if ticker is empty
  try {
    const response = await api.get(`/stocks/dividends/${ticker.value}`);
    stockDividends.value = response.data;
    error_message.value = "";
  } catch (error) {
    console.error("Error fetching data:", error);
    error_message.value = "Failed to load data";
  }
};

// Fetch data when the component first loads
fetchStockDividends();

// Watch `ticker` and fetch new data whenever it changes
watch(ticker, () => {
  fetchStockDividends();
  riskHeaderStore.setShowRiskHeader(false);
});
</script>