<template>
  <div class="p-6 text-center">
    <h3 class="summary-title-2">Risk Calculator</h3>
    <form @submit.prevent="calculate">
      <div class="mt-2 flex justify-between items-center">
        <label for="capital " class="summary-label">Capital</label>
        <input
          type="number"
          id="capital"
          :placeholder="capital_placeholder"
          v-model="capital"
          step="0.01"
          class="w-3/4 rounded-md border-gray-300 shadow-sm focus:ring focus:ring-lime-400"
        />
      </div>
      <div class="mt-2 flex justify-between items-center">
        <label for="riskPortfolio " class="summary-label">Allocation %</label>
        <input
          type="number"
          id="riskPortfolio"
          v-model="riskPortfolio"
          placeholder="Default is 1"
          class="w-3/4 rounded-md border-gray-300 shadow-sm focus:ring focus:ring-lime-400"
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
          class="w-3/4 rounded-md border-gray-300 shadow-sm focus:ring focus:ring-lime-400"
        />
      </div>
      <div class="mt-2 flex justify-between items-center">
        <label for="riskPercent " class="summary-label">Risk %</label>
        <input
          type="number"
          id="riskPercent"
          v-model="riskPercent"
          placeholder="% I am willing to lose. Default: 10"
          class="w-3/4 rounded-md border-gray-300 shadow-sm focus:ring focus:ring-lime-400"
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
        class="mt-6 items-center w-3/4 bg-lime-500 hover:bg-lime-600 text-white py-2 rounded-md focus:outline-none focus:ring-2 focus:ring-lime-400"
      >
        Calculate
      </button>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import { useRiskHeaderStore } from "../stores/riskHeaderStore";


// If i dont set as string can not show :placeholder
const capital = ref<number | string>("");
const stockPrice = ref<number | null>(null);
const riskPortfolio = ref<number>(1);
// How much % i want to lose
const riskPercent = ref<number>(10);
const errorMessage = ref<string>("");

const portfolioStore = usePortfolioStore();
const riskHeaderStore = useRiskHeaderStore();

const accountValue = computed(() => portfolioStore.accountValue);
const capital_placeholder = computed(
  () => `Default is your capital: ${portfolioStore.accountValue}`
);

onMounted(async () => {
  try {
    await portfolioStore.getFundsTotals();
    
  } catch (error) {
    console.error(error);
  }
});

const calculate = async () => {
  try {
    if (capital.value === "") {
      capital.value = accountValue.value
    }
    if (stockPrice.value <= 0) {
      errorMessage.value = 'Price is wrong'
      return
    }
    await portfolioStore.getRiskPortfolioTicker(stockPrice.value, capital.value, riskPortfolio.value, riskPercent.value)
    riskHeaderStore.setShowRiskHeader(true)
  } catch (error) {
    errorMessage.value = "Error"
  }
}


// const calculate = () => {
//   errorMessage.value = ''
//   if ((capital.value === null) | (capital.value === "")) {
//     capital.value = accountValue.value;
//   }
//   if (stockPrice.value <= 0 || stockPrice.value === null) {
//     errorMessage.value = "Price can not be 0";
//   } else {
//     // Quantity to buy
//     quantityToBuy.value =
//       (capital.value * (riskPortfolio.value / 100)) / stockPrice.value;
//     // stop loss
//     stopLoss.value =
//       stockPrice.value - stockPrice.value * (riskPercent.value / 100);
//   }
// };
</script>
