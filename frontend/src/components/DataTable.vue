<template>
    <div class="p-6 text-center">
      <h3 v-if="title" class="datatable-title mb-4">{{ title }}</h3>
      <!-- Use overflow-x-auto to only allow horizontal scrolling -->
      <div class="w-full overflow-x-auto">
        <table class="w-full table-fixed text-center border-collapse">
          <thead>
            <tr class=" datatable-cell-title">
              <th
                v-for="(header, headerIndex) in headers"
                :key="headerIndex"
                class="py-3 px-6 border-b border-lime-300 text-sm font-medium tracking-wider "
              >
              {{ formattedHeaders ? formattedHeaders[headerIndex]:header }}
              </th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="(row, rowIndex) in paginatedRows"
              :key="rowIndex"
              class="hover:bg-gray-700 transition-colors duration-200"
            >
              <td
                v-for="header in headers"
                :key="header"
                class="py-3 px-6 border-b border-gray-700 datatable-cell-text break-words"
              >
                <template v-if="header === 'ticker'">
                  <router-link
                    :to="`/stocks/${row[header]}`"
                    class="datatable-cell-link text-blue-500 hover:underline"
                  >
                    {{ row[header] }}
                  </router-link>
                </template>
                <template v-else>
                  {{ row[header] }}
                </template>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- Pagination Controls -->
      <div class="mt-4 flex justify-center items-center space-x-4">
        <button
          @click="prevPage"
          :disabled="currentPage === 1"
          class="px-3 py-1 bg-gray-700 text-white rounded disabled:opacity-50"
        >
          Previous
        </button>
        <span class="text-gray-200">
          Page {{ currentPage }} of {{ totalPages }}
        </span>
        <button
          @click="nextPage"
          :disabled="currentPage === totalPages"
          class="px-3 py-1 bg-gray-700 text-white rounded disabled:opacity-50"
        >
          Next
        </button>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, computed } from 'vue';
  
  const props = defineProps<{
    title?: string;
    headers: string[];
    rows: Record<string, any>[];
    formattedHeaders?: string[];
    pagingNumber?:number;
  }>();
  
  const currentPage = ref(1);
  const itemsPerPage = computed(() => props.pagingNumber || 10)
  
  const totalPages = computed(() => Math.ceil(props.rows.length / itemsPerPage.value) || 1);
  
  const paginatedRows = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage.value;
    return props.rows.slice(start, start + itemsPerPage.value);
  });
  
  const prevPage = () => {
    if (currentPage.value > 1) currentPage.value--;
  };
  
  const nextPage = () => {
    if (currentPage.value < totalPages.value) currentPage.value++;
  };
  </script>
  
  <style scoped>
  /* Additional custom styles if needed */
  </style>
  