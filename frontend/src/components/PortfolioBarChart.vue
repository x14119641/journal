<template>
    <div class="p-6 w-auto">
      <div v-if="hasData" class="chart-container">
        <h3 class="text-center text-xl text-gray-200">Portfolio Allocation $</h3>
        <canvas class="pb-2" ref="chartCanvas"></canvas>
      </div>
      <div v-else class="chart-container text-white">Loading chart...</div>
    </div>
    <!-- Debugging output -->
    <!-- <p class="text-white">{{ rawData }}</p> -->
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted, computed } from 'vue';
  import { Chart, BarController, BarElement, CategoryScale, LinearScale, Tooltip, Legend } from 'chart.js';
  import { usePortfolioStore } from '../stores/portfolioStore';
  import chroma from 'chroma-js';


  // Register Chart.js components.
  Chart.register(BarController, BarElement, CategoryScale, LinearScale, Tooltip, Legend);
  
  const portfolioStore = usePortfolioStore();
  
  // Use the store's data (for example, an array of objects with { ticker, totalValue }).
  const rawData = computed(() => portfolioStore.portfolio_barchart_data || []);
  
  // Data is available if rawData has at least one item.
  const hasData = computed(() => rawData.value.length > 0);
  
  // Compute arrays for x-axis labels (tickers) and y-axis values.
  const tickers = computed(() => rawData.value.map(item => item.ticker));
  const totalValues = computed(() => rawData.value.map(item => item.totalValue));
  
  const chartCanvas = ref<HTMLCanvasElement | null>(null);
  const chartInstance = ref<Chart | null>(null);
  

  const n_colors = computed(() => tickers.value.length)

  onMounted(async () => {
    await portfolioStore.getPortfolioBarChartData();
    // Generate colors
    const colors = chroma.scale(['#ff9544', '#749fe5', '#293b1e'])
      .mode('lch').colors(n_colors.value)
    if (chartCanvas.value) {
      const ctx = chartCanvas.value.getContext('2d');
      if (ctx) {
        chartInstance.value = new Chart(ctx, {
          type: 'bar', // Specifies a bar chart.
          data: {
            labels: tickers.value, // X-axis labels.
            datasets: [{
              // Use a proper string label for the dataset (not an array).
            //   label: "Portfolio",
              data: totalValues.value,     // Y-axis values.
              backgroundColor: colors, // Colors for each bar.
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
              y: {
                beginAtZero: true,
              }
            },
            plugins: {
              legend: {
                display: false,
              },
              tooltip: {
                callbacks: {
                  // Use context.label to show the x-axis label (ticker)
                  label: (context) => {
                    return `${context.label}: $${context.parsed.y}`;
                  }
                }
              }
            },
            interaction: {
              intersect: true,
              mode: 'nearest'
            }
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
  