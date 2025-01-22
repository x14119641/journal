<template>
  <div class="flex flex-col items-center space-y-6">
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full">
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
        <!-- Box 1  -->
        <FundsHeader />
      </div>


      <div class="col-span-2 flex flex-col gap-6 w-full">
        <!-- Box 3 (divided by two) -->
        <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
          <AddTransaction />
        </div>
        <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
          <LatestTransactionsTable />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import AddTransaction from '../components/AddTransaction.vue';
import LatestTransactionsTable from '../components/LatestTransactionsTable.vue';
import FundsHeader from '../components/FundsHeader.vue';
</script>

<style scoped>
</style> 
