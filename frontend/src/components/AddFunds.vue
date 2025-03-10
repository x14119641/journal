<template> 
  <div class="p-6">
    <form
    @submit.prevent="onSubmit"
    class="flex flex-col md:flex-row justify-center space-y-4 md:space-y-0 md:space-x-4"
  >
    <div class="flex flex-grow flex-col xs:flex-row items-center space-x-2">
      <!-- Amount Input -->
      <!-- <label for="amount" class="summary-value">Amount</label> -->
      <input
        id="amount"
        step="0.01"
        type="number"
        v-model="amount"
        min="0"
        required
        class="input-style"
        placeholder="Select amount to Deposit"
      />
    </div>
    <div class="flex flex-col xs:flex-row items-center space-x-2">
      <!-- Date Input -->
      <!-- <label for="custom-datetime" class="summary-value">Select Date</label> -->
      <input
        type="text"
        v-model="selectedDate"
        id="custom-datetime"
        class="input-style"
        placeholder="DD-MM-YYYY HH:mm:ss"
      />
    </div>
    <div class="flex flex-col xs:flex-row items-center space-x-2">
      <!-- description Input -->
      <!-- <label for="description" class="summary-value">Description</label> -->
      <input
        id="description"
        type="text"
        v-model="description"
        min="0"
        placeholder="default:Deposit"
        class="input-style"
      />
    </div>
    <div
      class="flex flex-col space-x-2 items-center justify-center md:justify-end"
    >
      <div class="mt-4 md:mt-0 md:ml-4">
        <button
          type="submit"
          class="deposit-funds-button-style"
        >
          Deposit
        </button>
      </div>
    </div>
  </form>
    <p v-if="errorMessage" class="mt-4 text-center  text-red-500">{{ errorMessage }}</p>
  </div>
</template>

<script setup lang="ts">
import {  onMounted, nextTick, ref } from "vue";
import { useTransactionsStore } from "../stores/transactionsStore";
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css"; 
import Decimal from "decimal.js";
import type { FundsTransaction } from "../models/models";


const amount = ref<number | null>(null);
const selectedDate = ref<string>("");
const errorMessage = ref<string>("");
const description = ref<string>("");
const transactionStore = useTransactionsStore();

const onSubmit = async () => {
  errorMessage.value = "";
  if(!amount.value || amount.value <=0) {
    errorMessage.value = "Amount must be greater than 0"
    return
  }

  try {
    const decimalAmount = new Decimal(Number(amount.value));
    if (selectedDate.value ==="") {selectedDate.value = new Date().toString()}
    if (description.value ==="") {description.value = "DEPOSIT"}
    // Convert selectedDate (string) into a Date object or add today
    const dateObject = new Date(selectedDate.value);
    console.log(dateObject)
    // Ensure the date is valid
    if (isNaN(dateObject.getTime())) {
      errorMessage.value = "Invalid date format.";
      return;
    }

    const transactionData: FundsTransaction = {
      amount: decimalAmount,
      description: description.value,
      created_at: dateObject,
    };

    // Send to API
    await transactionStore.addFunds(transactionData);

    console.log("Funds added successfully!");
  } catch (error) {
    console.log("Error")
    console.error(error);
    
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

const submitForm = () => {
  console.log("Amount:", amount.value);
  console.log("Selected Date:", selectedDate.value);
  console.log("description:", description.value);
};
</script>
<style>

</style>