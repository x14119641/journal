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
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg w-full overflow-hidden">
        <!-- Main content, table -->
        <DataTable title="Latest Transactions" :headers="tableHeaders" :rows="tableData" />
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { computed, onMounted } from 'vue';
  // import { type Fund } from '../models/models';
  import DataTable from '../components/DataTable.vue';
  import FundsHeader from '../components/FundsHeader.vue';
  import AddTransaction from '../components/AddTransaction.vue';
  import { usePortfolioStore } from '../stores/portfolioStore';
  
  const tableHeaders = ['amount', 'description', 'created_at'];
  
  const portfolioStore = usePortfolioStore();
  onMounted(portfolioStore.getPortfolio);


  const tableData = computed(() => portfolioStore.latest_portfolio);


  </script>
  
  <style scoped>
  </style> 
  