<template>
  <div class="p-6 text-center">
    <h3 class="summary-title">User Balance</h3>
    <div class="mt-2 space-y-2">
      <div class="flex justify-between">
        <span class="summary-label">Account Value</span>
        <span class="account-value-style">{{ accountValue }}</span>
      </div>
      <div class="flex justify-between">
        <span class="summary-label">Positions</span>
        <span class="summary-value money-negative-style">{{ totalSpent }}</span>
      </div>
      <div class="flex justify-between">
        <span class="summary-label">Cash</span>
        <span class="summary-value money-positive-style">{{ cash }}</span>
      </div>
      <div class="flex justify-between">
        <span class="summary-label">Realized Gains</span>
        <span
          :class="
            realizedGains >= 0
              ? 'summary-value money-positive-style'
              : 'summary-value money-positive-style'
          "
          >{{ realizedGains }}</span
        >
      </div>
      <div class="flex justify-center">
        <router-link
          v-if="currentRoute !== '/funds'"
          to="/funds"
          class="summary-link"
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
        <router-link v-else to="/profile" class="summary-link"
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

const accountValue = computed(() => portfolioStore.accountValue);
const totalSpent = computed(() => portfolioStore.total_spent);
const cash = computed(() => portfolioStore.cash);
const realizedGains = computed(() => portfolioStore.realized_gains);

onMounted(async () => {
  try {
    await portfolioStore.getFundsTotals();
  } catch (error) {
    console.error("Error fetching funds:", error);
  }
});
</script>
