<template>
  <div class="p-6 text-center">
    <h3 class="title-component">BackTester</h3>
    <div class="mt-2 flex flex-col space-y-2">
      <div class="flex justify-between items-center lg:gap-6 flex-col lg:flex-row">
        <span class="text-label">Initial Balance</span>
        <input id="initialBalance" type="number" v-model="initialBalance" min="0" class="input-style max-w-64" />
      </div>
      <!-- Start -->
      <div class="flex flex-col lg:flex-row items-center justify-center lg:justify-start gap-4 w-full">
        <span class="text-label">Start</span>
        <CustomSelectDropDown v-model="monthStart" :options="optionsMonth" class="w-full max-w-xs" />
        <CustomSelectDropDown v-model="yearStart" :options="optionsYear" class="w-full max-w-xs" />
      </div>
      <!-- End -->
      <div class="flex flex-col lg:flex-row items-center justify-center lg:justify-start gap-4 w-full">
        <!-- Add two spaces "&nbsp" to match the same number of letters in "Start" -->
        <span class="text-label">End&nbsp&nbsp</span>
        <CustomSelectDropDown v-model="monthEnd" :options="optionsMonth" class="w-full max-w-xs" />
        <CustomSelectDropDown v-model="yearEnd" :options="optionsYear" class="w-full max-w-xs" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useBacktesterStore } from "../stores/backTesterStore";
import { storeToRefs } from "pinia";
import CustomSelectDropDown from "./CustomSelectDropDown.vue";
const backtesterStore = useBacktesterStore();

const {
  initialBalance,
  monthStart,
  yearStart,
  monthEnd,
  yearEnd,
} = storeToRefs(backtesterStore);

const optionsMonth = [
  { label: "Jan", value: "1" },
  { label: "Feb", value: "2" },
  { label: "Mar", value: "3" },
  { label: "Apr", value: "4" },
  { label: "May", value: "5" },
  { label: "Jun", value: "6" },
  { label: "Jul", value: "7" },
  { label: "Aug", value: "8" },
  { label: "Sep", value: "9" },
  { label: "Oct", value: "10" },
  { label: "Nov", value: "11" },
  { label: "Dec", value: "12" },
];

const currentYear = new Date().getFullYear();
const optionsYear = Array.from({ length: currentYear - 1990 + 1 }, (_, i) => {
  const year = 1990 + i;
  return { label: year.toString(), value: year.toString() };
});
</script>
<style scoped></style>
