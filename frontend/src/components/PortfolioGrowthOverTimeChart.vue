<template>
    <div v-if="hasData" class="p-6 w-auto chart-container">
      <h3 class="chart-title">Portfolio Growth Over Time</h3>
      <canvas class="pb-4" ref="chartCanvas"></canvas>
    </div>
    <div v-else class="text-center text-error">
      <p>No data available. Start investing to see your portfolio growth.</p>
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
  
  // Register necessary Chart.js components
  Chart.register(LineController, LineElement, CategoryScale, LinearScale, PointElement, Tooltip, Legend);
  
  // Props received from the parent component
  const props = defineProps<{
    labels: string[];
    values: number[];
  }>();
  
  const chartCanvas = ref<HTMLCanvasElement | null>(null);
  let chartInstance: Chart | null = null;
  const hasData = computed(() => props.values.length > 0);
  
  // ✅ Function to create the chart
  const createChart = () => {
    if (!chartCanvas.value) return;
    const ctx = chartCanvas.value.getContext("2d");
    if (!ctx) return;
  
    // Destroy existing chart before creating a new one
    if (chartInstance) {
      chartInstance.destroy();
    }
  
    chartInstance = new Chart(ctx, {
      type: "line",
      data: {
        labels: props.labels,
        datasets: [
          {
            label: "Portfolio Value ($)",
            data: props.values,
            borderColor: "#4CAF50",
            backgroundColor: "rgba(76, 175, 80, 0.2)",
            tension: 0.4,
            fill: true,
            pointRadius: 3,
            pointHoverRadius: 5,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          y: {
            beginAtZero: false, // Allow dynamic scaling
            ticks: {
              color: "#E5E7EB",
              font: { size: 16, family: "Inter, sans-serif" },
              callback: (value) => `$${value.toFixed(2)}`, // Format as currency
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
          legend: { display: true, labels: { color: "#ccc" } },
          tooltip: {
            backgroundColor: "#1F293790",
            displayColors: true,
            borderWidth: 1,
            borderColor: "#7fa8e1",
            titleColor: "#06B6D4",
            bodyColor: "#E5E7EB",
            callbacks: {
              label: (context) => ` $${context.parsed.y}`,
            },
          },
        },
        interaction: {
          intersect: false,
          mode: "index",
        },
      },
    });
  };
  
  
  onMounted(async () => {
    await nextTick();
    createChart();
  });
  
  
  watch(() => [props.labels, props.values], createChart);
  </script>
  