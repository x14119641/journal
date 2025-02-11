<template>
  <div class="p-6 w-auto">
    <div v-if="hasData" class="chart-container">
        <h3 v-if="title" class="text-center text-xl text-gray-200 ">{{ title }}</h3>
      <canvas class="mt-2" ref="chartCanvas"></canvas>
    </div>
    <div v-else class="chart-container text-white">Loading chart...</div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, onBeforeUnmount, ref, computed, watch } from "vue";
import {
  Chart,
  PieController,
  ArcElement,
  Tooltip,
  Legend,
  Title,
} from "chart.js";

// Register the necessary Chart.js components.
Chart.register(PieController, ArcElement, Tooltip, Legend, Title);

// Define the component props.
const props = defineProps<{
    title?:string; 
  labels: string[];
  values: number[];
  colors: string[];
}>();

// A computed property to check whether we have data.
const hasData = computed(() => props.values && props.values.length > 0);

// References for the canvas element and Chart.js instance.
const chartCanvas = ref<HTMLCanvasElement | null>(null);
const chartInstance = ref<Chart | null>(null);

// Function to create the chart instance.
function createChart() {
  if (chartCanvas.value) {
    const ctx = chartCanvas.value.getContext("2d");
    if (ctx) {
      chartInstance.value = new Chart(ctx, {
        type: "pie",
        data: {
          labels: props.labels,
          datasets: [
            {
              data: props.values,
              backgroundColor: props.colors,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: "top",
            },
            tooltip: {
              callbacks: {
                // Custom tooltip: show ticker, value, and percentage.
                label: (context) => {
                  const ticker = context.label || "";
                  const value = Number(context.parsed);
                  // Calculate total for the dataset.
                  const dataArr = context.dataset.data as number[];
                  const total = dataArr.reduce(
                    (sum, val) => sum + Number(val),
                    0
                  );
                  const percentage =
                    total === 0 ? 0 : ((value / total) * 100).toFixed(2);
                  return `${ticker}: ${value} (${percentage}%)`;
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
}

// Create the chart when the component mounts (only if there is data).
onMounted(() => {
  if (hasData.value) {
    createChart();
  }
});

// Watch for changes in the props and update the chart.

// Destroy the chart when the component unmounts.
onBeforeUnmount(() => {
  if (chartInstance.value) {
    chartInstance.value.destroy();
  }
});
</script>

<style scoped>
.chart-container {
  position: relative;
  width: 100%;
  height: 400px; /* Adjust as needed */
}
</style>
