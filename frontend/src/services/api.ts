import axios from "axios";
import { useAuthStore } from "../stores/authStore";
import router from '@/router'; 
import { storeToRefs } from "pinia";

const api = axios.create({
    baseURL: 'http://localhost:8000'
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});


export default api;