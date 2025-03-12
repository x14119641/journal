<template>
  <div class="p-6 text-center">
    <h3 class="summary-title">
      TransactionID: <span class="chart-title">{{ transactionId }}</span>
    </h3>
    <h2 class="mt-2 summary-subtitle">
      {{ "Balance Transaction" }}
    </h2>

    <div class="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2">
      <div class="flex justify-between items-center">
        <label for="ticker" class="summary-label">Quantity</label>
        <span class="summary-value">{{ transactionIdData.quantity }}</span>
      </div>
      <div class="flex justify-between items-center">
        <label for="ticker" class="summary-label">Type</label>
        <span class="summary-value">{{
          transactionIdData.transactionType
        }}</span>
      </div>
    </div>
    <div class="mt-4 flex justify-start gap-12">
      <label for="ticker" class="summary-label">Created</label>
      <span class="summary-value">{{ transactionIdData.created_at }}</span>
    </div>
    <!-- ONe row with details -->
    <div class="mt-4 flex justify-start gap-12">
      <label for="ticker" class="summary-label">Details</label>
      <span class="summary-value">{{ transactionIdData.details }}</span>
    </div>

    <!-- Modify Details -->
    <form @submit.prevent="updateDetails" class="mt-6 justify-center">
      <div>
        <label for="details" class="summary-value">Modify Details</label>
        <textarea
          id="details"
          type="text"
          v-model="details"
          class="input-style"
          required
          :placeholder="
            transactionIdData
              ? `Details: ${transactionIdData.details}`
              : 'Loading..'
          "
          @input="autoExpand"
        ></textarea>
      </div>
      <div class="">
        <label for="" class="invisible summary-value">bla</label>
        <button type="submit" class="update-transaction-button-style">
          Update Details
        </button>
      </div>
    </form>
    <form @submit.prevent="deleteTransaction" class="mt-6 justify-center">
      <div>
        <label for="reason" class="summary-value">Reason</label>
        <textarea
          id="reason"
          type="text"
          v-model="reason"
          class="input-style"
          placeholder="Reason to try to delete"
          @input="autoExpand"
          required
        ></textarea>
      </div>
      <div class="">
        <label for="" class="invisible summary-value">bla</label>
        <button type="submit" class="delete-transaction-button-style">
          Try To Delete
        </button>
      </div>
    </form>
    <div class="pb-4 text-center">
      <p v-if="returnUpdateMessage" :class="returnUpdateMessage.includes('Success') ? 'success-message-text' : 'error-message-text'">
        {{ returnUpdateMessage }}
      </p>
      <p v-if="returnDeleteMessage" :class="returnDeleteMessage?.includes('Success') ? 'success-message-text' : 'error-message-text'">
        {{ returnDeleteMessage }}
      </p>
      <p v-if="errorMessage" class="error-message-text">{{ errorMessage }}</p>
    </div>
  </div>
</template>
<script setup lang="ts">
import { computed, onMounted, ref, watch } from "vue";
import { useRoute } from "vue-router";
import { useTransactionsStore } from "../stores/transactionsStore";

import type {
  DeleteTransaction,
  UpdateTransactionDetails,
} from "../models/models";

const autoExpand = (event: Event) => {
  const textarea = event.target as HTMLTextAreaElement;
  textarea.style.height = "auto"; // Reset height
  textarea.style.height = `${textarea.scrollHeight}px`; // Adjust height
};
const route = useRoute();
const transactionId = computed(() => route.params.id as string);
const errorMessage = ref<string>("");
const details = ref<string>("");
const reason = ref<string>("");
const transactionsStore = useTransactionsStore();
const transactionIdData = computed(() => transactionsStore.transaction_detail);
const returnUpdateMessage = computed(
  () => transactionsStore.updateDetailsMessage
);
const returnDeleteMessage = computed(() => transactionsStore.deleteMessage);

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

const updateDetails = async () => {
  errorMessage.value = "";
  if (!details) {
    errorMessage.value = "Add some details in this transaction";
    return;
  }

  try {
    const updateTransactionDetailsData: UpdateTransactionDetails = {
      transaction_id: Number(transactionId.value),
      details: details.value,
    };
    await transactionsStore.updateTransactionDetails(
      updateTransactionDetailsData
    );
    await fetchTransactionById();
  } catch (error) {
    console.log(error);
    errorMessage.value = "Error. Impossible to update";
  }
};

const deleteTransaction = async () => {
  errorMessage.value = "";

  try {
    const deleteTransactionDetailsData: DeleteTransaction = {
      transaction_id: Number(transactionId.value),
      transaction_type: transactionIdData.value.transactionType,
      reason: reason.value,
    };
    await transactionsStore.deleteTransaction(deleteTransactionDetailsData);
    await fetchTransactionById();
  } catch (error) {
    console.log(error);
    errorMessage.value = "Error. Impossible to delete";
  }
};

onMounted(() => {
  transactionsStore.updateDetailsMessage = "";
  transactionsStore.deleteMessage = "";
  errorMessage.value = "";
  fetchTransactionById();
});

watch(transactionId, () => {
  fetchTransactionById();
});
</script>
