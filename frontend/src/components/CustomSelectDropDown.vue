<template>
    <div class="relative w-full" v-click-away="() => open = false">
      <!-- Dropdown Button -->
      <button
        @click="toggleDropdown"
        class= "w-full flex justify-between custom-select"
      >
        <span class="custom-select-placeholder">{{ selectedLabel }}</span>
        <svg
          class="w-5 h-5 text-gray-600 dark:text-gray-300 transform"
          :class="open ? 'rotate-180' : 'rotate-0'"
          fill="currentColor"
          viewBox="0 0 20 20"
        >
          <path
            fill-rule="evenodd"
            d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
            clip-rule="evenodd"
          ></path>
        </svg>
      </button>
  
      <!-- Dropdown Menu -->
      <div
        v-if="open"
        class="absolute w-full mt-1 dropdown-style"
      >
        <div
          v-for="option in options"
          :key="option.value"
          @click="selectOption(option)"
          class="dropdown-row"
        >
          {{ option.label }}
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, computed } from "vue";
  
  // Define component props
  const props = defineProps({
    options: {
      type: Array as () => { value: string; label: string }[],
      required: true,
    },
    modelValue: {
      type: String,
      required: false,
      default: "",
    },
  });
  
  // Define emits to allow `v-model`
  const emit = defineEmits(["update:modelValue"]);
  
  // Dropdown state
  const open = ref(false);
  
  // Get the selected label
  const selectedLabel = computed(() => {
    const selectedOption = props.options.find(option => option.value === props.modelValue);
    return selectedOption ? selectedOption.label : "Select an option";
  });
  
  // Toggle dropdown open/close
  const toggleDropdown = () => {
    open.value = !open.value;
  };
  
  // Select an option and emit the value
  const selectOption = (option: { value: string; label: string }) => {
    emit("update:modelValue", option.value);
    open.value = false;
  };
  </script>

  
<style scoped>
.custom-select{
 @apply mt-1 p-2 rounded-lg  bg-slate-400 border-gray-300 shadow-sm focus:border-lime-400 focus:ring focus:ring-lime-200 focus:ring-opacity-50
}
.custom-select-placeholder{
  @apply  text-sm font-medium italic   text-gray-800 dark:text-slate-800;
}
.dropdown-style{
    @apply bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg shadow-lg z-50;
}
.dropdown-row{
    @apply px-4 py-2 cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-600;
}
</style>