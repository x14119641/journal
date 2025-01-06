<template>
  <div class=" flex items-center justify-center">
    <div class="bg-gray-800 p-6 rounded-lg shadow-lg w-full max-w-lg">
      <div class="text-center mb-6">
        <h2 class="text-2xl font-semibold text-gray-300">Profile</h2>
      </div>

      <div class="space-y-4">
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

        <!-- <div class="flex justify-between">
          <span class="font-medium text-gray-600">Status</span>
          <span
            :class="user.active ? 'text-green-500' : 'text-red-500'"
            class="font-semibold"
          >
            {{ user.active ? 'Active' : 'Inactive' }}
          </span>
        </div> -->

      </div>

      <div class="mt-6 text-center">
        <button
          @click="authStore.logout"
          class="bg-fuchsia-600 text-white py-2 px-4 rounded hover:bg-fuchsia-500 focus:outline-none"
        >
          Logout
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useAuthStore } from '../stores/authStore';

const authStore = useAuthStore();

const id = ref<number>();
const username = ref<string>('');
const email = ref<string>('');
const created_at = ref<string>('');

onMounted(async () => {
  if (authStore.token) {
    try {
      const response = await axios.get('http://localhost:8000/users/me/items', {
        headers: { Authorization: `Bearer ${authStore.token}` },
      });
      id.value = response.data.id;
      username.value = response.data.username;
      email.value = response.data.email;
      created_at.value = response.data.created_at;
    } catch (error) {
      console.error('Error fetching data: ', error);
    }
  } else {
    console.error('No token found, user is not authenticated.');
  }
});
</script>