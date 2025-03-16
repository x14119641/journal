<template>
    <div class="px-6 pb-6">
      <!-- Calendar Title -->
      <!-- <h3 class="title-component  text-center pt-2 text-sm">
        {{ months[props.month] }}
      </h3> -->
  
      <!-- Calendar Days Header -->
      <div class="grid grid-cols-7 gap-4 text-sm pt-2 text-center">
        <div v-for="(day, index) in daysOfWeek" :key="index" class="calendar-days " >
          {{ day }}
        </div>
      </div>
  
      <!-- Calendar Grid -->
      <div class="grid grid-cols-7 gap-4">
        <!-- Fill in empty days -->
        <div v-for="n in startDayOfMonth" :key="`empty-${n}`" class="p-4 border rounded-lg border-gray-700 bg-transparent shadow-sm"
        ></div>
  
        <!-- Actual Days of the Month -->
        <div v-for="(day, index) in daysInMonth" :key="index" 
        class="p-4 border rounded-lg calendar-cell-style shadow-sm">
          <div class="calendar-cell-day text-sm">{{ day.date }}</div>
  
          <!-- Dividends Grid -->
          <div class="grid grid-cols-1 gap-y-1">
            <div v-for="(dividend, i) in visibleDividends(day)" :key="i">
              <div class="flex justify-between text-sm space-x-2">
                <router-link
                  :to="`/stocks/${dividend.ticker}`"
                  class="calendar-ticker"
                  :title="dividend.ticker"
                >
                  {{ dividend.ticker }}
                </router-link>
                <span class="calendar-dividend">{{ dividend.amount }}</span>
              </div>
            </div>
          </div>
  
          <!-- Show More Button -->
          <div v-if="day.dividends.length > maxTickersPerDay" class="text-sm flex justify-center">
            <button @click="toggleExpand(day.date)" class="calendar-show-more">
              {{ isExpanded(day.date) ? "Show less" : "Show more" }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </template>


<script setup lang="ts">
import { ref, computed } from "vue";
import {
  format,
  getDaysInMonth,
  addDays,
  startOfMonth,
  getDay,
} from "date-fns";

const props = defineProps<{
  month: number;
  data: Record<string, any>[];
  dateColumn: string;
}>();

const daysOfWeek = ref(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]);
const months = ref(["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]);


// Num of tickers till the "show more" row
const maxTickersPerDay = ref(3);

// store day with its dividends when clicked
const expandedDays = ref<Record<string, boolean>>({});
// A helper function: given a day object, return the visible dividends.
const visibleDividends = (day: { date: string; dividends: any[] }) => {
  if (day.dividends.length <= maxTickersPerDay.value || isExpanded(day.date)) {
    return day.dividends;
  } else {
    return day.dividends.slice(0, maxTickersPerDay.value);
  }
};
// Check if a given day (by date string) is expanded.
const isExpanded = (date: string) => {
  return expandedDays.value[date] === true;
};

// Toggle expanded state for a given date.
const toggleExpand = (date: string) => {
  expandedDays.value[date] = !expandedDays.value[date];
};
const year = new Date().getFullYear();
const startDate = computed(() => startOfMonth(new Date(year, props.month, 1)));

// Calculate the day of the week the month starts on
const startDayOfMonth = computed(() => getDay(startDate.value));

const dividends = computed(() => props.data || []);

// Calculate the days in the current month
const daysInMonth = computed(() => {
  const days = [];
  const totalDays = getDaysInMonth(startDate.value);

  for (let i = 0; i < totalDays; i++) {
    const date = addDays(startDate.value, i);
    const dateStr = format(date, "yyyy-MM-dd");
    const dayDividends = dividends.value.filter(
      (dividend) => dividend[props.dateColumn] === dateStr
    );
    days.push({
      date: format(date, "d"),
      dividends: dayDividends,
    });
  }
  return days;
});
</script>

<style scoped>
.calendar-title{
  @apply font-bold text-lime-400;
}
.calendar-ticker {
  @apply text-blue-700 dark:text-indigo-300 hover:underline hover:text-gray-800 dark:hover:text-lime-300 truncate;
}
.calendar-days {
  @apply  text-gray-700 dark:text-blue-200 font-bold;
}
.calendar-cell-style {
  @apply bg-gray-300  dark:bg-gray-900 border-gray-700;
}
.calendar-cell-day {
  @apply font-bold  text-gray-950 dark:text-gray-300;
}
.calendar-ticker {
  @apply text-blue-700  dark:text-indigo-300 hover:underline hover:text-gray-800 dark:hover:text-lime-300 truncate;
}
.calendar-dividend {
  @apply font-bold text-green-500 dark:text-green-400 ml-1;
}
.calendar-show-more {
  @apply text-gray-700 hover:text-blue-500 dark:text-blue-500 dark:hover:text-blue-600;
}

.no-scrollbar {
  overflow-y: auto; /* Enables scrolling */
  scrollbar-width: none; /* Firefox - Hides scrollbar */
}

.no-scrollbar::-webkit-scrollbar {
  display: none; /* Chrome, Safari - Hides scrollbar */
}
</style>
