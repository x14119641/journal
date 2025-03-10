<template>
  <div class="slate-container">
    <AddFunds />
  </div>
</template>

<script setup lang="ts">
import { onMounted, nextTick, ref } from "vue";
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css"; // Import styles
import AddFunds from "../components/AddFunds.vue";
const amount = ref<number | null>(null);
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
  });
});

const submitForm = () => {
  console.log("Amount:", amount.value);
  console.log("Selected Date:", selectedDate.value);
};
</script>
