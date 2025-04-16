<template>
  <div class="p-6 text-center">
    <h3 class="title-component">BackTester</h3>
    <div class="mt-2">
      <div
        class="flex justify-between items-center lg:gap-6 flex-col lg:flex-row"
      >
        <span class="text-label">Initial Balance</span>
        <input
          id="initialBalance"
          type="number"
          v-model="initialBalance"
          min="0"
          class="input-style max-w-64"
        />
      </div>
      <div
        class="flex justify-between items-center lg:gap-6 flex-col lg:flex-row"
      >
        <span class="text-label">Start</span>
        <div
          class="flex justify-between items-center lg:gap-6 flex-col lg:flex-row"
        >
          <div class="relative z-[999] w-full">
            <CustomSelectDropDown
              v-model="monthStart"
              :options="optionsMonth"
            />
          </div>
          <div class="relative z-[999] w-full">
            <CustomSelectDropDown
              v-model="monthStart"
              :options="optionsMonth"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import api from "../services/api";
import { usePortfolioStore } from "../stores/portfolioStore";
import type { DividendCalendar } from "../models/models";
import CustomSelectDropDown from "./CustomSelectDropDown.vue";

const portfolioStore = usePortfolioStore();

const balance = computed(() => portfolioStore.balance);
const totalMoneyInvested = computed(() => portfolioStore.totalMoneyInvested);
const realizedGains = computed(() => portfolioStore.netProfitLoss);
const dividendsThisMonth = ref<number>(0);
const monthStart = ref<string>("");
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
</script>
<style scoped></style>
