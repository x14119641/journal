<template>
  <div v-if="hasData" class="p-6 w-auto chart-container">
    <h3 class="chart-title">Backtested Portfolio Growth</h3>
    <canvas ref="chartCanvas" class="pb-4"></canvas>
  </div>
  <div v-else class="text-center text-error">
    <p>No backtesting data available. Build and simulate portfolios first.</p>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick } from "vue";
import {
  Chart,
  LineController,
  LineElement,
  CategoryScale,
  LinearScale,
  PointElement,
  Tooltip,
  Legend,
} from "chart.js";

// Register necessary Chart.js modules
Chart.register(
  LineController,
  LineElement,
  CategoryScale,
  LinearScale,
  PointElement,
  Tooltip,
  Legend
);

// Props from parent
const props = defineProps<{
  labels: string[]; // Dates
  series: { name: string; values: number[] }[]; // [{ name: "portfolio1", values: [...] }, ...]
  cash_series?: { name: string; values: number[] }[];
}>();

const chartCanvas = ref<HTMLCanvasElement | null>(null);
let chartInstance: Chart | null = null;

const hasData = computed(() => props.series?.some((s) => s.values.length > 0));

// 🎨 Generate distinct colors per line
const generateColor = (index: number, alpha = 1) =>
  `hsl(${(index * 70) % 360}, 70%, ${alpha === 1 ? "50%" : "70%"})`;

// 🟢 Create the multi-line chart
const createChart = () => {
  if (!chartCanvas.value) return;
  const ctx = chartCanvas.value.getContext("2d");
  if (!ctx) return;

  if (chartInstance) {
    chartInstance.destroy();
  }

  chartInstance = new Chart(ctx, {
    type: "line",
    data: {
      labels: props.labels,
      datasets: props.series.map((portfolio, index) => ({
        label: portfolio.name,
        data: portfolio.values,
        borderColor: generateColor(index),
        backgroundColor: generateColor(index, 0.2),
        fill: true,
        tension: 0.4,
        pointRadius: 2,
        pointHoverRadius: 4,
      })),
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      interaction: {
        mode: "index",
        intersect: false,
      },
      plugins: {
        legend: {
          display: true,
          labels: { color: "#ccc", boxWidth: 12 },
        },
        tooltip: {
          backgroundColor: "#1F293790",
          borderWidth: 1,
          borderColor: "#7fa8e1",
          titleColor: "#06B6D4",
          bodyColor: "#E5E7EB",
          callbacks: {
            label: (context) => {
              const label = context.dataset.label;
              const value = context.parsed.y;
              const index = context.dataIndex;

              // Look up cash value for the same portfolio and date index
              let cash = null;
              if (props.cash_series && props.cash_series.length > 0) {
                const cashObj = props.cash_series.find((c) => c.name === label);
                if (cashObj && cashObj.values[index] !== undefined) {
                  cash = cashObj.values[index];
                }
              }

              // Format label with optional cash
              if (cash !== null) {
                return `${label}: $${value.toFixed(2)} (Cash: $${cash.toFixed(
                  2
                )})`;
              } else {
                return `${label}: $${value.toFixed(2)}`;
              }
            },
          },
        },
      },
      scales: {
        y: {
          ticks: {
            color: "#E5E7EB",
            callback: (value) => `$${value.toFixed(0)}`,
          },
        },
        x: {
          ticks: {
            color: "#E5E7EB",
          },
        },
      },
    },
  });
};

onMounted(async () => {
  await nextTick();
  createChart();
});

watch(() => [props.labels, props.series], createChart);
</script>

<style scoped>

</style>
