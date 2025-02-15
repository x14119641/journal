<template>
    <div class="bg-gray-100 p-6">
      <h1 class="text-3xl font-bold text-center mb-6">Stock Information</h1>
      
      <div v-if="stockData" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <!-- Amount Card -->
        <div class="p-4 bg-white shadow rounded-lg">
          <h2 class="text-xl font-semibold mb-2">Institutional Ownership Percentage</h2>
          <p class="text-gray-700">{{ stockData.institutional_ownership_perc }}%</p>
        </div>
  
        <!-- Total Investors Card -->
        <div class="p-4 bg-white shadow rounded-lg">
          <h2 class="text-xl font-semibold mb-2">Total Institutional Holders</h2>
          <p class="text-gray-700">{{ stockData.total_institutional_holders }}</p>
        </div>
  
        <!-- Last Sellers Table -->
        <div class="p-4 bg-white shadow rounded-lg">
          <h2 class="text-xl font-semibold mb-2">Increased Positions Holders</h2>
          <p class="text-gray-700">{{ stockData.increased_positions_holders }}</p>
        </div>
  
        <!-- Add more cards or sections as needed -->
      </div>
    </div>
  </template>
  
  
  <script setup lang="ts">
  import { ref, onMounted } from "vue";
  import { type StockMetadata } from "../models/models";
  import api from "../services/api";
  import { useRoute } from 'vue-router';
  
  const route = useRoute();
  // const ticker = ref<String>(route.params.ticker as string);
  const ticker = 'MAIN'
  const stockData = ref<StockMetadata | null>(null);
  const error_message = ref<String>('');
  
  onMounted(async () => {
    try {
        const response = await api.get(`/stocks/${ticker.value}`);
        
        stockData.value = response.data;
    } catch (error) {
      console.error('Errro to getch data: ', error)
      error_message.value = 'Failed to load message'
    }
  })
  
  </script>
  
  <style scoped>
  /* You can add additional custom styles here */
  </style>
  