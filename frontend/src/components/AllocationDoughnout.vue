<template>
  <div class="p-6 w-auto">
    <div v-if="loading">
      <LoadingComponent />
    </div>
    <div v-else-if="hasData" class="chart-container">
      <h3 class="chart-title">Sector Allocation</h3>
      <canvas class="pb-4" ref="chartCanvas"></canvas>
    </div>
    <div v-else class="text-center text-white text-negative-style">
      <p>No data available. Start investing to see your portfolio allocation.</p>
    </div>

  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
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


const loading = ref(true);
// Register Chart.js components.
Chart.register(DoughnutController, ArcElement, Tooltip, Legend);

const portfolioStore = usePortfolioStore();

const rawData = computed(() => portfolioStore.sector_allocation_portfolio || []);
const hasData = computed(() => rawData.value.length > 0);

// --- Aggregate Data by Sector ---
// For each sector, sum the quantity.
const sectorAllocation = computed(() => {
  return rawData.value.reduce((acc, item) => {
    if (!acc[item.sector]) {
      acc[item.sector] = {
        total: 0,
        tickers: [] as { ticker: string; quantity: number }[],
      };
    }
    acc[item.sector].total += item.quantity;
    acc[item.sector].tickers.push({
      ticker: item.ticker,
      quantity: item.quantity,
    });
    return acc;
  }, {} as Record<string, { total: number; tickers: { ticker: string; quantity: number }[] }>);
});

// Compute chart labels (sectors) and data (aggregated quantities).
const sectors = computed(() => Object.keys(sectorAllocation.value));
const quantities = computed(() =>
  sectors.value.map((sector) => sectorAllocation.value[sector].total)
);

// Build a mapping from sector to a list of ticker details (as strings).
const sectorDetails = computed(() => {
  return sectors.value.reduce((acc, sector) => {
    acc[sector] = sectorAllocation.value[sector].tickers.map(
      (t) => `${t.ticker}: ${t.quantity}`
    );
    return acc;
  }, {} as Record<string, string[]>);
});

const chartCanvas = ref<HTMLCanvasElement | null>(null);
const n_colors = computed(() => quantities.value.length);
const scale_colors = ["#44ff57", "#ff44ad", "#7a808e"];

onMounted(async () => {
  try {
    await portfolioStore.getPortfolioAllocationSector();

  
  // Generate colors
  const colors = chroma
    .scale(scale_colors)
    .mode("lch")
    .colors(n_colors.value);

  if (hasData.value && chartCanvas.value) {
    const ctx = chartCanvas.value.getContext("2d");
    if (ctx) {
      new Chart(ctx, {
        type: "doughnut", 
        data: {
          labels: sectors.value,
          datasets: [
            {
              data: quantities.value,
              backgroundColor: colors,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          // Labels in x
          plugins: {
            legend: {
              position: "top",
              labels: { color: "#E5E7EB", font: { size: 16, family: 'Inter, sans-serif', } },
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
                title: (tooltipItems) => {
                  const item = tooltipItems[0]
                  return `${item.label}`;
                },
                label: (context) => {
                  const label = context.label || "";
                  const value = Number(context.parsed);
                  // Compute the total across all sectors.
                  const total = quantities.value.reduce(
                    (sum, val) => sum + val,
                    0
                  );
                  const percentage = total
                    ? ((value / total) * 100).toFixed(2)
                    : "0";
                  // Get the ticker details for the current sector.
                  const details = sectorDetails.value[label] || [];
                  // Return a multiline tooltip: first line with the aggregate info, second with tickers.
                  return [
                    ` Quantity: ${value} (${percentage}%)`,
                    ` Tickers: ${details.join(", ")}`,
                  ];
                },
              },
            },
          },
          interaction: { intersect: true, mode: "nearest" },
        },
      });
    }
  };
  } catch (error) {
    loading.value = false;
  }
  
  
});
</script>

<style scoped>

</style>
