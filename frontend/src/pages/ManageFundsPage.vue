<template>
    <div class="flex flex-col items-center space-y-6">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full">
        <!-- Left Column -->
        <div class="bg-gray-800 rounded-lg shadow-lg ">
          <FundsHeader />
        </div>
  
        <!-- Right Column (2 boxes inside) -->
        <div class="col-span-2 flex flex-col gap-6 w-full">
          <div class="bg-gray-800 rounded-lg shadow-lg flex-grow">
            <AddFunds />
          </div>
          <div class="bg-gray-800 rounded-lg shadow-lg flex-grow">
            <RemoveFunds />
          </div>
        </div>
      </div>
      <div class="slate-container">
        <!-- Main content, table -->
        <DataTable title="Latest Transactions" :headers="tableHeaders" :rows="tableData" />
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { onMounted, computed } from 'vue';
  import { usePortfolioStore } from '../stores/portfolioStore';
  import DataTable from '../components/DataTable.vue';
  import FundsHeader from '../components/FundsHeader.vue';
  import AddFunds from '../components/AddFunds.vue';
  import RemoveFunds from '../components/RemoveFunds.vue';
 
  const tableHeaders = ['amount', 'description', 'created_at'];
  
  const portfolioStore = usePortfolioStore();
  onMounted(portfolioStore.getPortfolio)

  const tableData = computed(() => portfolioStore.latest_funds_transactions)
  </script>
  
  <style scoped>
  </style> 
  