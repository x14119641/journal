<template>
  <div class="p-6 w-auto">
    <!-- <div v-if="loading">
      <LoadingComponent />
    </div>
    <div v-else> -->
      <div v-if="hasData" class="chart-container">
        <h3 class="chart-title">Portfolio Allocation</h3>
        <canvas class="pb-4" ref="chartCanvas"></canvas>
      </div>
      <div v-else class="text-center text-negative-style">
        <p>
          No data available. Start investing to see your portfolio allocation.
        </p>
      </div>
    <!-- </div> -->
  </div>
  <!-- <p>{{ rawData }}</p> -->
</template>

<script setup lang="ts">
import { ref, onMounted, computed, nextTick } from "vue";
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

// Register Chart.js components.
Chart.register(BarController, BarElement, Tooltip, Legend);

const rawData = computed(() => portfolioStore.portfolio_summary || []);
// if chartdata then laoding true
// const loading = computed(() => chartCanvas.value !== null);
// If no data show message
const hasData = computed(() => rawData.value.length > 0);


// Compute arrays for x-axis labels (tickers) and y-axis values.
const tickers = computed(() => rawData.value.map((item) => item.ticker));
const totalValues = computed(() =>
  rawData.value.map((item) => item.totalValue)
);

const chartCanvas = ref<HTMLCanvasElement | null>(null);



const colors = chroma
  .scale(["#ff9544", "#749fe5", "#293b1e"])
  .mode("lch")
  .colors(tickers.value.length);
onMounted(async () => {
  try {
    await portfolioStore.getPortfolioSummary();
    await nextTick();
    if (hasData.value && chartCanvas.value) {
      const ctx = chartCanvas.value.getContext("2d");

      if (ctx) {
        new Chart(ctx, {
          type: "bar",
          data: {
            labels: tickers.value,
            datasets: [
              {
                data: totalValues.value,
                backgroundColor: colors,
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
  } catch (error) {
    console.log(error);
  }
});
</script>

<style scoped></style>
