<template>
    <div class="flex items-center justify-center bg-gray-100">
      <div class="w-full max-w-md p-8 bg-white rounded shadow-md">
        <h1 class="text-2xl font-bold text-center mb-6">Login</h1>
        <form @submit.prevent="onSubmit">
          <div class="mb-4">
            <label for="username" class="block text-sm font-medium text-gray-700">Username or Email:</label>
            <input
              type="text"
              id="username"
              v-model="username"
              class="mt-1 p-2 block w-full rounded border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
            />
          </div>
          <div class="mb-6">
            <label for="password" class="block text-sm font-medium text-gray-700">Password:</label>
            <input
              type="password"
              id="password"
              v-model="password"
              class="mt-1 p-2 block w-full rounded border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
            />
          </div>
          <button
            type="submit"
            class="w-full bg-indigo-600 text-white py-2 px-4 rounded hover:bg-indigo-700"
          >
            Login
          </button>
          <p v-if="errorMessage" class="mt-4 text-red-500">{{ errorMessage }}</p>
        </form>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref } from 'vue';
  import { useAuthStore } from '../stores/authStore';
  
  const authStore = useAuthStore();
  const username = ref('');
  const password = ref('');
  
  const onSubmit = () => {
    authStore.login(username.value, password.value);
  };
  
  const errorMessage = authStore.errorMessage;
  </script>