import axios from 'axios';
import { useAuthStore } from '../stores/authStore';

const api = axios.create({
  baseURL: 'http://localhost:8000',
});

// ✅ Attach access token to requests (unless manually set)
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  config.headers = config.headers || {};

  if (!config.headers['Authorization']) {
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
  }

  return config;
});

let isRefreshing = false;
let refreshPromise: Promise<string> | null = null;
let failedQueue: any[] = [];

function processQueue(error: any, token: string | null = null) {
  failedQueue.forEach(p => {
    if (error) {
      p.reject(error);
    } else {
      p.resolve(token);
    }
  });
  failedQueue = [];
}

api.interceptors.response.use(
  response => response,
  async error => {
    const originalRequest = error.config;

    // If not 401 or already retried, reject
    if (
      error.response?.status !== 401 ||
      originalRequest._retry ||
      !localStorage.getItem('refreshToken')
    ) {
      return Promise.reject(error);
    }

    originalRequest._retry = true;

    // If already refreshing, queue this request
    if (isRefreshing) {
      return new Promise((resolve, reject) => {
        failedQueue.push({
          resolve: (token: string) => {
            originalRequest.headers['Authorization'] = `Bearer ${token}`;
            resolve(api(originalRequest));
          },
          reject,
        });
      });
    }

    // ✅ Set isRefreshing BEFORE any async logic
    isRefreshing = true;
    const refreshToken = localStorage.getItem('refreshToken');

    // Start refresh call
    refreshPromise = axios.post('http://localhost:8000/refresh', null, {
      headers: {
        Authorization: `Bearer ${refreshToken}`,
      },
    }).then(res => {
      const newAccessToken = res.data.access_token;
      const newRefreshToken = res.data.refresh_token;

      // ✅ Update authStore + localStorage
      const authStore = useAuthStore();
      authStore.token = newAccessToken;
      authStore.refreshToken = newRefreshToken;
      localStorage.setItem('token', newAccessToken);
      localStorage.setItem('refreshToken', newRefreshToken);

      processQueue(null, newAccessToken);
      return newAccessToken;
    }).catch(err => {
      processQueue(err, null);
      localStorage.removeItem('token');
      localStorage.removeItem('refreshToken');
      const authStore = useAuthStore();
      authStore.removeToken?.();
      window.location.href = '/login';
      throw err;
    }).finally(() => {
      isRefreshing = false;
      refreshPromise = null;
    });

    try {
      const newToken = await refreshPromise;
      originalRequest.headers['Authorization'] = `Bearer ${newToken}`;
      return api(originalRequest);
    } catch (err) {
      return Promise.reject(err);
    }
  }
);

export default api;
