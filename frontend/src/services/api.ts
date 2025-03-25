import axios from "axios";
import { useAuthStore } from "../stores/authStore";


const api = axios.create({
    baseURL: 'http://localhost:8000'
});


api.interceptors.request.use(
    (config) => {
        const authStore = useAuthStore();
        if (authStore.token) {
            config.headers.Authorization = `Bearer ${authStore.token}`
        }
        return config;
    },
    (error) => Promise.reject(error)
);


export default api;