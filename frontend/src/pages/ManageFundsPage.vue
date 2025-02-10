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
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg w-full overflow-hidden">
        <!-- Main content, table -->
        <DataTable title="Latest Transactions" :headers="tableHeaders" :rows="tableData" />
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted } from 'vue';
  import api from '../services/api';
  // import { type Fund } from '../models/models';
  import DataTable from '../components/DataTable.vue';
  import FundsHeader from '../components/FundsHeader.vue';
  import AddFunds from '../components/AddFunds.vue';
  import RemoveFunds from '../components/RemoveFunds.vue';
  
  const tableData = ref([]);
  const error_message = ref<String>(''); 
  const tableHeaders = ['Amount', 'Description', 'Created at'];
  
  onMounted(async () => {
    try {
      const response = await api.get('/portfolio/funds')
      tableData.value = response.data.map((key) => {
        return {
          'amount':key.amount,
          'description':key.description,
          'created_at':key.created_at
        }
      })
    } catch (error) {
      console.error('Error in get funds data: ', error)
      error_message.value = 'Failed to load data from funds'
    }
  })
  </script>
  
  <style scoped>
  </style> 
  