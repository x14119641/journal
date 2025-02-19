<template>
    <div class="p-6 text-center">
        <h3 class="summary-title-2">Portfolio</h3>

          <div class="flex justify-between ">
            <span class="summary-label">Capital</span>
            <span class="summary-value-2">{{ totalValue }}</span>
          </div>
          <div class="flex justify-between ">
            <span class="summary-label">Quantity</span>
            <span class="summary-value-2">{{ stockData?.totalQuantity }}</span>
          </div>
          <div class="flex justify-between ">
            <span class="summary-label">Min Price</span>
            <span class="summary-value-2">{{ stockData?.minPrice }}</span>
          </div>
          <div class="flex justify-between ">
            <span class="summary-label">Max Price</span>
            <span class="summary-value-2">{{ stockData?.maxPrice }}</span>
          </div>
          <div class="flex justify-between ">
            <span class="summary-label">BreakEven</span>
            <span class="summary-value-2">{{ stockData?.breakeven }}</span>
          </div>


    </div>
</template>

<script setup lang="ts">
import { computed, ref, onMounted } from 'vue';
import { usePortfolioStore } from '../stores/portfolioStore';
import { type PortfolioItemAgreggate } from '../models/models';

// const stockData = ref<PortfolioItemAgreggate | null>(null);


const props = defineProps<{
    ticker: string;
}>();

const portfolioStore = usePortfolioStore();
let stockData = computed(() => portfolioStore.ticker_portfolio_summary || []);
const totalValue = computed(() => portfolioStore.accountValue)

onMounted(async () =>{
    try {
        await portfolioStore.getFundsTotals()
        const response = await portfolioStore.getPortfolioTickerAggregate(props.ticker)
        stockData = response
    } catch (error) {
        console.error(error)
    }
})
</script>