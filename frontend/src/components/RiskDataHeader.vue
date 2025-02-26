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
import { usePortfolioStore } from "../stores/portfolioStore";
import { computed } from "vue";

const portfolioStore = usePortfolioStore();
const quantityToBuy = computed(
  () => portfolioStore.riskCalculatorValues.quantity
);
const stopLoss = computed(() => portfolioStore.riskCalculatorValues.stopLoss);
const willingToLose = computed(
  () => portfolioStore.riskCalculatorValues.willingToLose
);
// const willingToLose = computed(() => portfolioStore.er);
</script>
