<template>
    <div class="p-0 w-full">
      <div class="relative">
        <!-- Search Input -->
        <input
          v-model="searchKey"
          @input="filterOptions"
          @focus="showDropdown = true"
          @blur="hideDropdown"
          type="search"
          class="block w-full px-3 py-2 pl-9 searchbox-input-style"
          placeholder="Select Stock"
        />
  
        <!-- Search Icon -->
        <div class="absolute inset-y-0 start-0 flex items-center pl-3 pointer-events-none">
            <TrendingUp class="w-4 h-4 text-gray-800 dark:text-gray-400" />
        </div>
  
        <!-- Dropdown Suggestions -->
        <ul
          v-if="showDropdown && filteredOptions.length"
          class="absolute z-10 w-full mt-1 searchbox-ul-style"
        >
          <li
            v-for="option in filteredOptions.slice(0, 5)"
            :key="option.ticker"
            class="px-4 py-2 cursor-pointer searchbox-li-style"
            @click="selectOption(option)"
          >
            <div class="flex justify-between gap-3">
              <span class="searchbox-ticker-style">{{ option.ticker }}</span>
              <span class="searchbox-companyname-style truncate">
                {{ option.companyName }}
              </span>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, computed, onMounted, watch } from "vue";
  import { useTickersStore } from "../stores/tickersStore";
  import type { TickerName } from "../models/models";
  import { TrendingUp } from "lucide-vue-next";
  // Props
  const props = defineProps<{
    modelValue: string;
  }>();
  const emit = defineEmits(["update:modelValue"]);
  
  // Store and state
  const tickersStore = useTickersStore();
  const tickers = computed(() => tickersStore.tickers);
  
  const searchKey = ref(props.modelValue);
  const showDropdown = ref(false);
  const filteredOptions = ref<TickerName[]>([]);
  
  // Watch v-model changes
  watch(() => props.modelValue, (val) => {
    searchKey.value = val;
  });
  
  // Filter logic
const filterOptions = () => {
  const keyword = searchKey.value.trim().toLowerCase();
  if (!keyword) {
    filteredOptions.value = [];
    return;
  }

  filteredOptions.value = tickers.value
    .filter(
      (ticker) =>
        ticker.ticker.toLowerCase().includes(keyword) ||
        ticker.companyName.toLowerCase().includes(keyword)
    )
    .sort((a, b) => {
      const aTicker = a.ticker.toLowerCase();
      const bTicker = b.ticker.toLowerCase();

      // Exact match first
      if (aTicker === keyword) return -1;
      if (bTicker === keyword) return 1;

      // Starts with match next
      if (aTicker.startsWith(keyword) && !bTicker.startsWith(keyword)) return -1;
      if (!aTicker.startsWith(keyword) && bTicker.startsWith(keyword)) return 1;

      // Otherwise, leave order unchanged
      return 0;
    });
};
  
  const selectOption = (option: TickerName) => {
    searchKey.value = option.ticker;
    emit("update:modelValue", option.ticker);
    showDropdown.value = false;
  };
  
  const hideDropdown = () => {
    setTimeout(() => {
      showDropdown.value = false;
    }, 200);
  };
  
  onMounted(async () => {
    await tickersStore.getTickers();
  });
  </script>
  
  <style scoped>
  .searchbox-input-style {
    @apply text-sm text-green-800 bg-gray-200 dark:text-cyan-300 dark:bg-gray-700 border border-slate-600 rounded-lg focus:ring-lime-400 focus:border-lime-300;
  }
  .search-icon-style {
    @apply text-gray-800 dark:text-gray-400;
  }
  .searchbox-input-style::placeholder {
    @apply text-sm italic text-gray-800 dark:text-cyan-300;
  }
  .searchbox-ul-style {
    @apply text-green-800 bg-gray-200 dark:text-cyan-300 dark:bg-gray-700 border border-slate-600 rounded-lg shadow-lg;
  }
  .searchbox-li-style {
    @apply truncate text-sm hover:bg-gray-400;
  }
  .searchbox-ticker-style {
    @apply font-bold text-blue-600 dark:text-lime-300;
  }
  </style>
  