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
import { Stock } from '../models/models';

const tickers = ref<Stock[]>([]);
const error_message = ref<String>('');

onMounted(async () => {
    try {
        const response = await axios.get('http://localhost:8000/stocks/tickers')
        tickers.value = response.data 
    } catch (error) {
        console.error('Errro to getch data: ', error)
        error_message.value = 'Failed to load message'
    }
})

// Example users data (JSON response like structure)
const users = ref([
  {
    id: '1',
    username: 'john_doe',
    email: 'john.doe@example.com',
    created_at: '2022-01-15',
    active: true,
  },
  {
    id: '2',
    username: 'jane_smith',
    email: 'jane.smith@example.com',
    created_at: '2021-11-20',
    active: false,
  },
  {
    id: '3',
    username: 'alice_jones',
    email: 'alice.jones@example.com',
    created_at: '2023-02-10',
    active: true,
  },
  {
    id: '4',
    username: 'bob_brown',
    email: 'bob.brown@example.com',
    created_at: '2020-09-05',
    active: true,
  },
  {
    id: '5',
    username: 'carol_white',
    email: 'carol.white@example.com',
    created_at: '2022-04-25',
    active: false,
  },
  {
    id: '6',
    username: 'dave_black',
    email: 'dave.black@example.com',
    created_at: '2021-07-13',
    active: true,
  },
]);

// Function to handle action click
function handleAction(userId: string) {
  alert(`Action for user ID: ${userId}`);
}
</script>

<style scoped>
/* You can add custom styles here if needed */
</style>
