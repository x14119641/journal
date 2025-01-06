<template>
  <div class="min-h-screen bg-gray-100 p-6">
    <div class="bg-white p-6 rounded-lg shadow-lg">
      <h2 class="text-2xl font-semibold text-gray-700 text-center mb-6">
        User List
      </h2>
      <table class="min-w-full table-auto">
        <thead>
          <tr class="bg-gray-200">
            <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">ID</th>
            <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Username</th>
            <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Email</th>
            <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Created At</th>
            <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Status</th>
            <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="user in users"
            :key="user.id"
            class="border-b border-gray-200 hover:bg-gray-50"
          >
            <td class="px-4 py-2 text-sm text-gray-700">{{ user.id }}</td>
            <td class="px-4 py-2 text-sm text-gray-700">{{ user.username }}</td>
            <td class="px-4 py-2 text-sm text-gray-700">{{ user.email }}</td>
            <td class="px-4 py-2 text-sm text-gray-700">{{ user.created_at }}</td>
            <td
              class="px-4 py-2 text-sm font-semibold"
              :class="user.active ? 'text-green-500' : 'text-red-500'"
            >
              {{ user.active ? 'Active' : 'Inactive' }}
            </td>
            <td class="px-4 py-2 text-sm text-gray-700">
              <button
                @click="handleAction(user.id)"
                class="text-blue-500 hover:text-blue-700"
              >
                Action
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

// Example users data (JSON response like structure)
const users = ref([
  {
    id: '1',
    username: 'john_doe',
    email: 'john.doe@example.com',
    created_at: '2022-01-15',
    active: true,
  },
  {
    id: '2',
    username: 'jane_smith',
    email: 'jane.smith@example.com',
    created_at: '2021-11-20',
    active: false,
  },
  {
    id: '3',
    username: 'alice_jones',
    email: 'alice.jones@example.com',
    created_at: '2023-02-10',
    active: true,
  },
  {
    id: '4',
    username: 'bob_brown',
    email: 'bob.brown@example.com',
    created_at: '2020-09-05',
    active: true,
  },
  {
    id: '5',
    username: 'carol_white',
    email: 'carol.white@example.com',
    created_at: '2022-04-25',
    active: false,
  },
  {
    id: '6',
    username: 'dave_black',
    email: 'dave.black@example.com',
    created_at: '2021-07-13',
    active: true,
  },
]);

// Function to handle action click
function handleAction(userId: string) {
  alert(`Action for user ID: ${userId}`);
}
</script>

<style scoped>
/* You can add custom styles here if needed */
</style>
