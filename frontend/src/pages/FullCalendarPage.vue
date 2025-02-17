<template>
  <div class="slate-container">
    <!-- Months buttons -->
    <div class="p-6 flex justify-center">
      <div v-for="(month, index) in months" :key="index" class="px-2">
        <button 
          @click="setMonth(index)"
          class="py-2 px-6 rounded-md shadow-md"
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
  await portfolioStore.getFunds();
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
</style>
