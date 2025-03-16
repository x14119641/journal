<template>
    <div class="p-6">
      <form
        @submit.prevent="onSubmit"
        class="flex flex-col md:flex-row justify-center space-y-4 md:space-y-0 md:space-x-4"
      >
        <!-- Ticker -->
        <div class="felx flex-grow flex-col xs:flex-row items-center space-x-2">
          <!-- <label for="ticker" class="block text-sm font-medium">Ticker:</label> -->
          <input
            type="text"
            id="ticker"
            v-model="ticker"
            placeholder="Enter ticker"
            required
            class="input-style"
          />
        </div>
        <!-- Price -->
        <div class="felx flex-grow flex-col xs:flex-row items-center space-x-2">
          <!-- <label for="ticker" class="block text-sm font-medium">Ticker:</label> -->
          <input
            id="price"
            step="0.01"
            type="number"
            v-model="price"
            placeholder="Buy price:"
            required
            class="input-style"
          />
        </div>
        <!-- quantity Input -->
        <div class="felx flex-grow flex-col xs:flex-row items-center space-x-2">
          <!-- <label for="amount" class="summary-value">Amount</label> -->
          <input
            id="quantity"
            step="0.01"
            type="number"
            v-model="quantity"
            min="0"
            required
            class="input-style"
            placeholder="Select quantity"
          />
        </div>
        <!-- Fee -->
        <div class="flex flex-col xs:flex-row items-center space-x-2">
          <!-- <label for="fee" class="block text-sm font-medium">Fee:</label> -->
          <input
            type="number"
            id="fee"
            step="0.01"
            v-model="fee"
            placeholder="Fee: default(2)"
            class="input-style"
          />
        </div>
  
        <!-- Date Input -->
        <div class="flex flex-col xs:flex-row items-center space-x-2">
          <!-- <label for="custom-datetime" class="summary-value">Select Date</label> -->
          <input
            type="text"
            v-model="selectedDate"
            id="custom-datetime"
            class="input-style w-full"
            placeholder="DD-MM-YYYY HH:mm:ss"
          />
        </div>
        <!-- Button -->
        <div class="flex flex-col space-x-2 items-center justify-center">
          <div class="mt-4 md:mt-0 md:ml-4">
            <button type="submit" class="w-24 button-add">
              Buy
            </button>
          </div>
        </div>
      </form>
      <p v-if="errorMessage" class="mt-4 text-center text-error">
        {{ errorMessage }}
      </p>
      <p v-if="successMessage" class="mt-4 text-center text-info">
        {{ successMessage }}
      </p>
    </div>
  </template>
  
  <script setup lang="ts">
  import { onMounted, nextTick, ref } from "vue";
  import flatpickr from "flatpickr";
  import "flatpickr/dist/flatpickr.min.css";
  import Decimal from "decimal.js";
  import type { BuyStockTransaction } from "../models/models";
  import { useTransactionsStore } from "../stores/transactionsStore";
  
  const quantity = ref<number | null>(null);
  const ticker = ref<string | null>(null);
  const price = ref<number | null>(null);
  
  const fee = ref<number | null>(null);
  const selectedDate = ref<string>("");
  const errorMessage = ref<string>("");
  const successMessage = ref<string>("");
  const transactionStore = useTransactionsStore();
  

  const parseSelectedDate = (dateString: string) => {
  const [day, month, year, hours, minutes, seconds] = dateString.split(/[- :]/);
  return new Date(`${year}-${month}-${day}T${hours}:${minutes}:${seconds}`);
};

  const onSubmit = async () => {
    errorMessage.value = "";
    if (!quantity.value || quantity.value <= 0) {
      errorMessage.value = "Quantity must be greater than 0";
      return;
    }
    if (!ticker.value) {
      errorMessage.value = "No ticker!";
      return;
    }
    if (!price.value || price.value <= 0) {
      errorMessage.value = "Price must be greater than 0";
      return;
    }
    if (fee.value === null) {
      fee.value = 2;
    }
    // if (fee.value <= 0) {
    //   errorMessage.value = "Fee must be greater than 0";
    //   return;
    // }
    if (selectedDate.value === "") {
      selectedDate.value = new Date().toISOString().slice(0, 19).replace("T", " ");
    }
    try {
      const dateObject = parseSelectedDate(selectedDate.value);
      //   const decimalAmount = new Decimal(Number(amount.value));
      // Ensure the date is valid
      // if (isNaN(dateObject.getTime())) {
      //   errorMessage.value = "Invalid date format.";
      //   return;
      // }
      const transactionData: BuyStockTransaction = {
        ticker: ticker.value.toUpperCase(),
        buy_price: new Decimal(Number(price.value)),
        quantity: new Decimal(Number(quantity.value)),
        fee: new Decimal(Number(fee.value)),
        created_at: dateObject,
      };
  
      // Send to API
      await transactionStore.buyStock(transactionData);
      successMessage.value = transactionStore.transaction_message_return
      console.log("Stock Bought!");
    } catch (error: any) {
      if (error.response) {
        const errorDetail =
          error.response.data?.detail || "An unexpected error occurred.";
  
        // Handle Errors from backend
        if (errorDetail.includes("available")) {
          errorMessage.value =
            "No shares available to sell";
        } else {
          errorMessage.value = errorDetail; // Display any other backend error
        }
      } else {
        errorMessage.value = "Network error or server not responding.";
      }
    }
  };
  
  onMounted(async () => {
    await nextTick(); // Ensure DOM is ready before applying Flatpickr
  
    flatpickr("#custom-datetime", {
      enableTime: true,
      enableSeconds: true,
      dateFormat: "d-m-Y H:i:S",
      allowInput: true,
      time_24hr: true,
      defaultHour: 12,
      defaultMinute: 0,
      defaultSeconds: 0,
    });
  });
  </script>
  