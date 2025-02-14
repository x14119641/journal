<template>
    <div v-if="title">
        <h3 class="text-xl font-semibold text-center text-white mb-2">{{ title }}</h3>
    </div>
    <div class="overflow-auto" >
        <table class="w-full text-center border-collapse">
            <thead>
                <tr class="bg-gray-800 text-gray-200">
                    <th v-for="(header, headerIndex) in headers" :key="headerIndex"
                    class="py-3 px-6 border-b border-gray-70 text-sm font-medium tracking-wider uppercase">
                        {{ header }}
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(row, rowIndex) in rows" :key="rowIndex"
                class="hover:bg-gray-700 transition-colors duration-200">
                    <td v-for="header in headers" :key="header"
                    class="py-3 px-6 border-b border-gray-700 text-gray-400 text-sm">
                    <template v-if="header === 'ticker'">
                        <router-link :to="`/stocks/${row[header]}`" class="text-lime-400 hover:underline">
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
</template>

<script setup lang="ts">

defineProps<{
    title?:string; 
    headers:string[];
    rows:Record<string, any>[];
}>();
</script>