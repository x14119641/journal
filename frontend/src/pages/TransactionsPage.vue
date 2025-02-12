<template>
  <div class="flex flex-col items-center space-y-6">
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full">
      <!-- Left Column -->
      <div class="bg-gray-800 rounded-lg shadow-lg row-span-2">
        <FundsHeader />
      </div>

      <!-- Right Column (2 boxes inside) -->
      <div class="col-span-2 flex flex-col gap-6 w-full">
        <div class="bg-gray-800 rounded-lg shadow-lg flex-grow">
          <AddTransaction />
        </div>
      </div>
    </div>
    <!-- Bottom Row: 2 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 w-full">
      <div class="bg-gray-800 rounded-lg shadow-lg">
        <!-- Box 4 content goes here -->
        <PieChartComponent
          title="Portfolio Distribution Qnty"
          :key="chartKey"
          :labels="chartLabels"
          :values="chartValues"
        />
      </div>
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg overflow-hidden">
        <!-- Box 5 content goes here -->
        <DataTable :headers="tableHeaders" :rows="tableData" />
      </div>
    </div>
    <p class="text-white">{{ chartValues }}</p>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue";
// import { type Fund } from '../models/models';
import DataTable from "../components/DataTable.vue";
import FundsHeader from "../components/FundsHeader.vue";
import AddTransaction from "../components/AddTransaction.vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import PieChartComponent from '../components/PieChartComponent.vue';

const tableHeaders = ["amount", "description", "created_at"];

const portfolioStore = usePortfolioStore();
onMounted(async () => {
  await portfolioStore.getFunds();
  await portfolioStore.getPortfolio();
});

const tableData = computed(() => portfolioStore.latest_funds_transactions);
const result = computed(() => portfolioStore.portfolio)

const chartLabels = computed(() => result.value.map(item => item.ticker));
const chartValues = computed(() => result.value.map(item => item.totalQuantity));
// const chartLabels = ref<string[]>(["Stocks", "Bonds", "Real Estate", "Crypto", "Cash"]);
// const chartValues = ref<number[]>([5000, 3000, 2000, 1500, 1000]);
// Create a key from the labels and values. Whenever the data changes,
// the key will change, forcing Vue to re-create the PieChartComponent.
const chartKey = computed(() => {
  return chartLabels.value.join('-') + '|' + chartValues.value.join('-');
});
</script>

<style scoped></style>
