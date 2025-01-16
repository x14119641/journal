import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// Get the directory name using import.meta.url
const __dirname = new URL('.', import.meta.url).pathname

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': `${__dirname}src`, // Use template literal to build path
    }
  }
})