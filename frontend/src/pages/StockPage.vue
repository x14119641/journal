<template>
  <div class="flex flex-col items-center space-y-6">
    <!-- Top row -->
    <div class="grid grid-cols-2 sm:grid-cols-1 lg:grid-cols-3 gap-6 w-full">
      <div class="slate-container col-span-2 row-span-2 ">
        <StockSummary />
      </div>
      <div class="slate-container ">
        <FundsHeader />
      </div>
    </div>
    <div class="grid grid-cols-2 sm:grid-cols-1 lg:grid-cols-3 gap-6 w-full">
      <div class="slate-container col-span-2 row-span-2 w-full">
        <DataTable :headers="tableHeaders" :rows="stockDividends" />
         <!-- <p>{{ stockDividends }}</p> -->
      </div>
      <div class="slate-container">
        <RiskCalculator />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import StockSummary from "../components/StockSummary.vue";
import DataTable from "../components/DataTable.vue";
import RiskCalculator from '../components/RiskCalculator.vue';
import { ref, onMounted, computed } from "vue";
import FundsHeader from "../components/FundsHeader.vue";
import { type StockDividend } from "../models/models";
import api from "../services/api";
import { useRoute } from "vue-router";

const route = useRoute();
const ticker = ref<String>(route.params.ticker as string);

const stockDividends = ref<StockDividend[]>([]);
// const tableHeaders = ["Ex. DeclarationDate", "PaymentDate", "Amount", "DeclarationDate","RecordDate", "PaymentDate", "Currency"]
const tableHeaders = computed(() => {
  if (stockDividends.value.length > 0) {
    return Object.keys(stockDividends.value[0]);
  }
  return [];
});
const error_message = ref<String>("");

onMounted(async () => {
  try {
    const response = await api.get(`/stocks/dividends/${ticker.value}`);

    stockDividends.value = response.data;
  } catch (error) {
    console.error("Errro to getch data: ", error);
    error_message.value = "Failed to load message";
  }
});
</script>

<style scoped>
/* You can add additional custom styles here */
</style>
