<template>
    <div class="p-6 text-center">
        
        <h3 class="summary-title">
          TransactionID: <span class="chart-title">{{ props.transactionId }}</span>
        </h3>
        <h2 class="mt-2 summary-subtitle">
          Transaction Does not exist!
        </h2>

    </div>
</template>
<script setup lang="ts">
const props = defineProps<{
    transactionId:string;
}>();
</script>