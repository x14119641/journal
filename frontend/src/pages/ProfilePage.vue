<template>
  <div class="p-6 bg-white rounded-lg shadow-lg">
    <h1 class="text-3xl font-semibold text-center text-indigo-600 mb-6">Profile Page</h1>
    <div v-if="username" class="text-center">
      <p class="text-lg">Welcome, {{ username }}</p>
      <p>ID: {{ id }}</p>
      <p>Email: {{ email }}</p>
      <p>Created At: {{ created_at }}</p>
    </div>
    <button
        @click="authStore.logout"
        class="mt-4 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600"
      >
        Logout
      </button>
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