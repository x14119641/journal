<template>
  <div class="p-6 w-auto">
    <div v-if="hasData" class="chart-container">
      <h3 class="text-center text-xl text-gray-200">Allocation by Sector</h3>
      <canvas class="pb-4" ref="chartCanvas"></canvas>
    </div>
    <div v-else class="chart-container text-white">
      Loading chart...
    </div>
  </div>
  <!-- Debugging output -->
  <!-- <p class="text-white">{{ sectorDetails }}</p>
  <p class="text-white">{{ sectorAllocation }}</p> -->
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { Chart, DoughnutController, ArcElement, Tooltip, Legend } from 'chart.js';
import { usePortfolioStore } from '../stores/portfolioStore';
import chroma from 'chroma-js';

// Register Chart.js components.
Chart.register(DoughnutController, ArcElement, Tooltip, Legend);

const portfolioStore = usePortfolioStore();

// Use the store's allocation data.
const rawData = computed(() => portfolioStore.allocation_portfolio || []);

// Data is available if rawData has at least one item.
const hasData = computed(() => rawData.value.length > 0);

// --- Aggregate Data by Sector ---
// For each sector, sum the quantity.
const sectorAllocation = computed(() => {
  return rawData.value.reduce((acc, item) => {
    if (!acc[item.sector]) {
      acc[item.sector] = { total: 0, tickers: [] as { ticker: string; quantity: number }[] };
    }
    acc[item.sector].total += item.quantity;
    acc[item.sector].tickers.push({ ticker: item.ticker, quantity: item.quantity });
    return acc;
  }, {} as Record<string, { total: number; tickers: { ticker: string; quantity: number }[] }>);
});

// Compute chart labels (sectors) and data (aggregated quantities).
const sectors = computed(() => Object.keys(sectorAllocation.value));
const quantities = computed(() =>
  sectors.value.map(sector => sectorAllocation.value[sector].total)
);

const n_colors = computed(() => quantities.value.length)
// Build a mapping from sector to a list of ticker details (as strings).
const sectorDetails = computed(() => {
  return sectors.value.reduce((acc, sector) => {
    acc[sector] = sectorAllocation.value[sector].tickers.map(
      t => `${t.ticker}: ${t.quantity}`
    );
    return acc;
  }, {} as Record<string, string[]>);
});
// Reference for the canvas element.
const chartCanvas = ref<HTMLCanvasElement | null>(null);



// Combine onMounted: first fetch data from the store, then create the chart.
onMounted(async () => {
  await portfolioStore.getPortfolioAllocation(); // Wait for API data to load.

  // Generate colors '#44FF57' : '#FA2488' // '#fafa6e', '#2A4858'
  const colors = chroma.scale(['#44ff57', '#ff44ad', '#7a808e'])
    .mode('lch').colors(n_colors.value)
    
  if (hasData.value && chartCanvas.value) {
    const ctx = chartCanvas.value.getContext('2d');
    if (ctx) {
      new Chart(ctx, {
        type: 'doughnut', // Change to 'pie' if you prefer.
        data: {
          labels: sectors.value,
          datasets: [{
            data: quantities.value,
            backgroundColor: colors,
          }],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { position: 'top', labels:{color:"white", font:{size:14, }},},
            tooltip: {
              callbacks: {
                label: (context) => {
                  const label = context.label || '';
                  const value = Number(context.parsed);
                  // Compute the total across all sectors.
                  const total = quantities.value.reduce((sum, val) => sum + val, 0);
                  const percentage = total ? ((value / total) * 100).toFixed(2) : '0';
                  // Get the ticker details for the current sector.
                  const details = sectorDetails.value[label] || [];
                  // Return a multiline tooltip: first line with the aggregate info, second with tickers.
                  return [
                    `${label}: ${value} (${percentage}%)`,
                    `Tickers: ${details.join(', ')}`
                  ];
                }
              }
            }
          },
          interaction: { intersect: true, mode: 'nearest' }
        }
      });
    }
  }
});
</script>

<style scoped>
.chart-container {
  position: relative;
  width: 100%;
  height: 400px; /* Ensure the container has a defined height */
}
</style>
