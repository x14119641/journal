<template>
  <div class="p-6 text-center">
    <h3 v-if="title" class="datatable-title">{{ title }}</h3>
    <div class="overflow-auto">
      <table class="w-full text-center border-collapse">
        <thead>
          <tr class="bg-gray-800 datatable-cell-title">
            <th
              v-for="(header, headerIndex) in headers"
              :key="headerIndex"
              class="py-3 px-6 border-b border-lime-300 text-sm font-medium tracking-wider uppercase"
            >
              {{ header }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(row, rowIndex) in rows"
            :key="rowIndex"
            class="hover:bg-gray-700 transition-colors duration-200"
          >
            <td
              v-for="header in headers"
              :key="header"
              class="py-3 px-6 border-b border-gray-700 datatable-cell-text"
            >
              <template v-if="header === 'ticker'">
                <router-link
                  :to="`/stocks/${row[header]}`"
                  class="datatable-cell-link"
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
  </div>
</template>

<script setup lang="ts">
defineProps<{
  title?: string;
  headers: string[];
  rows: Record<string, any>[];
}>();
</script>
