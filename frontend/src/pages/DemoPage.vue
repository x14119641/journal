<template>
  <div class="min-h-screen bg-gray-100 p-6">
    <!-- <div v-if="error_message">{{ tickers }}</div> -->
    <div class="mb-4">
      <input
        type="text"
        v-model="filter_ticker"
        placeholder="Filter by ticker"
        class="border-gray-300 rounded-md px-3 py-2 mr-2 w-64 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent "
      />
      <button @click="applyFilter"
        class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-opacity-75">Apply Filter</button>
    </div>
    <div>
      <!-- {{ dividends }} -->
    </div>
    <div class="bg-white p-6 rounded-lg shadow-lg">
      <table class="min-w-full table-auto">
        <thead>
          <tr class="bg-gray-200">
            <th v-for="(key, index) in columns"  :key="index"
            class="px-4 py-2 text-left text-sm font-medium text-gray-600">
              {{ key }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(dividend, index) in dividends"
            :key="index"
            class="border-b border-gray-200 hover:bg-gray-50"
          >
            <td v-for="(key, index) in columns"  :key="index"
              class="px-4 py-2 text-sm text-gray-700">{{ dividend[key] }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, computed } from "vue";
import axios from "axios";
import { type Dividend } from "../models/models"; // Import your Stock interface

export default {
  setup() {
    const dividends = ref<Dividend[]>([]);
    const filter_ticker = ref<String>("");
    const error_message = ref<String>("");

    const columns = computed(() => {
      if (dividends.value.length > 0) {return Object.keys(dividends.value[0])};
      return [];
    })

    const applyFilter = async () => {
      try {
        const response = await axios.get(
          `http://localhost:8000/stocks/dividends/${filter_ticker.value.toUpperCase()}`
        );
        dividends.value = response.data;
      } catch (error) {
        console.error("Errro to getch data: ", error);
        error_message.value = "Failed to load message";
      }
    };

    return {
      dividends,
      columns,
      error_message,
      filter_ticker,
      applyFilter,
    };
  },
};
</script>

<style scoped>
/* You can add custom styles here if needed */
</style>
