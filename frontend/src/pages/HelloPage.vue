<template>
    <p>{{ message }}</p>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'

const message = ref<string>('');

onMounted(async () => {
    try {
        const response = await axios.get('http:localhost:8000/hello')
        message.value = response.data.message
    } catch (error) {
        console.error('Errro to getch data: ', error)
        message.value = 'Failed to load message'
    }
})
</script>