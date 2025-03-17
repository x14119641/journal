<template>
  <div class="flex flex-col space-y-6 w-full">
    <!-- Row 1: Portfolio Summary (Column) + Large Chart -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 w-full">
      <!-- Portfolio Summary (Vertical) -->
      <div class="container-component">
        <DashboardHeader />
      </div>

      <!-- Large Chart (Choose the Most Useful One) -->
      <div class="max-h-[250px] container-component col-span-2">
        <div class=" ">
          <PortfolioGrowthOverTimeChart
            v-if="historicalPortfolioValues.length > 0"
            class="max-h-[250px]"
            :labels="historicalDates"
            :values="historicalPortfolioValues"
          />
        </div>
      </div>
    </div>

    <!-- Row 2: Dividend Calendar + 2 boxes one on top of other -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 w-full">
      <!-- Left Column -->
      <div class="container-component w-full">
        <div class="container-component max-h-[600px] no-scrollbar col-span-2">
          <!-- <CalendarComponent v-if="hasData"  :data="dividends" dateColumn="paymentDate" :month="currentMonth"/> -->
          <div
            class="pt-2 flex justify-center items-center text-center gap-x-6"
          >
            <ArrowLeft
              class="arrow-style h-5 w-5"
              @click="calendarStore.prevMonth"
            />
            <h3 class="title-component">
              {{ months[calendarStore.currentMonth] }}
            </h3>
            <ArrowRight
              class="arrow-style h-5 w-5"
              @click="calendarStore.nextMonth"
            />
          </div>

          <CompactCalendar
            :data="calendarStore.dividends"
            dateColumn="paymentDate"
            :month="calendarStore.currentMonth"
          />
        </div>
      </div>

      <!-- Right Column (2 boxes inside) -->
      <div class="flex flex-col gap-6 sm:col-span-1">
        <div class="container-component">
          <div
            v-if="historicalPortfolioValues.length > 0"
            class="container-component max-h-[300px] overflow-hidden"
          >
            <PortfolioGrowthOverTimeChart class="max-h-[300px]"
              :labels="historicalDates"
              :values="historicalPortfolioValues"
            />
          </div>
        </div>
        <div class="container-component max-h-[300px] overflow-hidden">
          <div
            v-if="historicalPortfolioValues.length > 0"
            class="container-component"
          >
            <PortfolioGrowthOverTimeChart class="max-h-[300px]"
              :labels="historicalDates"
              :values="historicalPortfolioValues"
            />
          </div>
        </div>
      </div>
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

  <!-- <p>{{ portfolioHistory }}</p> -->
</template>

<script setup lang="ts">
import DashboardHeader from "../components/DashboardHeader.vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import api from "../services/api";
import { onMounted, computed, ref, nextTick } from "vue";

import CompactCalendar from "../components/CompactCalendar.vue";
import { useCalendarStore } from "../stores/calendarStore";
import { ArrowRight, ArrowLeft } from "lucide-vue-next";
import PortfolioGrowthOverTimeChart from "../components/PortfolioGrowthOverTimeChart.vue";

const calendarStore = useCalendarStore();
const months = ref([
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
]);

const portfolioStore = usePortfolioStore();
const portfolioHistory = ref<{ record_date: string; balance: number }[]>([]);

const historicalDates = computed(() =>
  portfolioHistory.value.map((entry) => entry.record_date)
);
const historicalPortfolioValues = computed(() =>
  portfolioHistory.value.map((entry) => entry.balance)
);

const fetchPortfolioHistory = async () => {
  try {
    const response = await api.get("/portfolio/balance/history");
    portfolioHistory.value = [...response.data];

    const today = new Date().toISOString().slice(0, 10);
    portfolioHistory.value.push({
      record_date: today,
      balance: portfolioStore.balance,
    });
  } catch (error) {
    console.error("Error fetching portfolio history:", error);
  }
};

onMounted(async () => {
  await nextTick();
  await calendarStore.fetchDividends();
  await portfolioStore.getPortfolio();
  await fetchPortfolioHistory();
});
</script>

<style scoped>
.arrow-style {
  @apply text-secondary;
}
.no-scrollbar {
  overflow-y: auto; /* Enables scrolling */
  scrollbar-width: none; /* Firefox - Hides scrollbar */
}

.no-scrollbar::-webkit-scrollbar {
  display: none; /* Chrome, Safari - Hides scrollbar */
}
</style>
