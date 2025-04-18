<template>
  <div class="p-0">
    <form class="max-w-md mx-auto relative">
      <div class="relative">
        <!-- Search Input -->
        <input
          v-model="searchKey"
          @input="filterOptions"
          @focus="showDropdown = true"
          @blur="hideDropdown"
          type="search"
          class="block w-full px-3 py-2 pl-9 searchbox-input-style"
          placeholder="Search stock..."
        />

        <!-- Search Icon -->
        <div
          class="absolute inset-y-0 start-0 flex items-center pl-3 pointer-events-none"
        >
          <Search class="w-4 h-4 search-icon-style" />
        </div>

        <!-- Dropdown Suggestions -->
        <ul
          v-if="showDropdown && filteredOptions.length"
          class="absolute z-10 w-full mt-1 searchbox-ul-style"
        >
          <router-link
            v-for="option in filteredOptions.slice(0, 5)"
            :to="`/stocks/${option.ticker}`"
            class="block hover:bg-gray-200 dark:hover:bg-gray-600"
          >
            <li class="px-4 py-2 cursor-pointer searchbox-li-style">
              <div class="flex justify-between gap-3">
                <span class="searchbox-ticker-style">{{ option.ticker }}</span>
                <span class="searchbox-companyname-style truncate">{{
                  option.companyName
                }}</span>
              </div>
            </li>
          </router-link>
          <!-- <li
              v-for="option in filteredOptions.slice(0, 5)"
              :key="option.ticker"
              class="px-4 py-2 cursor-pointer searchbox-li-style"
            >

              <router-link
                :to="`/stocks/${option.ticker}`"
                :key="$route.fullPath" 
                class="block hover:bg-gray-200 dark:hover:bg-gray-600"
              >
                <div class="flex justify-between gap-3">
                  <span class="searchbox-ticker-style">{{ option.ticker }}</span>
                  <span class="searchbox-companyname-style truncate">{{ option.companyName }}</span>
                </div>
              </router-link>
            </li> -->
        </ul>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import { useTickersStore } from "../stores/tickersStore";
import { type TickerName } from "../models/models";
import { useRouter } from "vue-router";
import { Binoculars, Search } from "lucide-vue-next";

const tickersStore = useTickersStore();
const tickers = computed(() => tickersStore.tickers);
const router = useRouter();

const searchKey = ref("");
const showDropdown = ref(false);
const filteredOptions = ref<TickerName[]>([]);

// Filter options based on search input
const filterOptions = () => {
  if (!searchKey.value.trim()) {
    filteredOptions.value = [];
    return;
  }
  filteredOptions.value = tickers.value.filter(
    (ticker) =>
      ticker.ticker.toLowerCase().includes(searchKey.value.toLowerCase()) ||
      ticker.companyName.toLowerCase().includes(searchKey.value.toLowerCase())
  );
};

// Handle option selection & ensure router updates
const selectOption = (option: TickerName) => {
  searchKey.value = option.ticker;
  showDropdown.value = false;

  // Manually push the route to ensure Vue updates
  router.push(`/stocks/${option.ticker}`);
};

// Hide dropdown after a short delay to allow selection
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
.searchbox-input-style{
  @apply text-sm text-green-800 bg-gray-200 dark:text-cyan-300 dark:bg-gray-700 border border-slate-600  rounded-lg  focus:ring-lime-400 focus:border-lime-300 ;
}

.search-icon-style{
  @apply text-gray-800 dark:text-gray-400;
}
.searchbox-input-style::placeholder{
  @apply text-sm italic text-gray-800 dark:text-cyan-300 ;
}
.searchbox-ul-style{
  @apply  text-green-800 bg-gray-200 dark:text-cyan-300 dark:bg-gray-700 border border-slate-600 rounded-lg shadow-lg;
}
.searchbox-li-style{
  @apply truncate text-sm  hover:bg-gray-400 ;
}
.searchbox-ticker-style{
  @apply font-bold text-blue-600 dark:text-lime-300 ;
}
</style>
