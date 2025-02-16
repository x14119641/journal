<template>
  <div class="slate-container">
    <DataTable :headers="tableHeaders" :rows="tableData" />
  </div>
</template>


<script setup lang="ts">
import { computed, onMounted } from "vue";
import { usePortfolioStore } from "../stores/portfolioStore";
import DataTable from "../components/DataTable.vue";

const tableHeaders = ["amount", "description", "created_at"];

const portfolioStore = usePortfolioStore();
onMounted(async () => {
  await portfolioStore.getFunds();
  await portfolioStore.getPortfolio();
});

const tableData = computed(() => portfolioStore.latest_funds_transactions);

</script>

<style scoped>
/* You can add additional custom styles here */
</style>
