<template>
    <div class="flex flex-col items-center space-y-6">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full">
        <!-- Left Column -->
        <div class="bg-gray-800 rounded-lg shadow-lg ">
          <FundsHeader />
        </div>
  
        <!-- Right Column (2 boxes inside) -->
        <div class="col-span-2 flex flex-col gap-6 w-full">
          <div class="slate-container">
            <AddFunds />
          </div>
          <div class="slate-container">
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
  import { useTransactionsStore } from '../stores/transactionsStore';
  import DataTable from '../components/DataTable.vue';
  import FundsHeader from '../components/FundsHeader.vue';
  import AddFunds from '../components/AddFunds.vue';
  import RemoveFunds from '../components/RemoveFunds.vue';
 
  const tableHeaders = ['quantity', 'details', 'created_at'];
  
  const transactionsStore = useTransactionsStore();
  onMounted(transactionsStore.getTransactionHistory)

  const tableData = computed(() => transactionsStore.transactions_history)
  </script>
  
  <style scoped>
  </style> 
  