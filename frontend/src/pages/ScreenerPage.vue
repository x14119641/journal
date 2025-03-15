<template>
  <div class="flex flex-col items-center gap-6 w-full">
    <div class="grid grid-cols-1">
      <div class="container-component">
        <h2 class="title-component text-center pt-6">Stock Screener</h2>

        <!-- Filters Section -->
        <div class="flex justify-center px-6">
          <div class="grid grid-cols-6 sm:grid-cols-2 lg:grid-cols-6 gap-6">
            <div
              v-for="(filter, index) in filterFields"
              :key="index"
              class="space-y-2"
            >
              <label v-bind:for="filter.id" class="text-label">
                {{ filter.label }}
              </label>

              <!-- Render select fields manually -->
              <template v-if="filter.type === 'select'">
                <CustomSelectDropDown v-model="filters[filter.id]" :options="filter.props.options"/>
              </template>

              <!-- Render input fields dynamically -->
              <template v-else>
                <input
                  v-bind="filter.props"
                  v-model="filters[filter.id]"
                  class="input-style"
                />
              </template>
            </div>
          </div>
        </div>

        <!-- Submit Button -->
        <div class="flex justify-center p-6">
          <button
            @click="queryStocks"
            class="bg-blue-500 text-white py-2 px-6 rounded-md shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50"
          >
            Search
          </button>
        </div>
      </div>
      <!-- Results Table -->
      <div v-if="results.length > 0" class="pt-6">
        <div class="slate-container">
          <DataTable :headers="tableHeaders" :rows="results" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import api from "../services/api";
import { type StockScreener } from "../models/models";
import DataTable from "../components/DataTable.vue";
import CustomSelectDropDown from "../components/CustomSelectDropDown.vue";


// Filters object, ensure the initial values align with your backend requirements
const filters = ref({
  numDividends: "",
  amountAbove: "",
  exDateMonth: "",
  sector: "",
  marketcap: "",
  peratio: "",
  forwardpe1yr: "",
  earningspershare: "",
  annualizeddividend: "",
  annualyield: "",
  sharesoutstandingpct: "",
  ratioholdersbuysold: "",
});

// Filter fields configuration for dynamic filter rendering
const filterFields = [
  {
    id: "numDividends",
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
    id: "amountAbove",
    label: "Amount Above",
    type: "input",
    props: {
      type: "number",
    },
  },
  {
    id: "exDateMonth",
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
    id: "sector",
    label: "Sector",
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
    id: "marketcap",
    label: "Market Cap.",
    type: "select",
    props: {
      options: [
        { value: "", label: "Select Market Cap. (Millions)" },
        { value: "100", label: "Above 100" },
        { value: "200", label: "Above 200" },
        { value: "300", label: "Above 300" },
        { value: "400", label: "Above 400" },
        { value: "500", label: "Above 500" },
      ],
    },
  },
  {
    id: "peratio",
    label: "PER Ratio",
    type: "input",
    props: {
      type: "number",
    },
  },
  {
    id: "forwardpe1yr",
    label: "Forwar PER 1yr",
    type: "input",
    props: {
      type: "number",
    },
  },
  {
    id: "earningspershare",
    label: "Earnings Share",
    type: "input",
    props: {
      type: "number",
    },
  },
  {
    id: "annualizeddividend",
    label: "Anual Yield %",
    type: "input",
    props: {
      type: "number",
    },
  },
  {
    id: "annualyield",
    label: "Yield %",
    type: "input",
    props: {
      type: "number",
    },
  },
  {
    id: "sharesoutstandingpct",
    label: "Instiutional Ownershift %",
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
// const tableHeaders = [
//   "ticker", "numdividends", "amount", "declarationdate", "sector",
//   "marketcap", "peratio", "forwardpe1yr", "earningspershare",
//   "annualizeddividend", "yield", "sharesoutstandingpct", "ratioholdersbuysold"];

// Columns are dynamically computed based on the first result object
const tableHeaders = computed(() => {
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

<style scoped></style>
