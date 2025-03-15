<template>
  <div class="p-6 text-center">
    <h3 class="title-component">User Balance</h3>
    <div class="mt-2 space-y-2">
      <div class="flex justify-between">
        <span class="text-label">Balance</span>
        <span class="money-positive">{{ balance }}</span>
      </div>
      <div class="flex justify-between">
        <span class="text-label">Money Invested</span>
        <span
          :class="totalMoneyInvested <= 0 ? 'money-positive' : 'money-negative'"
          >{{ totalMoneyInvested }}</span
        >
      </div>
      <div class="flex justify-between">
        <span class="text-label">unrealizedMoney</span>
        <span
          :class="unrealizedMoney >= 0 ? 'money-positive' : 'money-negative'"
          >{{ unrealizedMoney }}</span
        >
      </div>
      <div class="flex justify-between">
        <span class="text-label">Realized Gains</span>
        <span
          :class="realizedGains >= 0 ? 'money-positive' : 'money-negative'"
          >{{ realizedGains }}</span
        >
      </div>
      <div class="flex justify-center">
        <router-link
          v-if="currentRoute !== '/funds'"
          to="/funds"
          class="summary-link flex-col-reverse"
          >Manage funds</router-link
        >
        <router-link v-else to="/profile" class="summary-link"
          >Back to Profile</router-link
        >
        <router-link
          v-if="currentRoute !== '/transactions'"
          to="/transactions"
          class="summary-link"
          >Manage Transactions</router-link
        >
        <router-link v-else to="/profile" class="summary-link flex-col-reverse"
          >Back to Profile</router-link
        >
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import { useRoute } from "vue-router";

const portfolioStore = usePortfolioStore();

const route = useRoute();
const currentRoute = computed(() => route.path);

const balance = computed(() => portfolioStore.balance);
const totalMoneyInvested = computed(() => portfolioStore.totalMoneyInvested);
const unrealizedMoney = computed(() => portfolioStore.unrealizedMoney);
const realizedGains = computed(() => portfolioStore.netProfitLoss);

onMounted(async () => {
  try {
    await portfolioStore.getPortfolio();
  } catch (error) {
    console.error("Error fetching funds:", error);
  }
});
</script>
<style scoped>
.summary-link {
  @apply text-blue-600 dark:text-blue-500 hover:text-lime-500 dark:hover:text-lime-400
  px-4 pl-8 mt-2 font-medium text-lg;
}
</style>
