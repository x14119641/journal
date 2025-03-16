<template>
  <div class="flex flex-col items-center space-y-6">
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full">
      <!-- Left Column -->
      <div class="container-component">
        <FundsHeader />
      </div>

      <!-- Right Column (2 boxes inside) -->
      <div class="col-span-2 flex flex-col gap-6 w-full">
        <div class="container-component">
          <BuyStock />
        </div>
        <div class="container-component">
          <SellStock />
        </div>
      </div>
    </div>
    <!-- Bottom Row: 2 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 w-full">
      <div v-if="hasData" class="container-component">
        <!-- Box 4 content goes here -->
        <PieChartComponent
          title="Portfolio Distribution Qnty"
          :key="chartKey"
          :labels="chartLabels"
          :values="chartValues"
        />
      </div>
      <div v-if="hasData" class="container-component">
        <!-- Box 5 content goes here -->
        <DataTable :headers="tableHeaders" :rows="tableData" :formattedHeaders="formattedHeaders" :pagingNumber="pagingNumber" />
      </div>
    </div>
    <!-- <p v-if="chartValues" class="text-white">{{ chartValues }}</p> -->
    <!-- <p v-if="tableData" class="text-white">{{ tableData }}</p> -->
     <p>{{chartValues}}</p>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from "vue";

import DataTable from "../components/DataTable.vue";
import FundsHeader from "../components/FundsHeader.vue";

import { usePortfolioStore } from "../stores/portfolioStore";
import PieChartComponent from '../components/PieChartComponent.vue';
import SellStock from "../components/SellStock.vue";
import BuyStock from "../components/BuyStock.vue";
import { useTransactionsStore } from "../stores/transactionsStore";


const tableHeaders = ["transactionId", "ticker", "price","quantity",  "transactionType", "realizedProfitLoss",  "created_at"];
const formattedHeaders = ["id", "ticker","price","quantity",  "type", "profitLoss",  "created"];
const pagingNumber = ref(5)
const portfolioStore = usePortfolioStore();
const transactionsStore = useTransactionsStore();

onMounted(async () => {
  // await portfolioStore.getFunds();
  await portfolioStore.getPortfolioSummary();
  
  await transactionsStore.getStocksTransactionsHistory()
});

const tableData = computed(() => transactionsStore.stocks_transactions_history);
const result = computed(() => portfolioStore.portfolio_summary)

const chartLabels = computed(() => {
  const labels = result.value.map(item => item.ticker);
  return [...labels, "Cash"]; // ✅ Always matches chartValues
});

const chartValues = computed(() => {
  const values = result.value.map(item => item.remainingQuantity);
  const cashValue = portfolioStore.balance ?? 0; // ✅ Prevent undefined

  return [...values, cashValue]; // ✅ Always matches chartLabels
});
const hasData = computed(() => chartValues.value.length > 0);

// const chartLabels = ref<string[]>(["Stocks", "Bonds", "Real Estate", "Crypto", "Cash"]);
// const chartValues = ref<number[]>([5000, 3000, 2000, 1500, 1000]);
// Create a key from the labels and values. Whenever the data changes,
// the key will change, forcing Vue to re-create the PieChartComponent.
const chartKey = computed(() => {
  return chartLabels.value.join('-') + '|' + chartValues.value.join('-');
});
</script>

<style scoped></style>
