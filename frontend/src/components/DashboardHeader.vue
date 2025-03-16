<template>
  <div class="p-6 text-center">
    <h3 class="title-component">Dashboard</h3>
    <div class="mt-2 space-y-2">
      <div class="flex justify-between">
        <span class="text-label">Balance</span>
        <span class="money-positive">{{ balance }}</span>
      </div>
      <div class="flex justify-between">
        <span class="text-label">Invested</span>
        <span
          :class="totalMoneyInvested <= 0 ? 'money-positive' : 'money-negative'"
          >{{ totalMoneyInvested }}</span
        >
      </div>
      <div class="flex justify-between">
        <span class="text-label">Realized</span>
        <span
          :class="realizedGains >= 0 ? 'money-positive' : 'money-negative'"
          >{{ realizedGains }}</span
        >
      </div>
      <div class="flex justify-between">
        <span class="text-label">Dividends (This Month)</span>
        <span class="money-positive">{{ dividendsThisMonth }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted,computed } from "vue";
import api from "../services/api";
import { usePortfolioStore } from "../stores/portfolioStore";
import type { DividendCalendar } from "../models/models";


const portfolioStore = usePortfolioStore();

const balance = computed(() => portfolioStore.balance);
const totalMoneyInvested = computed(() => portfolioStore.totalMoneyInvested);
const realizedGains = computed(() => portfolioStore.netProfitLoss);
const dividendsThisMonth =  ref<number>(0);


</script>
<style scoped>

</style>
