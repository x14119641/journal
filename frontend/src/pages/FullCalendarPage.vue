<template>
  <div class="container-component">
    <!-- Months buttons -->
    <div class="p-6 flex justify-center">
      <div v-for="(month, index) in months" :key="index" class="px-2">
        <button 
          @click="setMonth(index)"
          class="py-2 px-6 rounded-lg shadow-lg"
          :class="{
            // Selected Month
            'calendar-months-button-selected focus:ring-opacity-50': currentMonth === index,
            'calendar-months-button': currentMonth !== index
          }"
        >
          {{ month }}
        </button>
      </div>
    </div>
    <CalendarComponent :data="dividends" dateColumn="paymentDate" :month="currentMonth"/>
  </div>
</template>


<script setup lang="ts">
import { ref, onMounted } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import CalendarComponent from "../components/CalendarComponent.vue"
import { type DividendCalendar } from "../models/models";
import api from "../services/api";


const months = ref([
  "January", "February", "March", "April", "May", "June", 
  "July", "August", "September", "October", "November", "December"
]);

const portfolioStore = usePortfolioStore();
onMounted(async () => {
  await portfolioStore.getPortfolio();
});

const today = new Date();
const currentMonth = ref(today.getMonth());
const dividends = ref<DividendCalendar[]>([]);

onMounted(async () => {
  getMonthDividends();
});
const setMonth = (monthIndex: number) => {
  currentMonth.value = monthIndex;
  getMonthDividends();
};
// call api
const getMonthDividends = async () => {
  // need to +1
  const correct_index = currentMonth.value + 1;
  console.log('Current Value:', currentMonth.value)
  try {
    // gives me ticker, amount and payment date
    const response = await api.get(
      `/stocks/dividends/calendar/${correct_index}`
    );
    dividends.value = response.data;
  } catch (error) {
    console.error("Errro to getch data: ", error);
  }
};
</script>

<style scoped>
.calendar-months-button{
  @apply bg-gray-300  dark:bg-gray-900 text-gray-600 dark:text-gray-100 hover:bg-gray-500 hover:text-gray-800 focus:ring-gray-400 dark:hover:bg-gray-500 dark:hover:text-gray-300 dark:focus:ring-gray-400;
}
.calendar-months-button-selected{
  @apply bg-lime-400 text-gray-600 hover:bg-gray-300 hover:text-gray-800 focus:ring-gray-400;
}
</style>
