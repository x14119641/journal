<template>
  <div class="flex flex-col space-y-6 w-full">
    <!-- Row 1: Portfolio Summary (Column) + Large Chart -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 w-full">
      <!-- Portfolio Summary (Vertical) -->
      <div class="container-component">
        <DashboardHeader />
      </div>

      <!-- Large Chart (Choose the Most Useful One) -->
      <div class="container-component p-6 col-span-2">
        <LineChartComponent
          title="Portfolio Growth Over Time"
          :labels="historicalDates"
          :values="historicalPortfolioValues"
        />
      </div>
    </div>

    <!-- ✅ Row 2: Dividend Calendar + Dividend Breakdown -->
    <div class="grid grid-cols-2 gap-6 w-full">
      <!-- Smaller Dividend Calendar (Limited Height) -->
      <div class="container-component max-h-[400px] no-scrollbar">
        <!-- <CalendarComponent v-if="hasData"  :data="dividends" dateColumn="paymentDate" :month="currentMonth"/> -->
        <div class="pt-2 flex justify-center items-center text-center gap-x-6">
          <ArrowLeft class="arrow-style h-5 w-5" @click="calendarStore.prevMonth" />
          <h3 class="title-component">{{  months[calendarStore.currentMonth] }}</h3>
          <ArrowRight  class="arrow-style h-5 w-5" @click="calendarStore.nextMonth" />
        </div>
          <CompactCalendar :data="calendarStore.dividends" dateColumn="paymentDate" :month="calendarStore.currentMonth" />

        
      </div>

      <!-- Dividend Breakdown -->
      <!-- <div class="container-component p-6">
        <BarChartComponent
          title="Monthly Dividend Income"
          :labels="dividendMonths"
          :values="dividendAmounts"
        />
      </div> -->
    </div>

    <!-- ✅ Row 3: Performance, Profit/Loss, and Cash Flow -->
    <!-- <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 w-full">
      <div class="container-component p-6">
        <BarChartComponent
          title="Profit & Loss Breakdown"
          :labels="profitLossStocks"
          :values="profitLossValues"
        />
      </div>
      <div class="container-component p-6">
        <BarChartComponent
          title="Sector Allocation"
          :labels="sectorAllocationLabels"
          :values="sectorAllocationValues"
        />
      </div>
      <div class="container-component p-6">
        <AreaChartComponent
          title="Cash Flow Over Time"
          :labels="cashFlowDates"
          :values="cashFlowAmounts"
        />
      </div>
    </div> -->
  </div>
  
  <!-- <p>{{ dividends }}</p> -->
</template>

<script setup lang="ts">
import DashboardHeader from '../components/DashboardHeader.vue';
import { usePortfolioStore } from '../stores/portfolioStore';

import { onMounted, ref } from 'vue';

import CompactCalendar from '../components/CompactCalendar.vue';
import { useCalendarStore } from '../stores/calendarStore';
import { ArrowRight,ArrowLeft } from 'lucide-vue-next';

const calendarStore = useCalendarStore();
const months = ref(["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]);
onMounted(() => {
  calendarStore.fetchDividends();
});


</script>

<style scoped>
.arrow-style {
  @apply text-secondary
}
.no-scrollbar {
  overflow-y: auto; /* Enables scrolling */
  scrollbar-width: none; /* Firefox - Hides scrollbar */
}

.no-scrollbar::-webkit-scrollbar {
  display: none; /* Chrome, Safari - Hides scrollbar */
}
</style>