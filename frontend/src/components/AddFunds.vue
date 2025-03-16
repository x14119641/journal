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
    <div class="flex   flex-col xs:flex-row items-center space-x-2">
      <!-- Date Input -->
      <!-- <label for="custom-datetime" class="summary-value">Select Date</label> -->
      <SelectDateComponent v-model="selectedDate"/>
    </div>
    <div class="flex   flex-col xs:flex-row items-center space-x-2">
      <!-- description Input -->
      <!-- <label for="description" class="summary-value">Description</label> -->
      <input
        id="description"
        type="text"
        v-model="description"
        min="0"
        placeholder="Type:Deposit"
        class="input-style"
      />
    </div>
    <div
      class="flex flex-col space-x-2 items-center justify-center md:justify-end"
    >
      <div class="mt-4 md:mt-0 md:ml-4">
        <button
          type="submit"
          class="button-add w-28"
        >
          Deposit
        </button>
      </div>
    </div>
  </form>
    <p v-if="errorMessage" class="mt-4 text-error">{{ errorMessage }}</p>
  </div>
</template>

<script setup lang="ts">
import {  onMounted, nextTick, ref } from "vue";
import { useTransactionsStore } from "../stores/transactionsStore";
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css"; 
import Decimal from "decimal.js";
import type { FundsTransaction } from "../models/models";
import SelectDateComponent from "./SelectDateComponent.vue";


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
    if (selectedDate.value ==="") {selectedDate.value = new Date().toISOString().slice(0, 19).replace("T", " ")}
    if (description.value ==="") {description.value = "DEPOSIT"}
    // Convert selectedDate (string) into a Date object or add today
    const parseSelectedDate = (dateString: string) => {
      const [day, month, year, time] = dateString.split(/[- ]/);
      return new Date(`${year}-${month}-${day}T${time}`);
    };
    const dateObject = parseSelectedDate(selectedDate.value);
    console.log(dateObject)
    // Ensure the date is valid
    // if (isNaN(dateObject.getTime())) {
    //   errorMessage.value = "Invalid date format.";
    //   return;
    // }

    const transactionData: FundsTransaction = {
      amount: decimalAmount,
      description: description.value,
      created_at: dateObject,
    };

    // Send to API
    await transactionStore.addFunds(transactionData);

    console.log("Funds added successfully!");
    selectedDate.value = ""
  } catch (error) {
    console.log("Error")
    console.error(error);
    
  }
};


const submitForm = () => {
  console.log("Amount:", amount.value);
  console.log("Selected Date:", selectedDate.value);
  console.log("description:", description.value);
};
</script>
<style>

</style>