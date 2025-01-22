<template>
    <div v-if="latest_records.length > 0">
        <DataTable :headers="tableHeaders" :rows="latest_records"/>
    </div>
</template>

<script setup lang="ts">
import DataTable from './DataTable.vue';
import { onMounted, computed } from 'vue';
import { useTransactionsStore } from '../stores/transactionsStore';


const transactionsStore = useTransactionsStore();

onMounted(async () => {
  await transactionsStore.getLatestTransactions();
});

const tableHeaders = ['Ticker', 'Quantity', 'Price', 'Type', 'Total', 'Created at'];
const latest_records = computed(() => transactionsStore.latest_transactions);


</script>