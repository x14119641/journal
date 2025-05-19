<template>
  <div class="flex flex-col space-y-6 w-full">
    <!-- Row 1: BACTESTER HEADER + Large Chart WHEN LOADING -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 w-full">
      <!-- Backtester -->
      <div class="container-component">
        <BackTesterHeader />
      </div>

      <!-- LArge chart showing the timeseries of the growth of the potential protfolio -->
      <div v-if="allPortfoliosData.length > 0" class="max-h-[250px] container-component col-span-2">
        <div class="">
          <MultiPortfolioGrowthChart
            class="max-h-[250px]"
            :labels="historicalDates"
            :series="allPortfoliosData"
          />
        </div>
      </div>
    </div>

    <!-- Row 2: This will have different options for the stock-->
    <div class="">
      <div class="container-component">
        <PortfolioBacktesterBuilder />
      </div>
      
    </div>

  </div>

  <p>{{ allPortfoliosData }}</p>
   
</template>

<script setup lang="ts">
import BackTesterHeader from "../components/BackTesterHeader.vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import api from "../services/api";
import { onMounted, computed, ref, nextTick } from "vue";
import PortfolioBacktesterBuilder from "../components/PortfolioBacktesterBuilder.vue";
import { useBacktesterStore } from "../stores/backTesterStore";
import MultiPortfolioGrowthChart from "../components/MultiPortfolioGrothChart.vue"


const portfolioStore = usePortfolioStore();
const portfolioHistory = ref<{ record_date: string; balance: number }[]>([]);

const backtesterStore = useBacktesterStore();

const allPortfoliosData = computed(() => 
  Object.entries(backtesterStore.portfolioResults).map(([name, data]) => ({
    name,
    values: data.map((entry) => entry.invested_value)
  }))
)

const allPortfoliosCashData = computed(() => 
  Object.entries(backtesterStore.portfolioResults).map(([name, data]) => ({
    name,
    values: data.map((entry) => entry.cash)
  }))
)

const historicalDates = computed(() => {
  const first = Object.values(backtesterStore.portfolioResults)[0] || [];
  return first.map((entry) => entry.date);
});


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
  @apply text-black dark:text-secondary cursor-pointer;
}
.no-scrollbar {
  overflow-y: auto; /* Enables scrolling */
  scrollbar-width: none; /* Firefox - Hides scrollbar */
}

.no-scrollbar::-webkit-scrollbar {
  display: none; /* Chrome, Safari - Hides scrollbar */
}
.container-component2 {
  @apply backdrop-blur-2xl bg-white/10 dark:bg-black/40 
    border border-white/10 dark:border-white/20 
    text-white rounded-2xl shadow-lg;
}
</style>
