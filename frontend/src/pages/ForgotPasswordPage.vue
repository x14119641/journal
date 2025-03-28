<template>
  <div class="flex justify-center w-full transition-all">
    <div class="container-component w-full sm:w-96 md:w-2/3 lg:w-1/2 xl:w-1/3">
      <div class="p-6 text-center">
        <h2 class="title-component">Forgot Password?</h2>
        <form @submit.prevent="forgotPassword">
          <div class="mt-4">
            <label for="email" class="text-label">Insert Email</label>
            <input
              type="text"
              id="email"
              v-model="email"
              required
              class="input-style"
            />
          </div>
          <div class="mt-4">
            <button type="submit" class="button-add w-full">Reset</button>
          </div>
        </form>
        <p v-if="msg" class="mt-4 text-info">{{ msg }}</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { useAuthStore } from "../stores/authStore";

const email = ref<string>("");
const authStore = useAuthStore();
const msg = ref<string>("");

const forgotPassword = async () => {
  try {
    await authStore.forgotPassword(email.value);
    msg.value = authStore.errorMessage;
  } catch (error) {
    console.error("Error in forgot password", error);
  }
};
</script>
