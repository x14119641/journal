<template>
  <div class="flex flex-col space-y-6 w-full">
    <!-- Row 1: BACTESTER HEADER + Large Chart WHEN LOADING -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 w-full">
      <!-- Backtester -->
      <div class="container-component">
        <BackTesterHeader />
      </div>

      <!-- LArge chart showing the timeseries of the growth of the potential protfolio -->
      <div
        v-if="allPortfoliosData.length > 0"
        class="max-h-[270px] container-component border border-white/10 dark:border-white/20  col-span-2"
      >
        <div class="">
          <MultiPortfolioGrowthChart
            v-if="backtesterStore.drip"
            class="max-h-[270px]"
            :labels="historicalDates"
            :series="allPortfoliosData"
          />
          <MultiPortfolioGrowthChart
            v-else
            class="max-h-[270px]"
            :labels="historicalDates"
            :series="allPortfoliosData"
            :cash_series="allPortfoliosCashData"
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

  <!-- <p>{{ allPortfoliosData }}</p> -->
</template>

<script setup lang="ts">
import BackTesterHeader from "../components/BackTesterHeader.vue";
import { onMounted, computed, ref, nextTick } from "vue";
import PortfolioBacktesterBuilder from "../components/PortfolioBacktesterBuilder.vue";
import { useBacktesterStore } from "../stores/backTesterStore";
import MultiPortfolioGrowthChart from "../components/MultiPortfolioGrowthChart.vue";

const portfolioHistory = ref<{ record_date: string; balance: number }[]>([]);

const backtesterStore = useBacktesterStore();

const allPortfoliosData = computed(() =>
  Object.entries(backtesterStore.portfolioResults).map(([name, data]) => ({
    name,
    values: data.map((entry) => entry.invested_value),
  }))
);

const allPortfoliosCashData = computed(() =>
  Object.entries(backtesterStore.portfolioResults).map(([name, data]) => ({
    name,
    values: data.map((entry) => entry.cash),
  }))
);

const historicalDates = computed(() => {
  const first = Object.values(backtesterStore.portfolioResults)[0] || [];
  return first.map((entry) => entry.date);
});


onMounted(async () => {
  await nextTick();
});
</script>

<style scoped>

</style>
