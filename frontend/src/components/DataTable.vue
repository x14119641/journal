<template>
    <div class="overflow-auto" style="max-height: 300px;">
        <table class="w-full text-center">
            <thead>
                <tr>
                    <th v-for="(header, headerIndex) in headers" :key="headerIndex"
                    class="py-2 px-4 border-b border-gray-300">
                        {{ header }}
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(row, rowIndex) in rows" :key="rowIndex">
                    <td v-for="(value, colIndex) in Object.values(row)" :key="colIndex"
                    class="py-2 px-4 border-b border-gray-300">
                        {{ value }}
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