<template>
  <div class="p-6 text-center">
    <h3 class="summary-title-2">Risk Data</h3>
    <div class="items-center">
      <div class="">
        <div class="flex justify-between">
          <span class=" summary-label">quantityToBuy</span>
          <span class="summary-value">{{ quantityToBuy }}</span>

          <span class="summary-label">stopLoss</span>
          <span class="summary-value">{{ stopLoss }}</span>

          <span class="summary-label">willingToLose</span>
          <span class="summary-value">${{ willingToLose }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRiskHeaderStore } from "../stores/riskHeaderStore";
import { computed } from "vue";

const riskHeaderStore = useRiskHeaderStore();
const quantityToBuy = computed(
  () => riskHeaderStore.quantityToBuy
);
const stopLoss = computed(() => riskHeaderStore.stopLoss);
const willingToLose = computed(
  () => riskHeaderStore.willingToLose
);

</script>
