<template>
  <div class="p-6 text-center">
    <h3 class="summary-title">User Balance</h3>
    <div class="mt-2 space-y-2"> 
      <div class="flex justify-between">
        <span class="summary-label">Balance</span>
        <span class="account-value-style">{{ balance }}</span>
      </div>
      <div class="flex justify-between">
        <span class="summary-label">Money Invested</span>
        <span class="summary-value text-negative-style">{{ totalMoneyInvested }}</span>
      </div>
      <div class="flex justify-between">
        <span class="summary-label">unrealizedMoney</span>
        <span class="summary-value money-positive-style">{{ unrealizedMoney }}</span>
      </div>
      <div class="flex justify-between">
        <span class="summary-label">Realized Gains</span>
        <span
          :class="
            realizedGains >= 0
              ? 'summary-value money-positive-style'
              : 'summary-value money-negative-style' 
          "
          >{{ realizedGains }}</span
        >
      </div>
      <div class="flex justify-center">
        <router-link
          v-if="currentRoute !== '/funds'"
          to="/funds"
          class="summary-link summary-link-separation flex-col-reverse"
          >Manage funds</router-link
        >
        <router-link v-else to="/profile" class="summary-link summary-link-separation"
          >Back to Profile</router-link
        >
        <router-link
          v-if="currentRoute !== '/transactions'"
          to="/transactions"
          class="summary-link summary-link-separation "
          >Manage Transactions</router-link
        >
        <router-link v-else to="/profile" class="summary-link summary-link-separation flex-col-reverse"
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
