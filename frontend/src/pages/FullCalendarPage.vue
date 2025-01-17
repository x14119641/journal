<template>
  <div class="bg-gray-100 p-6">
    <!-- Months buttons -->
    <div class="flex justify-center mb-2">
      <div v-for="(month, index) in months" :key="index" class="px-2">
        <button 
          @click="setMonth(index)"
          :class="{
            'bg-blue-500 text-white hover:bg-blue-600 focus:ring-blue-400': currentMonth === index,
            'bg-gray-200 text-black hover:bg-gray-300 focus:ring-gray-400': currentMonth !== index
          }"
        >
          {{ month }}
        </button>
      </div>
    </div>
    <div class="mt-10">
      <h2 class="text-2xl font-bold text-center mb-4">{{ monthYear }}</h2>
      
      <!-- Calendar Days Header -->
      <div class="grid grid-cols-7 gap-4 mb-2">
        <div v-for="(day, index) in daysOfWeek" :key="index" class="font-bold text-center">
          {{ day }}
        </div>
      </div>
      
      <!-- Calendar Grid -->
      <div class="grid grid-cols-7 gap-4">
        <!-- Fill in empty days before the first day of the month -->
        <div v-for="n in startDayOfMonth" :key="`empty-${n}`" class="p-4 border rounded-lg bg-transparent shadow-sm"></div>
        
        <!-- Actual Days of the Month -->
        <div v-for="(day, index) in daysInMonth" :key="index" class="p-4 border rounded-lg bg-white shadow-sm">
          <div class="font-bold text-lg">{{ day.date }}</div>
          <div class="text-sm text-gray-600">
            <div v-for="(dividend, dividendIndex) in day.dividends" :key="dividendIndex">
              <router-link
                :to="`/stocks/${dividend.ticker}`"
                class="text-blue hover:underline">
                {{ dividend.ticker }}
              </router-link>
              <span class="font-bold text-green-500">{{ dividend.amount }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, computed, onMounted } from "vue";
import { format, getDaysInMonth, addDays, startOfMonth, getDay } from "date-fns";
import { type DividendCalendar } from "../models/models";
import api from "../services/api";

export default {
  setup() {
    const daysOfWeek = ref(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]);
    const months = ref([
      "January", "February", "March", "April", "May", "June", 
      "July", "August", "September", "October", "November", "December"
    ]);

    const today = new Date();
    let currentMonth = ref(today.getMonth());
    const monthYear = computed(() => `${months.value[currentMonth.value]} ${today.getFullYear()}`);
    const startDate = computed(() => startOfMonth(new Date(today.getFullYear(), currentMonth.value)));

    
    // Calculate the day of the week the month starts on
    const startDayOfMonth = computed(() => getDay(startDate.value));

    const error_message = ref<String>("");
    const dividends = ref<DividendCalendar[]>([]);

    // Calculate the days in the current month
    const daysInMonth = computed(() => {
      const days = [];
      const totalDays = getDaysInMonth(startDate.value);

      for (let i = 0; i < totalDays; i++) {
        const date = addDays(startDate.value, i);
        const dateStr = format(date, "yyyy-MM-dd");
        const dayDividends = dividends.value.filter(
          dividend => dividend.payment_date === dateStr
        );
        days.push({
          date: format(date, "d"),
          dividends: dayDividends
        });
      }
      return days;
    });

    // load data for current month when entering
    onMounted(async () => {
      getMonthDividends()
    })
    const setMonth = (monthIndex:number) => {
      currentMonth.value = monthIndex
      getMonthDividends()
    }
    // call api
    const getMonthDividends = async () => {
      // need to +1
      const correct_index = currentMonth.value +1
      try {
        // gives me ticker, amount and payment date 
        const response = await api.get(
          `/stocks/dividends/calendar/${correct_index}`
        )
        dividends.value = response.data
      } catch (error) {
        console.error("Errro to getch data: ", error);
        error_message.value = "Failed to load message";
      }

    }

    return {
      daysOfWeek,
      months,
      monthYear,
      currentMonth,
      startDayOfMonth,
      daysInMonth,
      setMonth,
      getMonthDividends
    };
  }
};
</script>


<style scoped>
/* You can add custom styles here if needed */
</style>
