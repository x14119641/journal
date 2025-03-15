<template>
  <div class="p-6 w-auto">
    <!-- <div v-if="loading">
      <LoadingComponent />
    </div>
    <div v-else> -->
      <div v-if="hasData" class="chart-container">
        <h3 class="chart-title">Sector Allocation</h3>
        <canvas class="pb-4" ref="chartCanvas"></canvas>
      </div>
      <div v-else class="text-center text-error">
        <p>
          No data available. Start investing to see your portfolio allocation.
        </p>
      </div>
    <!-- </div> -->
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, nextTick } from "vue";
import {
  Chart,
  DoughnutController,
  ArcElement,
  Tooltip,
  Legend,
} from "chart.js";
import { usePortfolioStore } from "../stores/portfolioStore";
import chroma from "chroma-js";
import LoadingComponent from "./LoadingComponent.vue";

const portfolioStore = usePortfolioStore();
const rawData = computed(
  () => portfolioStore.sector_allocation_portfolio || []
);

const chartCanvas = ref<HTMLCanvasElement | null>(null);

// if chartdata then laoding true
// const loading = computed(() => chartCanvas.value !== null);
// If no data show message
const hasData = computed(() => rawData.value.length > 0);

// Register Chart.js components.
Chart.register(DoughnutController, ArcElement, Tooltip, Legend);

// Extract tickers by sector
const sectorDetails = computed(() => {
  const details: Record<string, string[]> = {};

  rawData.value.forEach((item) => {
    const { sector, ticker } = item;

    if (!details[sector]) {
      details[sector] = [];
    }
    if (!details[sector].includes(ticker)) {
      details[sector].push(ticker);
    }
  });

  return details;
});

// Chart labels and values
const chartLabels = computed(() => rawData.value.map((item) => item.sector));
const chartValues = computed(() => rawData.value.map((item) => item.quantity));
const colors = chroma
  .scale(["#44ff57", "#6744ff", "#ff44ad", "#7a808e"])
  .mode("lch")
  .colors(chartLabels.value.length);
onMounted(async () => {
  try {
    await portfolioStore.getPortfolioAllocationSector();
    await nextTick();
    if (hasData.value && chartCanvas.value) {
      const ctx = chartCanvas.value.getContext("2d");

      if (ctx) {
        new Chart(ctx, {
          type: "doughnut",
          data: {
            labels: chartLabels.value,
            datasets: [
              {
                data: chartValues.value,
                backgroundColor: colors,
              },
            ],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                position: "top",
                labels: {
                  color: "#E5E7EB",
                  font: { size: 16, family: "Inter, sans-serif" },
                },
              },
              tooltip: {
                callbacks: {
                  title: (tooltipItems) => tooltipItems[0].label,
                  label: (context) => {
                    const sector = context.label || "";
                    const value = Number(context.parsed);
                    const total = chartValues.value.reduce(
                      (sum, val) => sum + val,
                      0
                    );
                    const percentage = total
                      ? ((value / total) * 100).toFixed(2)
                      : "0";
                    const tickers = sectorDetails.value[sector] || [];
                    return [
                      ` Quantity: ${value} (${percentage}%)`,
                      ` Tickers: ${tickers.join(", ")}`,
                    ];
                  },
                },
                mode: "nearest",
                backgroundColor: "#1F293790",
                displayColors: true,
                borderWidth: 1,
                borderColor: "#7fa8e1",
                titleColor: "#06B6D4",
                bodyColor: "#E5E7EB",
                titleFont: {
                  size: 16,
                  family: "Inter, sans-serif",
                },
                bodyFont: {
                  size: 14,
                  family: "Inter, sans-serif",
                },
              },
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
