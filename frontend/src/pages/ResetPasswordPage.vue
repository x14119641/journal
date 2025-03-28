<template>
  <div class="flex justify-center w-full transition-all">
    <div class="container-component w-full sm:w-96 md:w-2/3 lg:w-1/2 xl:w-1/3">
      <div class="p-6 text-center">
        <h2 class="title-component">Reset Password</h2>
        <form @submit.prevent="resetPassword">
          <div class="mt-4">
            <label for="password1" class="text-label">Set Passord</label>
            <input
              type="text"
              id="password1"
              v-model="password1"
              required
              class="input-style"
            />
          </div>
          <div class="mt-4">
            <label for="password2" class="text-label"
              >Type Again your Passord</label
            >
            <input
              type="text"
              id="password2"
              v-model="password2"
              required
              class="input-style"
            />
          </div>
          <div class="mt-4">
            <button type="submit" class="button-add w-full">Update</button>
          </div>
        </form>
        <p v-if="msg" class="mt-4 text-error">{{ msg }}</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {  ref } from "vue";
import { useAuthStore } from "../stores/authStore";
import { useRoute, useRouter } from "vue-router";

const route = useRoute();
const router = useRouter();
const password1 = ref("");
const password2 = ref("");
const msg = ref("");
const authStore = useAuthStore();



const resetPassword = async () => {
  msg.value = "";
  if (password1.value !== password2.value) {
    msg.value = "Passwords are not equal";
    return;
  }

  const token = route.query.token as string;

  if (!token) {
    msg.value = "Missing or invalid token";
    return;
  }

  try {
    await authStore.resetPassword(password1.value);
    await authStore.fetchUser()
    router.push("/profile"); // or login
  } catch (error) {
    msg.value = "Something went wrong. Try again.";
    console.error("Error in update password", error);
  }
};
</script>
