<template>
  <div class="bg-gray-100 p-6">
    <h1 class="text-3xl font-bold text-center mb-6">Stock Information</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <!-- Amount Card -->
      <div class="pg-4 bg-slate-200 shadow rounded-lg">
        <h2 class="text-xl font-semibold mb-2">Amount</h2>
        <p class="text-gray-700">{{ stockData.amount }}</p>
      </div>
      <!-- Payment Date Card -->
      <div class="p-4 bg-white shadow rounded-lg">
        <h2 class="text-xl font-semibold mb-2">Payment Date</h2>
        <p class="text-gray-700">{{ stockData.paymentDate }}</p>
      </div>

      <!-- Total Investors Card -->
      <div class="p-4 bg-white shadow rounded-lg">
        <h2 class="text-xl font-semibold mb-2">Total Investors</h2>
        <p class="text-gray-700">{{ stockData.totalInvestors }}</p>
      </div>

      <!-- Percentage of Buys This Month Card -->
      <div class="p-4 bg-white shadow rounded-lg">
        <h2 class="text-xl font-semibold mb-2">Buys This Month</h2>
        <p class="text-gray-700">{{ stockData.buysThisMonth }}%</p>
      </div>

      <!-- Last Sellers Table -->
      <div class="p-4 bg-white shadow rounded-lg">
        <h2 class="text-xl font-semibold mb-2">Last Sellers</h2>
        <table class="min-w-full border-collapse border border-gray-200">
          <thead>
            <tr>
              <th class="border border-gray-200 p-2">Seller</th>
              <th class="border border-gray-200 p-2">Date</th>
              <th class="border border-gray-200 p-2">Amount</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="seller in stockData.lastSellers" :key="seller.id">
              <td class="border border-gray-200 p-2">{{ seller.name }}</td>
              <td class="border border-gray-200 p-2">{{ seller.date }}</td>
              <td class="border border-gray-200 p-2">{{ seller.amount }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Add more cards or sections as needed -->
    </div>
  </div>
</template>

<script lang="ts">
import { ref, computed, onMounted } from "vue";
import api from "../services/api";

export default {
  setup() {
    const stockData = ref({
      amount:1000,
      paymentDate: "2025-01-31",
      totalInvestors: 1200,
      buysThisMonth: 45,
      lastSellers: [
        { id: 1, name: "John Doe", date: "2025-01-10", amount: 500 },
        { id: 2, name: "Jane Smith", date: "2025-01-11", amount: 300 },
        { id: 3, name: "Alice Johnson", date: "2025-01-12", amount: 200 },
      ],
      // Add more data as needed
    })
    return {
      stockData,
    };
  },
};
</script>

<style scoped>
/* You can add custom styles here if needed */
</style>
