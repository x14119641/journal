<template>
  <div class="flex items-center justify-center">
    <div class="bg-gray-800 p-8 rounded shadow-md w-full max-w-md">
      <h2 class="text-2xl font-semibold text-center text-white mb-6">
        Register
      </h2>
      <form @submit.prevent="onSubmit">
        <div class="mb-4">
          <label
            for="username"
            class="block text-sm font-medium text-gray-200 mb-2"
            >Username:</label
          >
          <input
            type="text"
            id="username"
            v-model="username"
            required
            class="w-full bg-gray-400 p-3 border border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-lime-400"
          />
        </div>
        <div class="mb-4">
          <label
            for="username"
            class="block text-sm font-medium text-gray-200 mb-2"
            >Email:</label
          >
          <input
            type="text"
            id="email"
            v-model="email"
            required
            class="w-full bg-gray-400 p-3 border border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-lime-400"
          />
        </div>
        <div class="mb-8">
          <label
            for="password"
            class="block text-sm font-medium text-gray-200 mb-2"
            >Password:</label
          >
          <input
            type="text"
            id="password"
            v-model="password"
            required
            class="w-full bg-gray-400 p-3 border border-gray-100 rounded focus:outline-none focus:ring-2 focus:ring-lime-400"
          />
        </div>
        <div class="mb-2">
          <button
            type="submit"
            class="w-full bg-lime-400 text-white py-3 rounded hover:bg-lime-500 focus:outline-none focus:ring-2 focus:ring-lime-400"
          >
            Register
          </button>
        </div>
      </form>
      <p v-if="errorMessage" class="mt-4 text-red-500">{{ errorMessage }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import api from "../services/api";
import { useRouter } from "vue-router";

const router = useRouter();
const username = ref<string>("");
const email = ref<string>("");
const password = ref<string>("");
const errorMessage = ref<string>("");

const isValidEmail = computed(() => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email.value);
});

const onSubmit = async () => {
  if (isValidEmail.value) {
    try {
      const response = await api.post("users", {
        username: username.value,
        email: email.value,
        password: password.value,
      });
      router.push('login')
    } catch (error) {
      // Improve error logging
      if (error.response) {
        console.error("API Error response:", error.response);
        errorMessage.value = error.response.data.detail || "An error occurred.";
      } else {
        console.error("Unexpected Error:", error);
        errorMessage.value = "An error occurred. Please try again.";
      }
    }
  } else {
    errorMessage.value = "Email is invalid.";
  }
};
</script>

<style scoped></style>
