<template>
  <div class="flex justify-center w-full transition-all">
    <div
      class="container-component w-full sm:w-96 md:w-2/3 lg:w-1/2 xl:w-1/3"
    >
      <div v-if="!transactionTypeOrDontExist">
        <LoadingComponent />
      </div>
      <div v-else-if="transactionTypeOrDontExist === 'Balance'">
        <BalanceTransactionBox />
      </div>
      <div v-else-if="transactionTypeOrDontExist === 'Stock'">
        <StockTransactionBox />
      </div>
      <div v-else-if="transactionTypeOrDontExist === '404'">
        <TransactionNotExists :transactionId="transactionId" />
      </div>
    </div>
  </div>
  <p v-if="errorMessage" class="text-red-400 text-lg text-center">
    {{ errorMessage }}
  </p>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from "vue";
import { useTransactionsStore } from "../stores/transactionsStore";
import TransactionNotExists from "../components/TransactionNotExists.vue";
import { useRoute } from "vue-router";
import LoadingComponent from "../components/LoadingComponent.vue";
import StockTransactionBox from "../components/StockTransactionBox.vue";
import BalanceTransactionBox from "../components/BalanceTransactionBox.vue";

const transactionsStore = useTransactionsStore();

const errorMessage = ref<string>("");
const route = useRoute();
const transactionId = computed(() => route.params.id as string);
const transactionTypeOrDontExist = computed(
  () => transactionsStore.transactionTypeOrDontExist
);

if (isNaN(Number(transactionId.value))) {
  errorMessage.value = "404";
}
onMounted(async () => {
  await transactionsStore.getTransactionTypeOrDontExists(
    Number(transactionId.value)
  );
});
</script>
