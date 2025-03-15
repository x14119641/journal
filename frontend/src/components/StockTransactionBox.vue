<template>
  <div class="p-6 text-center">
    <h3 class="title-component">
      TransactionID: <span class="chart-title">{{ transactionId }}</span>
    </h3>
    <h2 class="mt-2 subtitle-component">
      <span>Stock: </span
      ><router-link
        :to="`/stocks/${transactionIdData?.ticker}`"
        class="ticker-link"
        >{{ transactionIdData?.ticker }}</router-link
      >
    </h2>

    <div class="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2">
      <div class="flex justify-between items-center ">
        <label for="ticker" class="text-label">Price</label>
        <span class="text-value">{{ transactionIdData.price }}</span>
      </div>
      <div class="flex justify-between items-center ">
        <label for="ticker" class="text-label">Quantity</label>
        <span class="text-value">{{ transactionIdData.quantity }}</span>
      </div>
      <div class="flex justify-between items-center">
        <label for="ticker" class="text-label">Type</label>
        <span class="text-value">{{
          transactionIdData.transactionType
        }}</span>
      </div>
      <div class="flex justify-between items-center ">
        <label for="ticker" class="text-label">Fee</label>
        <span class="text-value">{{ transactionIdData.fee }}</span>
      </div>
      <div class="flex justify-between items-center ">
        <label for="ticker" class="text-label">ProfitLoss</label>
        <span class="text-value">{{ transactionIdData.realizedProfitLoss }}</span>
      </div>
      <div class="flex justify-between items-center">
        <label for="ticker" class="text-label">Created</label>
        <span class="text-value">{{ transactionIdData.created_at }}</span>
      </div>
    </div>
    <!-- ONe row with details -->
    <div class="mt-6 flex justify-start gap-12">
      <label for="ticker" class="text-label">Details</label>
      <span class="text-value">{{ transactionIdData.details }}</span>
    </div>

    <form @submit.prevent="updateDetails" class="mt-6 justify-center">
      <div>
        <label for="details" class="text-label">Modify Details</label>
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
        <label for="" class="invisible text-label">bla</label>
        <button type="submit" class="mt-4 w-full button-blue">
          Update Details
        </button>
      </div>
    </form>

    <form @submit.prevent="deleteTransaction" class="mt-6 justify-center">
      <div>
        <label for="reason" class="text-label">Reason</label>
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
        <label for="" class="invisible text-value">bla</label>
        <button type="submit" class="mt-4 w-full button-delete">
          Try To Delete
        </button>
      </div>
    </form>
  </div>
  <div class="pb-4 text-center">
    <p v-if="returnUpdateMessage" :class="returnUpdateMessage?.includes('Success') ? 'success-message-text' : 'error-message-text'">
      {{ returnUpdateMessage }}
    </p>
    <p v-if="returnDeleteMessage" :class="returnDeleteMessage?.includes('Success') ? 'success-message-text' : 'error-message-text'">
      {{ returnDeleteMessage }}
    </p>
    <p v-if="errorMessage" class="error-message-text">{{ errorMessage }}</p>
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
    console.log("BLA: ", transactionIdData.value)
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

<style scoped>
.ticker-link{
  @apply font-medium text-blue-600 dark:text-blue-500 hover:text-lime-500 dark:hover:text-lime-400;
}
</style>
