<template>
  
    <div class="p-6 text-center">
      <h3 class="text-lg font-semibold text-gray-300">User Profile</h3>
      <div class="mt-4 space-y-4">
        <div class="flex justify-between">
          <span class="font-medium text-gray-400">User ID</span>
          <span class="text-blue-200">{{ id }}</span>
        </div>
        <div class="flex justify-between">
          <span class="font-medium text-gray-400">Username</span>
          <span class="text-blue-200">{{ username }}</span>
        </div>
        <div class="flex justify-between">
          <span class="font-medium text-gray-400">Email</span>
          <span class="text-blue-200">{{ email }}</span>
        </div>
        <div class="flex justify-between">
          <span class="font-medium text-gray-400">Created At</span>
          <span class="text-blue-200">{{ created_at }}</span>
        </div>
      </div>
    </div>

</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import api from "../services/api";
import { useAuthStore } from "../stores/authStore";

const authStore = useAuthStore();

const id = ref<number>();
const username = ref<string>("");
const email = ref<string>("");
const created_at = ref<string>("");

onMounted(async () => {
  if (authStore.token) {
    try {
      const response = await api.get("http://localhost:8000/users/me/items");
      id.value = response.data.id;
      username.value = response.data.username;
      email.value = response.data.email;
      created_at.value = response.data.created_at;
    } catch (error) {
      console.error("Error fetching data: ", error);
    }
  } else {
    console.error("No token found, user is not authenticated.");
  }
});
</script>
