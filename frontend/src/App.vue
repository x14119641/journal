<template>
  <PageHeader />
  <h1>LAnding Page</h1>
  <p>This is the Landing Page OK asdasd</p>
  <router-link to="/demo">Go to Demo Page</router-link>
  <router-view></router-view>
</template>

<script setup lang="ts">
import PageHeader from "../components/PageHeader.vue";
</script>

<style scoped>
</style>
