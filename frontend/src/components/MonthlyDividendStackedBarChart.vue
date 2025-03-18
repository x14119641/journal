<template>
  <div v-if="hasData" class="p-6 w-auto chart-container">
    <h3 class="chart-title">Monthly Dividend Stacked</h3>
    <canvas class="pb-4" ref="chartCanvas"></canvas>
  </div>
  <div v-else class="text-center text-error">
    <p>No data available. Start investing to see your portfolio growth.</p>
  </div>
  <!-- <p>{{ formattedData }}</p> -->
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
import type {  DividendMonthlyGrouped } from "../models/models";
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

const rawData = ref<DividendMonthlyGrouped[]>([]);

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

const chartCanvas = ref<HTMLCanvasElement | null>(null);

const formattedData = computed(() => {
  const groupedData: Record<string, Record<string, number>> = {};

  rawData.value.forEach(({ month, ticker, amount }) => {
    const monthName = months.value[month - 1]; // Convert index to month name
    if (!groupedData[monthName]) groupedData[monthName] = {};
    groupedData[monthName][ticker] = amount;
  });

  return groupedData;
});

const colors = computed(() => {
  const tickers = [...new Set(rawData.value.map((item) => item.ticker))]; // Get unique tickers
  return chroma
    .scale(["#ff9544", "#749fe5", "#293b1e"])
    .mode("lch")
    .colors(tickers.length); // Use tickers.length instead of monthNames.value.length
});

const labels = computed(() => Object.keys(formattedData.value));
const datasets = computed(() => {
  const tickers = [...new Set(rawData.value.map((item) => item.ticker))];

  return tickers.map((ticker, index) => ({
    label: ticker,
    data: labels.value.map(
      (month) => formattedData.value[month]?.[ticker] || 0
    ), // Correct mapping
    backgroundColor: colors.value[index],
  }));
});

onMounted(async () => {
  try {
    const response = await api.get("/portfolio/dividend/monthly/grouped");

    rawData.value = [...response.data];
    await nextTick();
    if (hasData.value && chartCanvas.value) {
      const ctx = chartCanvas.value.getContext("2d");

      if (ctx) {
        new Chart(ctx, {
          type: "bar",
          data: {
            labels: labels.value,
            datasets: datasets.value,
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
              y: {
                beginAtZero: true,
                stacked: true,
                ticks: {
                  color: "#E5E7EB",
                  font: { size: 16, family: "Inter, sans-serif" },
                },
              },
              x: {
                beginAtZero: true,
                stacked: true,
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
                  title: (tooltipItems) => {
                    // Tooltip title (Month)
                    return tooltipItems[0].label;
                  },
                  label: (context) => {
                    const ticker = context.dataset.label; // Get the ticker name
                    const value = context.parsed.y.toFixed(2); // Format value to 2 decimal places
                    return `${ticker}: $${value}`;
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
