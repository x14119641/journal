<!-- src/pages/ProfilePage.vue -->
<template>
    <div class="p-6 bg-white rounded-lg shadow-lg">
      <h1 class="text-3xl font-semibold text-center text-indigo-600 mb-6">Profile Page</h1>
      <p v-if="authStore.user" class="text-center text-lg">Welcome, {{ authStore.user }}</p>
      <p v-else>You are not logged in.</p>
      <button @click="authStore.logout" class="mt-4 py-2 px-4 bg-red-600 text-white font-medium rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2">
        Logout
      </button>
    </div>
  </template>
  
  <script setup lang="ts">
  import { useAuthStore } from '../stores/authStore';
  const authStore = useAuthStore();
  </script>
  