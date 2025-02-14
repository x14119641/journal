<template>
  <div class="p-6 w-auto">
    <div v-if="hasData" class="chart-container">
      <h3 class="chart-title">
        <!-- <span class="dolar-style-title">$</span> -->
        Portfolio Allocation
      </h3>
      <canvas class="pb-2" ref="chartCanvas"></canvas>
    </div>
    <div v-else class="">
      <LoadingComponent />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import {
  Chart,
  BarController,
  BarElement,
  CategoryScale,
  LinearScale,
  Tooltip,
  Legend,
} from "chart.js";
import { usePortfolioStore } from "../stores/portfolioStore";
import chroma from "chroma-js";
import LoadingComponent from "./LoadingComponent.vue";

// Register Chart.js components.
Chart.register(
  BarController,
  BarElement,
  CategoryScale,
  LinearScale,
  Tooltip,
  Legend
);

const portfolioStore = usePortfolioStore();

const rawData = computed(() => portfolioStore.portfolio_barchart_data || []);
const hasData = computed(() => rawData.value.length > 0);

// Compute arrays for x-axis labels (tickers) and y-axis values.
const tickers = computed(() => rawData.value.map((item) => item.ticker));
const totalValues = computed(() =>
  rawData.value.map((item) => item.totalValue)
);

const chartCanvas = ref<HTMLCanvasElement | null>(null);
const chartInstance = ref<Chart | null>(null);

const n_colors = computed(() => tickers.value.length);
const scale_colors = ["#ff9544", "#749fe5", "#293b1e"];

onMounted(async () => {
  await portfolioStore.getPortfolioAllocationInitialCost();
  // Generate colors
  const colors = chroma.scale(scale_colors).mode("lch").colors(n_colors.value);
  if (chartCanvas.value) {
    const ctx = chartCanvas.value.getContext("2d");
    if (ctx) {
      chartInstance.value = new Chart(ctx, {
        type: "bar", // Specifies a bar chart.
        data: {
          labels: tickers.value, // X-axis labels.
          datasets: [
            {
              // Use a proper string label for the dataset (not an array).
              //   label: "Portfolio",
              data: totalValues.value, // Y-axis values.
              backgroundColor: colors, // Colors for each bar.
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                color: "#E5E7EB",
                font: { size: 16, family: "Inter, sans-serif" },
              },
            },
            x: {
              beginAtZero: true,
              ticks: {
                color: "#E5E7EB",
                font: { size: 16, family: "Inter, sans-serif" },
              },
            },
          },
          plugins: {
            legend: {
              display: false,
            },
            tooltip: {
              mode: "nearest",
              backgroundColor: "#1F293790",
              displayColors: true,
              borderWidth: 1,
              borderColor: "#7fa8e1",
              titleColor:"#06B6D4",
              bodyColor:"#E5E7EB",
              titleFont: {
                size: 16,
                family: "Inter, sans-serif",
              },
              bodyFont: {
                size: 14,
                family: "Inter, sans-serif",
              },
              callbacks: {
                // Use context.label to show the x-axis label (ticker)
                label: (context) => {
                  return ` $ ${context.parsed.y}`;
                },
              },
            },
          },
          interaction: {
            intersect: true,
            mode: "nearest",
          },
        },
      });
    }
  }
});
</script>

<style scoped></style>
