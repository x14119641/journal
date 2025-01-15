<template>
  <div class="min-h-screen bg-gray-100 p-6">
    <!-- <div v-if="error_message">{{ tickers }}</div> -->

    <div class="bg-white p-6 rounded-lg shadow-lg">
      <h2 class="text-2xl font-semibold text-gray-700 text-center mb-6">
        Tickers List
      </h2>
      <table class="min-w-full table-auto">
        <thead>
          <tr class="bg-gray-200">
            <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">ID</th>
            <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Ticker</th>
            <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Name</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(ticker, index) in tickers"
            :key="index"
            class="border-b border-gray-200 hover:bg-gray-50"
          >
            <td class="px-4 py-2 text-sm text-gray-700">{{ ticker.id }}</td>
            <td class="px-4 py-2 text-sm text-gray-700">{{ ticker.ticker }}</td>
            <td class="px-4 py-2 text-sm text-gray-700">{{ ticker.name }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { type Stock } from '../models/models';

const tickers = ref<Stock[]>([]);
const error_message = ref<String>('');

onMounted(async () => {
    try {
        const response = await axios.get('http://localhost:8000/stocks/dividends')
        tickers.value = response.data 
    } catch (error) {
        console.error('Errro to getch data: ', error)
        error_message.value = 'Failed to load message'
    }
})

</script>

<style scoped>
/* You can add custom styles here if needed */
</style>
