<template>
  <div class="p-6 text-center">
    <h3 class="title-component">User Profile</h3>
    <div class="mt-2 space-y-2">
      <div class="flex justify-between">
        <span class="text-label">User ID</span>
        <span class="text-value">{{ id }}</span>
      </div>
      <div class="flex justify-between">
        <span class="text-label">Username</span>
        <span class="text-value">{{ username }}</span>
      </div>
      <div class="flex justify-between">
        <span class="text-label">Email</span>
        <span class="text-value email-style">{{ email }}</span>
      </div>
      <div class="flex justify-between">
        <span class="text-label">Created At</span>
        <span class="text-value">{{ created_at }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import api from "../services/api";
import { useAuthStore } from "../stores/authStore";
import moment from "moment";

const authStore = useAuthStore();

const id = ref<number>();
const username = ref<string>("");
const email = ref<string>("");
const created_at = ref<string>("");

onMounted(async () => {
  if (authStore.token) {
    try {
      const response = await api.get("/users/me/items");
      id.value = response.data.id;
      username.value = response.data.username;
      email.value = response.data.email;
      let strDate = moment(response.data.created_at).format("DD-MMM-YYYY");
      created_at.value = strDate;
    } catch (error) {
      console.error("Error fetching data: ", error);
    }
  } else {
    console.error("No token found, user is not authenticated.");
  }
});
</script>
<style scoped>
.email-style {
  @apply text-blue-700 dark:text-blue-400;
}
</style>
