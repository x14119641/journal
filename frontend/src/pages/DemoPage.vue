<template>
  <div class="">
    <div class="bg-slate-600 p-6 rounded-lg shadow-md">
      <h2 class="text-2xl font-bold mb-6 text-center">Stock Screener</h2>

      <!-- Filters Section -->
      <div class="flex justify-center">
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-6 gap-6 mb-6">
          <div
            v-for="(filter, index) in filterFields"
            :key="index"
            class="space-y-2"
          >
            <label
              v-bind:for="filter.id"
              class="block text-sm font-medium text-gray-700"
            >
              {{ filter.label }}
            </label>

            <!-- Render select fields manually -->
            <template v-if="filter.type === 'select'">
              <select
                :id="filter.id"
                :name="filter.id"
                v-model="filters[filter.id]"
                class="mt-1 p-2 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 focus:ring-opacity-50 bg-blue-100"
              >
                <option
                  v-for="option in filter.props.options"
                  :key="option.value"
                  :value="option.value"
                >
                  {{ option.label }}
                </option>
              </select>
            </template>

            <!-- Render input fields dynamically -->
            <template v-else>
              <input
                v-bind="filter.props"
                v-model="filters[filter.id]"
                class="mt-1 p-2 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 focus:ring-opacity-50 bg-blue-100"
              />
            </template>
          </div>
        </div>
      </div>

      <!-- Submit Button -->
      <div class="flex justify-center">
        <button
          @click="queryStocks"
          class="bg-blue-600 text-white py-2 px-6 rounded-md shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50"
        >
          Search
        </button>
      </div>
    </div>

    <!-- Results Table -->
    <div v-if="results.length > 0" class="mt-6">
  <h3 class="text-lg font-semibold mb-4">Results</h3>
  <div class="overflow-x-auto max-w-full">
    <table class="min-w-full bg-white border border-gray-300 rounded-md shadow-md">
      <thead>
        <tr class="bg-gray-100">
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">Ticker</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">Payments</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">ExDivDate</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">PayDate</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">Amount</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">% Inst. Ownership</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">Increased Inst. pos</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">Decreased Inst. pos</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">Held Inst. pos</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">Total Inst. pos</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">New pos. Holders</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">SoldOut pos.</th>
          <th class="px-4 py-3 text-left text-sm font-medium text-gray-800">ratioBuySold</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(stock, index) in results" :key="index" class="hover:bg-gray-50">
          <td v-for="(col, index) in columns" :key="index" class="px-4 py-3 border-b border-gray-200">
            {{ stock[col] }}
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

  </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import api from "../services/api";
import { type StockScreener } from "../models/models";

// Filters object, ensure the initial values align with your backend requirements
const filters = ref({
  paymentMonth: "",
  lastYearPayments: "",
  institutionalPercentage: "",
  amountAbove: "",
  ratioHoldersBuySold: "",
});

// Filter fields configuration for dynamic filter rendering
const filterFields = [
  {
    id: "paymentMonth",
    label: "Payment Month",
    type: "select",
    props: {
      options: [
        { value: "", label: "Select Payment Month" },
        { value: "1", label: "January" },
        { value: "2", label: "February" },
        { value: "3", label: "March" },
        { value: "4", label: "April" },
        { value: "5", label: "May" },
        { value: "6", label: "June" },
        { value: "7", label: "July" },
        { value: "8", label: "August" },
        { value: "9", label: "September" },
        { value: "10", label: "October" },
        { value: "11", label: "November" },
        { value: "12", label: "December" },
      ],
    },
  },
  {
    id: "lastYearPayments",
    label: "Number of Payments Last Year",
    type: "select",
    props: {
      options: [
        { value: "", label: "Select Last Year Payments" },
        { value: "1", label: "Above 1" },
        { value: "2", label: "Above 2" },
        { value: "3", label: "Above 3" },
        { value: "4", label: "Above 4" },
        { value: "5", label: "Above 5" },
      ],
    },
  },
  {
    id: "institutionalPercentage",
    label: "Institutional Percentage",
    type: "select",
    props: {
      options: [
        { value: "", label: "Select Percentage" },
        { value: "1", label: "Above 1%" },
        { value: "5", label: "Above 5%" },
        { value: "10", label: "Above 10%" },
        { value: "20", label: "Above 20%" },
        { value: "30", label: "Above 30%" },
        { value: "40", label: "Above 40%" },
        { value: "50", label: "Above 50%" },
        { value: "60", label: "Above 60%" },
        { value: "70", label: "Above 70%" },
        { value: "80", label: "Above 80%" },
        { value: "90", label: "Above 90%" },
      ],
    },
  },
  {
    id: "amountAbove",
    label: "Amount Above",
    type: "input",
    props: {
      type: "number",
    },
  },
  {
    id: "ratioHoldersBuySold",
    label: "Ratio of Holders Buy/Sold",
    type: "input",
    props: {
      type: "number",
    },
  },
];

const results = ref<StockScreener[]>([]);

// Columns are dynamically computed based on the first result object
const columns = computed(() => {
  if (results.value.length > 0) {
    return Object.keys(results.value[0]);
  }
  return [];
});

const queryStocks = async () => {
  // Construct query params from filters object
  const queryParams = new URLSearchParams();

  Object.keys(filters.value).forEach((key) => {
    if (filters.value[key]) {
      queryParams.append(key, filters.value[key]);
    }
  });
  // Clear previous results to trigger reactivity
  results.value = [];

  try {
    const response = await api.get(
      `/stocks/screener?${queryParams.toString()}`
    );
    results.value = [...response.data]; // Spread the array to ensure reactivity
  } catch (error) {
    console.error("Error fetching data in Demo page", error);
  }
};
</script>
<!--  
<style scoped>
table {
  border-collapse: collapse;
  width: 100%;
}
th,
td {
  padding: 12px;
  text-align: left;
  font-size: 0.875rem;
}
th {
  background-color: #f7fafc;
  color: #4a5568;
}
td {
  border-bottom: 1px solid #e2e8f0;
}
tr:hover {
  background-color: #f1f5f9;
}
</style> -->
