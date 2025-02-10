<template>
  <div class="p-6 text-center">
    <h3 class="text-xl text-gray-200">User Balance</h3>

      <div class="flex justify-between">
        <span class="font-medium text-gray-400">Account Value</span>
        <span class="text-green-400">{{ accountValue }}</span>
      </div>
      <div class="flex justify-between mt-2">
        <span class="font-medium text-gray-400">Positions</span>
        <span class="text-green-400">{{ totalSpent }}</span>
      </div>
      <div class="flex justify-between mt-2">
        <span class="font-medium text-gray-400">Cash</span>
        <span class="text-green-200">{{ cash }}</span>
      </div>
      <div class="flex justify-between mt-2">
        <span class="font-medium text-gray-400">Realized Gains</span>
        <span :class="realizedGains >= 0 ? 'text-green-400' : 'text-red-400'">{{ realizedGains }}</span>
      </div>
      <div class="flex justify-center mt-2">
        <RouterLink v-if="currentRoute!=='/funds'" to="/funds" class="font-medium text-blue-500 px-4 py-2 m-2">Manage funds</RouterLink>
        <RouterLink v-if="currentRoute!=='/transactions'" to="/transactions" class="font-medium text-blue-500 px-4 py-2 m-2">Manage Transactions</RouterLink>
      </div>
    </div>

</template>

<script setup lang="ts">
import { computed, onMounted } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import { RouterLink, useRoute } from "vue-router";

const portfolioStore = usePortfolioStore();

const route = useRoute();
const currentRoute = computed(() => route.path)

const accountValue = computed(() => portfolioStore.accountValue);
const totalSpent = computed(() => portfolioStore.total_spent);
const cash = computed(() => portfolioStore.cash);
const realizedGains = computed(() => portfolioStore.realized_gains);


onMounted(async () => {

    try {
      await portfolioStore.getFunds();
    } catch (error) {
      console.error("Error fetching funds:", error);
    }

});
</script>
