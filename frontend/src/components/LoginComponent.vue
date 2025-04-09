<template>
  <div class="p-6 text-center ">
    <h3 class="title-component">Login</h3>
    <form @submit.prevent="onSubmit">
      <div class="mt-4">
        <label
          for="username"
          class="text-label"
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
          class="text-label"
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
        class="button-add w-full"
      >
        Login
      </button>
      </div>
      
    </form>
    <p class="text-center  mt-4">
      Don't have an account?
      <router-link to="/register" class="register-link-style"
        >Register here</router-link
      >.
    </p>
    <p class="text-center  mt-4">
      Forgot Password?
      <router-link to="/forgot-password"  class="register-link-style"
        >Click here</router-link
      >.
    </p>
    <p v-if="errorMessage" class="mt-4 text-error">{{ errorMessage }}</p>
  </div>

</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { useAuthStore } from "../stores/authStore";
import { onBeforeRouteLeave } from "vue-router";


const authStore = useAuthStore();

const errorMessage = ref<string>("");

const username = ref("");
const password = ref("");

const onSubmit = async () => {
  await authStore.login(username.value, password.value);
  errorMessage.value = authStore.errorMessage;
};

// Clean message error, cause if i go to register, an d then go back the error message still there
onBeforeRouteLeave(() => {
  username.value = '';
  password.value = '';
  errorMessage.value = '';
});

</script>

<style scoped>
.register-link-style{
  @apply text-primary hover:underline;
}
</style>
