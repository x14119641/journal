<template>
  <div class="scontainer-component">
    <AddFunds />
  </div>

  <div class="container-component">
    <CustomSelectDropDown v-model="selectedOption" :options="[
  { value: '', label: 'Select Last Year Payments' },
  { value: '1', label: 'Above 1' },
  { value: '2', label: 'Above 2' },
  { value: '3', label: 'Above 3' },
  { value: '4', label: 'Above 4' },
  { value: '5', label: 'Above 5' },
]"/>
    <p>Selected: {{ selectedOption }}</p>
  </div>
</template>

<script setup lang="ts">
import { onMounted, nextTick, ref } from "vue";
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css"; // Import styles
import AddFunds from "../components/AddFunds.vue";
import CustomSelectDropDown from "../components/CustomSelectDropDown.vue";

const amount = ref<number | null>(null);
const selectedDate = ref<string>("");
const selectedOption = ref("");
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
