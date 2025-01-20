<template>
  <div class="flex items-center justify-center">
    <AddFunds></AddFunds>
    <p>{{ portfolioStore.amount }}</p>
    <RemoveFunds></RemoveFunds>
    <p>{{ portfolioStore.amount }}</p>
  </div>
</template>

<script setup lang="ts">
import AddFunds from '../components/AddFunds.vue';
import RemoveFunds from '../components/RemoveFunds.vue';
import { ref } from 'vue';
import { usePortfolioStore } from '../stores/portfolioStore';

const portfolioStore = usePortfolioStore();

</script>

<style scoped>
</style> 
