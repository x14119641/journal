<template>
  <div class="p-6 text-center">
    <h3 class="title-component">
      TransactionID: <span class="chart-title">{{ transactionId }}</span>
    </h3>
    <h2 class="mt-2 subtitle-component">
      Balance Transaction
    </h2>

    <div class="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2">
      <div class="flex justify-between items-center">
        <label for="ticker" class="text-label">Quantity</label>
        <span class="text-value">{{ transactionIdData.quantity }}</span>
      </div>
      <div class="flex justify-between items-center">
        <label for="ticker" class="text-label">Type</label>
        <span class="text-value">{{
          transactionIdData.transactionType
        }}</span>
      </div>
    </div>
    <div class="mt-4 flex justify-start gap-12">
      <label for="ticker" class="text-label">Created</label>
      <span class="text-value">{{ transactionIdData.created_at }}</span>
    </div>
    <!-- ONe row with description -->
    <div class="mt-4 flex justify-start gap-12">
      <label for="ticker" class="text-label">Description</label>
      <span class="text-value">{{ transactionIdData.description }}</span>
    </div>

    <!-- Modify description -->
    <form @submit.prevent="updateDescription" class="mt-6 justify-center">
      <div>
        <label for="description" class="text-label">Modify Description</label>
        <textarea
          id="description"
          type="text"
          v-model="description"
          class="input-style"
          required
          :placeholder="
            transactionIdData
              ? `Description: ${transactionIdData.description}`
              : 'Loading..'
          "
          @input="autoExpand"
        ></textarea>
      </div>
      <div class="">
        <label for="" class="invisible text-label">bla</label>
        <button type="submit" class="mt-4 w-full button-blue">
          Update Description
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
        <label for="" class="invisible text-label">bla</label>
        <button type="submit" class="mt-4 w-full button-delete">
          Try To Delete
        </button>
      </div>
    </form>
    <div class="pt-4 text-center">
      <p v-if="returnUpdateMessage" :class="returnUpdateMessage.includes('Success') ? 'text-error info' : 'text-error'">
        {{ returnUpdateMessage }}
      </p>
      <p v-if="returnDeleteMessage" :class="returnDeleteMessage?.includes('Success') ? 'text-info' : 'text-error'">
        {{ returnDeleteMessage }}
      </p>
      <p v-if="errorMessage" class="text-error">{{ errorMessage }}</p>
    </div>
  </div>
</template>
<script setup lang="ts">
import { computed, onMounted, ref, watch } from "vue";
import { useRoute } from "vue-router";
import { useTransactionsStore } from "../stores/transactionsStore";

import type {
  DeleteTransaction,
  UpdateTransactionUpdate,
} from "../models/models";

const autoExpand = (event: Event) => {
  const textarea = event.target as HTMLTextAreaElement;
  textarea.style.height = "auto"; // Reset height
  textarea.style.height = `${textarea.scrollHeight}px`; // Adjust height
};
const route = useRoute();
const transactionId = computed(() => route.params.id as string);
const errorMessage = ref<string>("");
const description = ref<string>("");
const reason = ref<string>("");
const transactionsStore = useTransactionsStore();
const transactionIdData = computed(() => transactionsStore.transaction_detail);
const returnUpdateMessage = computed(
  () => transactionsStore.updateDescriptionMessage
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

const updateDescription = async () => {
  errorMessage.value = "";
  if (!description) {
    errorMessage.value = "Add some description in this transaction";
    return;
  }

  try {
    const updateTransactionDescriptionData: UpdateTransactionDescription = {
      transaction_id: Number(transactionId.value),
      description: description.value,
    };
    await transactionsStore.updateTransactionDescription(
      updateTransactionDescriptionData
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
    const deleteTransactionDescriptionData: DeleteTransaction = {
      transaction_id: Number(transactionId.value),
      transaction_type: transactionIdData.value.transactionType,
      reason: reason.value,
    };
    await transactionsStore.deleteTransaction(deleteTransactionDescriptionData);
    await fetchTransactionById();
  } catch (error) {
    console.log(error);
    errorMessage.value = "Error. Impossible to delete";
  }
};

onMounted(() => {
  transactionsStore.updateDescriptionMessage = "";
  transactionsStore.deleteMessage = "";
  errorMessage.value = "";
  fetchTransactionById();
});

watch(transactionId, () => {
  fetchTransactionById();
});
</script>
