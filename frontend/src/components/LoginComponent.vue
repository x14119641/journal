<template>
  <div class="p-6 text-center">
    <h3 class="summary-title">Login</h3>
    <form @submit.prevent="onSubmit">
      <div class="mt-4">
        <label
          for="username"
          class="input-label"
          >Username or Email</label
        >
        <input
          type="text"
          id="username"
          v-model="username"
          required
          class="input-style"
        />
      </div>
      <div class="mt-4">
        <label
          for="password"
          class="input-label"
          >Password</label
        >
        <input
          type="password"
          id="password"
          v-model="password"
          class="input-style"
        />
      </div>
      <div class="mt-8">
        <button
        type="submit"
        class="login-button-style"
      >
        Login
      </button>
      </div>
      
    </form>
    <p class="text-center summary-label mt-4">
      Don't have an account?
      <router-link to="/register" class="register-link-style"
        >Register here</router-link
      >.
    </p>
    <p v-if="errorMessage" class="mt-4 text-negative-style">{{ errorMessage }}</p>
  </div>

</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { useAuthStore } from "../stores/authStore";


const authStore = useAuthStore();

const errorMessage = computed(() => authStore.errorMessage)

const username = ref("");
const password = ref("");

const onSubmit = () => {
  authStore.login(username.value, password.value);
};


</script>
