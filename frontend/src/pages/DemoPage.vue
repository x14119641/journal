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
        <CalendarComponent :data="dividends" dateColumn="paymentDate" :month="currentMonth" :compact="true"/>
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
import api from '../services/api';
import { computed, onMounted, ref } from 'vue';
import type { DividendCalendar } from '../models/models';
import CalendarComponent from '../components/CalendarComponent.vue';


const today = new Date();
const portfolioStore = usePortfolioStore();
const dividends = ref<DividendCalendar[]>([]);
const currentMonth = ref(today.getMonth());
const hasData = computed(() => dividends.value.length > 0 ? true:false)
// const correct_index = 2;


const months = ref([
  "January", "February", "March", "April", "May", "June", 
  "July", "August", "September", "October", "November", "December"
]);

const setMonth = (monthIndex: number) => {
  currentMonth.value = monthIndex;
  getMonthDividends();
};

onMounted(async () => {
  try {
    await portfolioStore.getPortfolio();
    await getMonthDividends()
  } catch (error) {
    console.error("Error fetching funds:", error);
  }
});

const getMonthDividends = async () => {
  try {
    const correct_index = currentMonth.value + 1;
    const response = await api.get(
      `/stocks/dividends/calendar/${correct_index}`
    );
    dividends.value = [...response.data];
  } catch (error) {
    console.error("Errro to getch data: ", error);
  }
}
</script>

<style scoped>
.no-scrollbar {
  overflow-y: auto; /* Enables scrolling */
  scrollbar-width: none; /* Firefox - Hides scrollbar */
}

.no-scrollbar::-webkit-scrollbar {
  display: none; /* Chrome, Safari - Hides scrollbar */
}
</style>