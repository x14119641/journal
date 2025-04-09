<template>
  <div class="flex justify-center w-full transition-all">
    <div class="container-component w-full  sm:w-96 md:w-2/3 lg:w-1/2 xl:w-1/3">
      <div class="p-6 text-center">
        <h2 class="title-component">
        Register
      </h2>
      <form @submit.prevent="onSubmit">
        <div class="mt-4">
          <label
            for="username"
            class="text-label"
            >Username:</label
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
            for="username"
            class="text-label"
            >Email</label
          >
          <input
            type="text"
            id="email"
            v-model="email"
            required
            class="input-style"
          />
        </div>
        <div class="mt-4">
          <label
            for="password"
            class="text-label"
            >Password</label
          >
          <input
            type="text"
            id="password"
            v-model="password"
            required
            class="input-style"
          />
        </div>
        <div class="mt-8">
          <button
            type="submit"
            class="button-add w-full"
          >
            Register
          </button>
        </div>
      </form>
      <p class="text-center  mt-4">
      <router-link to="/login" class="register-link-style "
        >Go Back</router-link
      >
    </p>
      <p v-if="errorMessage" class="mt-4 text-red-500">{{ errorMessage }}</p>
      </div>
      
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import api from "../services/api";
import { onBeforeRouteLeave, onBeforeRouteUpdate, useRouter } from "vue-router";

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
      errorMessage.value = '';
      router.push('/login');
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
// Clean message error, cause if i go to register, an d then go back the error message still there
onBeforeRouteLeave(() => {
  username.value = '';
  email.value = '';
  password.value = '';
  errorMessage.value = '';
});
</script>

<style scoped>
.register-link-style{
  @apply text-primary hover:underline;
}
</style>
