<template>
  <div class="p-6 text-center">
    <h3 class="summary-title-2">{{ ticker }}</h3>
    <!-- INfo labels -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-x-12">
        <div class="mt-2" v-for="(item, indx) in stockData" :key="indx">
          <div class="flex justify-between ">
            <span class="summary-label">{{ indx }}</span>
            <span class="summary-value-2">{{ item }}</span>
          </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import api from '../services/api';
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { type StockMetadata } from '../models/models';

const route = useRoute();
const ticker = ref<String>(route.params.ticker as string);
const stockData = ref<StockMetadata | null>(null);

onMounted(async () => {
    try {
        const response = await api.get(`/stocks/${ticker.value}`);
        stockData.value = response.data;
    } catch (error) {
        console.error("Error fetching funds:", error);
    }
})
const items = [
  "item1",
  "item2",
  "item4",
  "item1",
  "item2",
  "item4",
  "item1",
  "item2",
  "item4",
];
</script>
