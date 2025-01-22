<template>
    <div class="overflow-auto" style="max-height: 300px;">
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
                    <td v-for="(value, colIndex) in Object.values(row)" :key="colIndex"
                    class="py-3 px-6 border-b border-gray-700 text-gray-400 text-sm">
                    <template v-if="Object.keys(row)[colIndex] === 'ticker'">
                        <router-link :to="`/stocks/${value}`" class="text-lime-400 hover:underline">
                            {{ value }}
                        </router-link>
                        </template>
                        <template v-else>
                        {{ value }}
                    </template>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<script setup lang="ts">

defineProps<{
    headers:string[];
    rows:Record<string, any>[];
}>();
</script>