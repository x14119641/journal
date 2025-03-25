<template>
  <div class="p-6 text-center">
    <h3 class="title-component">Risk Data</h3>
    <div class="items-center">
      <div class="">
        <div class="flex justify-between">
          <span class="text-label">quantityToBuy</span>
          <span class="text-value">{{ quantityToBuy }}</span>

          <span class="text-label">stopLoss</span>
          <span class="text-value">{{ stopLoss }}</span>

          <span class="text-label">willingToLose</span>
          <span class="text-value">${{ willingToLose }}</span>
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
