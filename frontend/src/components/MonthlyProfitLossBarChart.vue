<template>
  <div v-if="hasData" class="p-6 w-auto chart-container">
    <h3 class="chart-title">Monthly Profit & Loss Over Time</h3>
    <canvas class="pb-4" ref="chartCanvas"></canvas>
  </div>
  <div v-else class="text-center text-error">
    <p>No data available. Start investing to see your portfolio growth.</p>
  </div>
  <!-- <p>{{ totalRealizedProfitLoss }}</p> -->
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
import type { DividendMonthlyProfit } from "../models/models";
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

const rawData = ref<DividendMonthlyProfit[]>([]);

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

const labels = computed(() => {
  const activeMonths = rawData.value.map((item) => item.monthIndex);
  return months.value.filter((_, index) => activeMonths.includes(index + 1));
});
const totalRealizedProfitLoss = computed(() =>
  rawData.value.map((item) => Number(item.totalRealizedProfitLoss))
);
const chartCanvas = ref<HTMLCanvasElement | null>(null);
    const colors = computed(() =>
  totalRealizedProfitLoss.value.map((value) =>
    value >= 0 ? "#47AF80" : "#E53935" // Green for positive, Red for negative
  )
);
onMounted(async () => {
  try {
    const response = await api.get("/portfolio/dividend/monthly/profitloss");

    rawData.value = [...response.data];
    await nextTick();
    if (hasData.value && chartCanvas.value) {
      const ctx = chartCanvas.value.getContext("2d");
    //   const colors = chroma
    //     .scale(["#ff9544", "#749fe5", "#293b1e"])
    //     .mode("lch")
    //     .colors(labels.value.length);
      if (ctx) {
        new Chart(ctx, {
          type: "bar",
          data: {
            labels: labels.value,
            datasets: [
              {
                label: "Profit / Loss ($)",
                data: totalRealizedProfitLoss.value,
                backgroundColor: colors.value,
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
                  callback: (value) => `$${value.toFixed(2)}`,
                },
              },
              x: {
                ticks: {
                  color: "#E5E7EB",
                  font: { size: 16, family: "Inter, sans-serif" },
                },
              },
            },
            plugins: {
              legend: { display: false },
              tooltip: {
                callbacks: {
                  label: (context) => {
                    const value = context.parsed.y;
                    return value >= 0
                      ? `Profit: $${value.toFixed(2)}`
                      : `Loss: $${Math.abs(value).toFixed(2)}`;
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
