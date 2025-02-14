<template>
  <div class="flex flex-col items-center space-y-6">
    <!-- Top Row: 3 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-1 lg:grid-cols-3 gap-6 w-full">
      <div class="slate-container">
        <!-- Box 1  -->
        <ProfileInfo />
      </div>

      <div class="slate-container">
        <!-- Box 2  -->
        <FundsHeader />
      </div>
      <div class="slate-container">
        <!-- Box 3  -->
        <PortfolioSummary />
      </div>
    </div>

    <!-- Bottom Row: 2 Boxes -->
    <div class="grid grid-cols-1 sm:grid-cols-1 lg:grid-cols-2 gap-6 w-full">
      <div class="slate-container">
        <!-- Box 4 content goes here -->
        <AllocationDoughnout />
      </div>
      <div class="slate-container">
        <!-- Box 5 content goes here -->
        <PortfolioBarChart />
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import ProfileInfo from "../components/ProfileInfo.vue";
import FundsHeader from "../components/FundsHeader.vue";
import AllocationDoughnout from "../components/AllocationDoughnout.vue";
import PortfolioBarChart from "../components/PortfolioBarChart.vue";
import PortfolioSummary from "../components/PortfolioSummary.vue";
</script>
