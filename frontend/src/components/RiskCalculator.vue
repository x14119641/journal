<template>
  <div class="p-6 text-center">
    <h3 class="summary-title-2">Risk Calculator</h3>
    <form @submit.prevent="calculate">
      <div class="mt-2 flex justify-between items-center gap-x-12">
        <label for="capital " class="summary-label">Capital</label>
        <input
          type="number"
          id="capital"
          :placeholder="capital_placeholder"
          v-model="capital"
          step="0.01"
          class="risk-calculator-input"
        />
      </div>
      <div class="mt-2 flex justify-between items-center gap-x-3">
        <label for="riskPortfolio " class="summary-label">Allocation%</label>
        <input
          type="number"
          id="riskPortfolio"
          v-model="riskPortfolio"
          placeholder="Default is 1"
          class="risk-calculator-input"
        />
      </div>
      <div class="mt-2 flex justify-between items-center">
        <label for="stockPrice " class="summary-label">Price</label>
        <input
          type="number"
          id="stockPrice"
          v-model="stockPrice"
          placeholder="Enter Stock Price"
          step="0.01"
          required
          class="risk-calculator-input"
        />
      </div>
      <div class="mt-2 flex justify-between items-center">
        <label for="riskPercent " class="summary-label">Risk %</label>
        <input
          type="number"
          id="riskPercent"
          v-model="riskPercent"
          placeholder="% I am willing to lose. Default: 10"
          class="risk-calculator-input"
        />
      </div>
      <!-- <div class="mt-2 flex justify-between items-center">
                <label for="StopLoss " class="summary-label">StopLoss</label>
                <input type="number" id="StopLoss" 
                v-mode="StopLoss"
                placeholder="Stop Loss"
                class="w-3/4 rounded-md border-gray-300 shadow-sm focus:ring focus:ring-lime-400" 
                />
            </div> -->
      <button
        type="submit"
        class="deposit-funds-button-style"
      >
        Calculate
      </button>
    </form>
    <p v-if="errorMessage" class="mt-4 text-center  text-red-500">{{ errorMessage }}</p>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import { useRiskHeaderStore } from "../stores/riskHeaderStore";

const quantityToBuy = ref<number | null>(null);
const stopLoss = ref<number | null>(null);
// If i dont set as string can not show :placeholder
const capital = ref<number | string>("");
const stockPrice = ref<number | null>(null);
const riskPortfolio = ref<number>(1);
// How much % i want to lose
const riskPercent = ref<number>(10);
const willingToLose = ref<number>(10);
const errorMessage = ref<string>("");

const portfolioStore = usePortfolioStore();
const riskHeaderStore = useRiskHeaderStore();

const accountValue = computed(() => portfolioStore.balance);
const capital_placeholder = computed(() => {
  console.log("Final balance before API call:", portfolioStore.balance);

  return portfolioStore.balance 
    ? `Default is your capital: ${portfolioStore.balance}` 
    : "Loading balance...";
});

onMounted(async () => {
  try {
    await portfolioStore.getPortfolio();
    
    console.log("Final balance after API call:", portfolioStore.balance);

  } catch (error) {
    console.error(error);
  }
});

const calculate = () => {
  errorMessage.value = "";
  riskHeaderStore.setShowRiskHeader(false)

  // Ensure capital is a valid number
  if (capital.value === null || capital.value === "") {
    capital.value = accountValue.value;
  }
  // IF user has no capital
  if (capital.value ===undefined) {
    errorMessage.value = "Capital Missing";
    return;
  }

  const capitalValue = Number(capital.value); // Convert to number

  // Validate stock price
  if (!stockPrice.value || stockPrice.value <= 0) {
    errorMessage.value = "Price cannot be 0 or negative.";
    return;
  }

  // Calculate Quantity to Buy
  quantityToBuy.value = (capitalValue * (riskPortfolio.value / 100)) / stockPrice.value;

  // Calculate Stop Loss
  stopLoss.value = stockPrice.value - stockPrice.value * (riskPercent.value / 100);
  
  // Calculate the quantity in money
  willingToLose.value = quantityToBuy.value * stopLoss.value
  riskHeaderStore.setRiskValues(quantityToBuy.value, stopLoss.value, willingToLose.value)
  riskHeaderStore.setShowRiskHeader(true)
};
</script>
