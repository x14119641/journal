<template>
  <div class="">
    <form @submit.prevent="onSubmit" class="flex flex-col md:flex-row items-center space-y-4 md:space-y-0 md:space-x-4">
      <div class="flex-grow">
        <input
          type="number"
          id="amount"
          v-model="amount"
          placeholder="Withdraw Funds Amount"
          required
          min="0"
          class="w-full bg-gray-400 p-3 border border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-red-400"
        />
      </div>
      <button
        type="submit"
        class="min-w-32 bg-red-400 text-white py-2 px-4 rounded hover:bg-red-500 focus:outline-none focus:ring-2 focus:ring-red-400"
      >
        Withdraw
      </button>
    </form>
    <p v-if="errorMessage" class="mt-4 text-red-500">{{ errorMessage }}</p>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";

const amount = ref<number | null>(null);
const errorMessage = ref<string>("");
const portfolioStore = usePortfolioStore();

const onSubmit = async () => {
  errorMessage.value = "";
  if (amount.value > 0) {
    try {
      await portfolioStore.removeFunds(amount.value); 
    } catch (error) {
      if (error.response) {
        if (error.response.status === 404) {
          errorMessage.value = "Resource not found.";
        } else if (error.response.status === 401) {
          errorMessage.value = "Unauthorized. Please log in again.";
        } else if (error.response.status === 403) {
          errorMessage.value = "Not enough funds";
        }
         else {
          errorMessage.value = "An unexpected error occurred.";
        }
      } else {
        errorMessage.value = "Network error or server not responding.";
      }
      console.error(error);
    }
  } else {
    errorMessage.value = "Amount must be greater than zero.";
  }
};
</script>
