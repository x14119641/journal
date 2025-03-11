<template>
  <div class="flex justify-center w-full transition-all">
    
    <div
      class="slate-container-login w-full mr-12 sm:w-96 md:w-2/3 lg:w-1/2 xl:w-1/3"
    >
      <div class="p-6 text-center">
        
        <h3 class="summary-title">
          TransactionID: <span class="chart-title">{{ transactionId }}</span>
        </h3>
        <h2 class="mt-2 summary-subtitle">
          {{
            transactionIdData.ticker
              ? `Stock ${transactionIdData?.ticker}`
              : "Balance Transaction !"
          }}
        </h2>

          <form @submit.prevent="" class="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div class="">
            <label for="ticker" class="summary-value">Price</label>
            <input
              id="price"
              step="0.01"
              type="number"
              v-model="price"
              min="0"
              class="input-style"
              :placeholder="
                transactionIdData
                  ? `Default Price: ${transactionIdData.price}`
                  : 'Loading..'
              "
            />
          </div>
          <div class="">
            <label for="quantity" class="summary-value">Quantity</label>
            <input
              id="quantity"
              step="0.01"
              type="number"
              v-model="quantity"
              min="0"
              class="input-style"
              :placeholder="
                transactionIdData
                  ? `Default Quantity: ${transactionIdData.quantity}`
                  : 'Loading..'
              "
            />
          </div>
          <div class="">
            <label for="transactionType" class="summary-value">Type</label>
            <input
              id="text"
              type="text"
              v-model="transactionType"
              class="input-style"
              :placeholder="
                transactionIdData
                  ? `Type: ${transactionIdData.transactionType}`
                  : 'Loading..'
              "
            />
          </div>
          <div class="">
            <label for="fee" class="summary-value">Fee</label>
            <input
              id="text"
              type="text"
              v-model="fee"
              class="input-style"
              :placeholder="
                transactionIdData
                  ? `Fee: ${transactionIdData.fee}`
                  : 'Loading..'
              "
            />
          </div>
          <div class="">
            <label for="details" class="summary-value">Details</label>
            <input
              id="details"
              type="text"
              v-model="details"
              class="input-style"
              :placeholder="
                transactionIdData
                  ? `Details: ${transactionIdData.details}`
                  : 'Loading..'
              "
            />
          </div>
          <div class="">
            <label for="custom-datetime" class="summary-value"
              >Select Date</label
            >
            <input
              type="text"
              v-model="selectedDate"
              id="custom-datetime"
              class="input-style"
              :placeholder="
                transactionIdData
                  ? `Date: ${transactionIdData.created_at}`
                  : 'Loading..'
              "
            />
          </div>
          <div class="mt-2">
            <button type="submit" class="update-transaction-button-style">Update</button>
          </div>
          <div class="mt-2">
            <button type="submit" class="delete-transaction-button-style">Delete</button>
          </div>
        </form>
  
        
      </div>
      <p>{{ transactionIdData }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, ref, watch } from "vue";
import { useRoute } from "vue-router";
import { useTransactionsStore } from "../stores/transactionsStore";
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css"; 


const route = useRoute();
const transactionId = computed(() => route.params.id as string);
const errorMessage = ref<string>("");
const transactionsStore = useTransactionsStore();
const transactionIdData = computed(() => transactionsStore.transaction_detail);
const selectedDate = ref<string>("");

const fetchTransactionById = async () => {
  if (!transactionId.value) return;
  if (isNaN(Number(transactionId.value))) {
    errorMessage.value = "Id dont fit the format number";
  }
  try {
    await transactionsStore.getTransactionById(Number(transactionId.value));
  } catch (error) {
    console.log("Error Getting transaction by id");
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
fetchTransactionById();

watch(transactionId, () => {
  fetchTransactionById();
});
</script>
