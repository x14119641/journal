<template>
  <div class="flex items-center justify-center">
    <div class="bg-gray-800 p-8 rounded shadow-md w-full max-w-md">
      <h2 class="text-2xl font-semibold text-center text-white mb-6">Login</h2>
      <form @submit.prevent="onSubmit">
        <div class="mb-4">
          <label
            for="username"
            class="block text-sm font-medium text-gray-100 mb-2"
            >Username or Email:</label
          >
          <input
            type="text"
            id="username"
            v-model="username"
            required
            class="w-full bg-gray-400 p-3 border border-100 rounded focus:outline-none focus:ring-2 focus:ring-lime-400"
          />
        </div>
        <div class="mb-6">
          <label
            for="password"
            class="block text-sm font-medium text-gray-100 mb-2"
            >Password:</label
          >
          <input
            type="password"
            id="password"
            v-model="password"
            class="w-full p-3 bg-gray-400 border border-gray-400 rounded focus:outline-none focus:ring-2 focus:ring-lime-400"
          />
        </div>
        <button
          type="submit"
          class="w-full bg-lime-400 text-white py-3 rounded hover:bg-lime-500 focus:outline-none focus:ring-2 focus:ring-lime-400"
        >
          Login
        </button>
      </form>
      <p class="text-center text-sm text-gray-400 mt-4">
        Don't have an account?
        <router-link to="/register" class="text-lime-400 hover:underline"
          >Register here</router-link
        >.
      </p>
      <p v-if="errorMessage" class="mt-4 text-red-500">{{ errorMessage }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { useAuthStore } from "../stores/authStore";

const authStore = useAuthStore();
const username = ref("");
const password = ref("");

const onSubmit = () => {
  authStore.login(username.value, password.value);
};

const errorMessage = authStore.errorMessage;
</script>
