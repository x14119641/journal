<template>
  <div v-if="hasData" class="p-6 w-auto chart-container">
    <h3 class="chart-title">Monthly Dividend</h3>
    <canvas class="pb-4" ref="chartCanvas"></canvas>
  </div>
  <div v-else class="text-center text-error">
    <p>No data available. Start investing to see your portfolio growth.</p>
  </div>
  <!-- <p>{{ estimatedValues }}</p> -->
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
import chroma from "chroma-js";
import type { DividendMonthly } from "../models/models";
import api from "../services/api";

// Register Chart.js components.
Chart.register(
  BarController,
  BarElement,
  CategoryScale,
  LinearScale,
  Tooltip,
  Legend
);



// Register Chart.js components.
Chart.register(BarController, BarElement, Tooltip, Legend);

const rawData = ref<DividendMonthly[]>([]);

const hasData = computed(() => rawData.value.length > 0);

const months = ref([
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
]);

// Compute arrays for x-axis labels (tickers) and y-axis values.
const monthNames = computed(() =>
months.value.slice(0,rawData.value.length)
);

const estimatedValues = computed(() =>
  rawData.value.length ? rawData.value.map((item) => item.estimatedPayout) : []
);
const chartCanvas = ref<HTMLCanvasElement | null>(null);

onMounted(async () => {
  try {
    const response = await api.get("/portfolio/dividend/monthly");
    
    rawData.value = [...response.data];
    await nextTick();
    if (hasData.value && chartCanvas.value) {
      const ctx = chartCanvas.value.getContext("2d");

      if (ctx) {
        const colors = chroma
          .scale(["#ff9544", "#749fe5", "#293b1e"])
          .mode("lch")
          .colors(monthNames.value.length);
        new Chart(ctx, {
          type: "bar",
          data: {
            labels: monthNames.value,
            datasets: [
              {
                data: estimatedValues.value,
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
