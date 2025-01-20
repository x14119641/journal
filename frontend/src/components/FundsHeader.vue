<template>
  <div class="text-center">
    <h3 class="text-xl text-gray-200">User Funds</h3>
    <div class="mt-4">
      <div class="flex justify-between">
        <span class="font-medium text-gray-400">Total Funds</span>
        <span class="text-green-200">{{ totalFunds }}</span>
      </div>
      <div class="flex justify-between mt-2">
        <span class="font-medium text-gray-400">Total Spent</span>
        <span class="text-red-200">{{ totalSpent }}</span>
      </div>
      <div class="flex justify-between mt-2">
        <span class="font-medium text-gray-400">Available Funds</span>
        <span class="text-blue-200">{{ availableFunds }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import { useAuthStore } from "../stores/authStore";

const portfolioStore = usePortfolioStore();
const authStore = useAuthStore();

const totalFunds = computed(() => portfolioStore.total_funds);
const totalSpent = computed(() => portfolioStore.total_spent);
const availableFunds = computed(() => portfolioStore.available_funds);

onMounted(async () => {
  if (authStore.token) {
    try {
      await portfolioStore.getFunds();
    } catch (error) {
      console.error("Error fetching funds:", error);
    }
  }
  console.error("No token found, user is not authenticated.");
});
</script>
