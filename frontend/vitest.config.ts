import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue"
import path from "path";

console.log('Logged')
export default defineConfig({
    plugins: [vue()],
    resolve: {
        alias: {
            "@": path.resolve(__dirname, "src"),
            "@tests": path.resolve(__dirname, "tests")
        }
    },
    test: {
        globals: true,
        environment:"happy-dom",
        setupFiles: "tests/setup.ts"
    }
});