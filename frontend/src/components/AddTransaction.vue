<template>
    <div class="p-6 text-white">
      <form @submit.prevent="onSubmit" class="flex flex-wrap gap-4 items-end">
        <!-- Ticker -->
        <div class="flex-1">
          <label for="ticker" class="block text-sm font-medium">Ticker:</label>
          <input 
            type="text" 
            id="ticker" 
            v-model="ticker" 
            placeholder="Enter ticker" 
            required
            class="w-full bg-gray-400 p-2 border border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-lime-400" />
        </div>
  
        <!-- Price -->
        <div class="flex-1 min-w-[100px]">
          <label for="price" class="block text-sm font-medium">Price:</label>
          <input 
            id="price"
            type="number" 
            v-model="price" 
            placeholder="Enter price" 
            step="0.01" 
            required 
            class="w-full bg-gray-400 p-2 border border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-lime-400" />
        </div>
  
        <!-- Quantity -->
        <div class="flex-1 min-w-[100px]">
          <label for="quantity" class="block text-sm font-medium">Quantity:</label>
          <input 
            type="number" 
            id="quantity" 
            v-model="quantity" 
            placeholder="Enter quantity" 
            required min="0"
            class="w-full bg-gray-400 p-2 border border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-lime-400" />
        </div>
  
        <!-- Transaction Type -->
        <div class="flex-1 min-w-[100px]">
          <label for="transaction_type" class="block text-sm font-medium">Transaction Type:</label>
          <select 
            id="transaction_type" 
            v-model="transaction_type" 
            required
            class="w-full bg-gray-400 p-2 border border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-lime-400">
            <option value="buy">Buy</option>
            <option value="sell">Sell</option>
          </select>
        </div>
  
        <!-- Fee -->
        <div class="flex-1 min-w-[100px]">
          <label for="fee" class="block text-sm font-medium">Fee:</label>
          <input 
            type="number" 
            id="fee" 
            v-model="fee" 
            placeholder="Enter fee" 
            required min="2"
            class="w-full bg-gray-400 p-2 border border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-lime-400" />
        </div>
  
        <!-- Submit Button -->
        <div class="min-w-[100px]">
          <button
            type="submit"
            :class="{
              'bg-lime-400 hover:bg-lime-500': transaction_type === 'buy',
              'bg-red-500 hover:bg-red-600': transaction_type === 'sell'
            }"
            class="text-white py-2 px-4 rounded focus:outline-none focus:ring-2 focus:ring-lime-400">
            Submit
          </button>
        </div>
      </form>
      <p v-if="errorMessage" class="mt-4 text-red-500">{{ errorMessage }}</p>
    </div>
  </template>

<script setup lang="ts">
import { ref } from 'vue';
import { useTransactionsStore } from '../stores/transactionsStore';


const ticker = ref<string>("");
const price = ref<number | null>(null);
const quantity = ref<number | null>(null);
const transaction_type = ref<string>("buy");
const fee = ref<number>(2); // Default fee = 2
const errorMessage =ref<string>("");

const transactionsStore = useTransactionsStore();

const onSubmit = async () => {
    errorMessage.value = "";
    // check iff all filters are set
    if(ticker.value && price.value !== null && quantity.value !== null && transaction_type.value) {
        try {
            await transactionsStore.addTransaction({
                ticker: ticker.value.toUpperCase(),
                price: price.value,
                quantity: quantity.value,
                transaction_type: transaction_type.value,
                fee: fee.value,
            });
            errorMessage.value = transactionsStore.transaction_message_return
        } catch (error) {
            if (error.response) {
                if (error.response.status === 404) {
                errorMessage.value = "Resource not found.";
                } else if (error.response.status === 401) {
                errorMessage.value = "Unauthorized. Please log in again.";
                } else {
                errorMessage.value = "An unexpected error occurred.";
                }
            } else {
                errorMessage.value = "Network error or server not responding.";
            }
            console.error(error);
        }
    } else {
        errorMessage.value = "All fields are required"
    }
}
</script>