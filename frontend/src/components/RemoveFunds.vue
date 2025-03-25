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
        placeholder="Select amount to Withdraw"
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
          class="button-delete w-28 "
        >
          Withdraw
        </button>
      </div>
    </div>
  </form>
    <p v-if="errorMessage" class="mt-4 text-error">{{ errorMessage }}</p>
  </div>
</template>

<script setup lang="ts">
import {  ref } from "vue";
import { useTransactionsStore } from "../stores/transactionsStore";
import SelectDateComponent from "./SelectDateComponent.vue";
import Decimal from "decimal.js";
import type { FundsTransaction } from "../models/models";

const amount = ref<number | null>(null);
const selectedDate = ref<string>("");
const errorMessage = ref<string>("");
const description = ref<string>("");
const transactionStore = useTransactionsStore();

const onSubmit = async () => {
  errorMessage.value = "";
  if (!amount.value || amount.value <= 0) {
    errorMessage.value = "Amount must be greater than 0";
    return;
  }

  try {
    if (selectedDate.value === "") {
      selectedDate.value = new Date().toISOString().slice(0, 19).replace("T", " ");
    }
    if (description.value === "") {
      description.value = "WITHDRAW";
    }
    const parseSelectedDate = (dateString: string) => {
        const [day, month, year, time] = dateString.split(/[- ]/);
        return new Date(`${year}-${month}-${day}T${time}`);
      };
      const dateObject = parseSelectedDate(selectedDate.value);
    const decimalAmount = new Decimal(Number(amount.value));
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
    await transactionStore.withdrawFunds(transactionData);

    console.log("Funds Withdhrew successfully!");
    selectedDate.value = ""
  } catch (error: any) {
    console.log(error);
    if (error.response) {
      const errorDetail =
        error.response.data?.detail || "An unexpected error occurred.";

      // Handle "Insufficient funds" error specifically
      if (errorDetail.includes("Insufficient funds")) {
        errorMessage.value =
          "You do not have enough balance to complete this withdrawal.";
      } else {
        errorMessage.value = errorDetail; // Display any other backend error
      }
    } else {
      errorMessage.value = "Network error or server not responding.";
    }
  }
};

const submitForm = () => {
  console.log("Amount:", amount.value);
  console.log("Selected Date:", selectedDate.value);
  console.log("description:", description.value);
};
</script>
<style></style>
