<template>
  <div class="min-h-screen bg-gray-100 p-6">
    <!-- <div v-if="error_message">{{ tickers }}</div> -->
    <div class="flex justify-center mb-4">
      <input
        type="text"
        v-model="filter_ticker"
        placeholder="Filter by ticker"
        class="border-gray-300 rounded-md px-3 py-2 mr-2 w-64 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent"
      />
      <button
        @click="applyFilter"
        :disabled="!filter_ticker"
        class="bg-blue-500 text-white mr-2 px-4 py-2 rounded-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-opacity-75"
      >
        Search
      </button>
      <button
        @click="addRemoveFavorite"
        class="bg-transparent ml-20 py-2 px-4 border rounded-md min-w-32"
        :class="
          is_favorite
            ? ' hover:text-fuchsia-300  hover:border-fuchsia-300 border-fuchsia-400'
            : ' hover:text-lime-400  hover:border-lime-300 border-lime-400'
        "
      >
        {{ folowing_str }}
      </button>
    </div>
    
    <!-- <div>{{ my_favorites }}</div>
    <span> {{ is_favorite }}</span> <span>{{ filter_ticker }}</span>
     -->
    <div class="bg-white p-6 rounded-lg shadow-lg">
      <table class="min-w-full table-auto">
        <thead>
          <tr class="bg-gray-200">
            <th
              v-for="(key, index) in columns"
              :key="index"
              class="px-4 py-2 text-left text-sm font-medium text-gray-600"
            >
              {{ key }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(dividend, index) in dividends"
            :key="index"
            class="border-b border-gray-200 hover:bg-gray-50"
          >
            <td
              v-for="(key, index) in columns"
              :key="index"
              class="px-4 py-2 text-sm text-gray-700"
            >
              {{ dividend[key] }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, computed, onMounted } from "vue";
import api from "../services/api";
import { type Dividend } from "../models/models";
import { useFavoriteStocksStore } from "../stores/favoriteStocksStore";

export default {
  setup() {
    const dividends = ref<Dividend[]>([]);
    const filter_ticker = ref<String>("");
    const error_message = ref<String>("");
    const favoriteStore = useFavoriteStocksStore();
    // const my_favorites = ref<Ticker[]>([]);

    const my_favorites = computed(() => {
      return favoriteStore.favorites.map((fav) => fav.ticker);
    });

    onMounted(async () => {
      await favoriteStore.getFavorites();
      my_favorites.value = favoriteStore.favorites.map((fav) => fav.ticker);
    });

    const columns = computed(() => {
      if (dividends.value.length > 0) {
        return Object.keys(dividends.value[0]);
      }
      return [];
    });

    const is_favorite = computed(() => {
      return my_favorites.value.includes(filter_ticker.value.toUpperCase());
    });

    const folowing_str = computed(() => {
      return is_favorite.value ? "Unfollow" : "Follow";
    });

    

    const applyFilter = async () => {
      try {
        const response = await api.get(
          `/stocks/dividends/${filter_ticker.value.toUpperCase()}`
        );
        dividends.value = response.data;
      } catch (error) {
        console.error("Errro to getch data: ", error);
        error_message.value = "Failed to load message";
      }
    };

    const addRemoveFavorite = async () => {
  const ticker = filter_ticker.value.toUpperCase();
  try {
    if (is_favorite.value) {
      // If the ticker is already a favorite, remove it
      await api.delete(`stocks/dividends/myfavorites/remove?ticker=${ticker}`);
      favoriteStore.favorites = favoriteStore.favorites.filter(
        (fav) => fav.ticker !== ticker
      );
    } else {
      // If the ticker is not a favorite, add it
      await api.post(`stocks/dividends/myfavorites/add?ticker=${ticker}`);
      favoriteStore.favorites.push({ ticker });
    }
  } catch (error) {
    console.error("Error while updating favorite:", error);
    error_message.value = "Failed to update favorite.";
  }
};

    return {
      dividends,
      my_favorites,
      is_favorite,
      folowing_str,
      columns,
      error_message,
      filter_ticker,
      applyFilter,
      addRemoveFavorite,
    };
  },
};
</script>

<style scoped>
/* You can add custom styles here if needed */
</style>
