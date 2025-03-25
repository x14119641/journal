<template>
    <input
      type="text"
      v-model="selectedDate"
      id="custom-datetime"
      class="input-style"
      placeholder="DD-MM-YYYY HH:mm:ss"
    />
  </template>
  
  <script setup lang="ts">
  import { onMounted, nextTick, ref } from "vue";
  import flatpickr from "flatpickr";
  import "flatpickr/dist/flatpickr.min.css";
  
  const selectedDate = ref<string>("");
  
  onMounted(async () => {
    await nextTick(); // Ensure DOM is ready before applying Flatpickr
  
    flatpickr("#custom-datetime", {
      enableTime: true,
      enableSeconds: true,
      dateFormat: "d-m-Y H:i:S",
      allowInput: true,
      time_24hr: true,
      defaultHour: 12,
      defaultMinute: 0,
      defaultSeconds: 0,
      onChange: (selectedDates) => {
        if (selectedDates.length > 0) {
          selectedDate.value = selectedDates[0].toLocaleString("sv-SE"); // Format it properly
        }
      },
    });
  });
  </script>
  
  <style scoped>

  </style>
  