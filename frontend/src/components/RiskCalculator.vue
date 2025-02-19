<template>
    <div class="p-6 text-center">
        <h3 class="summary-title-2">Calculator</h3>
        <form @submit.prevent="calculate">
            <div class="mt-2 flex justify-between items-center">
                <label for="capital " class="summary-label">Capital</label>
                <input type="number" id="capital" 
                v-model.numer="capital"
                placeholder="Enter available capital"
                class="w-3/4 rounded-md border-gray-300 shadow-sm focus:ring focus:ring-lime-400" 
                />
            </div>
            <div class="mt-2 flex justify-between items-center">
                <label for="riskPortfolio " class="summary-label">Portfolio %</label>
                <input type="number" id="riskPortfolio" 
                v-model.numer="riskPortfolio"
                placeholder="Portfolio %"
                class=" w-3/4 rounded-md border-gray-300 shadow-sm focus:ring focus:ring-lime-400" 
                />
            </div>
            <div class="mt-2 flex justify-between items-center">
                <label for="stockPrice " class="summary-label">Price</label>
                <input type="number" id="stockPrice" 
                v-model.numer="stockPrice"
                placeholder="Stock PRice"
                class="w-3/4 rounded-md border-gray-300 shadow-sm focus:ring focus:ring-lime-400" 
                />
            </div>
            <div class="mt-2 flex justify-between items-center">
                <label for="riskPercent " class="summary-label">Risk %</label>
                <input type="number" id="riskPercent" 
                v-model.numer="riskPercent"
                placeholder="Risk %"
                class="w-3/4 rounded-md border-gray-300 shadow-sm focus:ring focus:ring-lime-400" 
                />
            </div>
            <div class="mt-2 flex justify-between items-center">
                <label for="StopLoss " class="summary-label">StopLoss</label>
                <input type="number" id="StopLoss" 
                v-model.numer="StopLoss"
                placeholder="Stop Loss"
                class="w-3/4 rounded-md border-gray-300 shadow-sm focus:ring focus:ring-lime-400" 
                />
            </div>
            <button
        type="submit"
        class=" mt-2 items-center w-3/4 bg-lime-500 hover:bg-lime-600 text-white py-2 rounded-md focus:outline-none focus:ring-2 focus:ring-lime-400"
      >
        Calculate
      </button>
        </form>
        <!-- Ouptu -->
        <div class="mt-2">
          <div class="flex justify-center gap-x-12">
            <label for="quantityToBuy" class="summary-label">Quantity To buy</label>
            <span class="summary-value-2">Item</span>
          </div>
          <div class="flex justify-center gap-x-12">
            <label for="stopLossValue" class="summary-label">stopLossValue</label>
            <span class="summary-value-2">Item</span>
          </div>
        </div>

        
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const capital = ref<number>(0);
const stockPrice = ref<number>(0);
const riskPercent = ref<number>(0);
const stopLoss = ref<number>(0);
</script>