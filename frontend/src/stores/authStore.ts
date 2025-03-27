import { defineStore } from 'pinia';
import api from '../services/api';
import router from '../router';
import { jwtDecode } from 'jwt-decode';

export const useAuthStore = defineStore('auth', {
    state: () => ({
        token: localStorage.getItem('token') || '',
        username: '',
        id:'',
        errorMessage: '',
    }),
    actions: {
        isTokenExpired() {
            if (!this.token) return true;
            const { exp } = jwtDecode(this.token);
            const currentTime = Math.floor(Date.now() / 1000);
            return exp < currentTime;
        },
        async login(username: string, password: string) {
            try {
                console.log("Login function called");
                const response = await api.post(
                    'http://localhost:8000/login',
                    new URLSearchParams({username,password,}),
                    {headers: {'Content-Type': 'application/x-www-form-urlencoded',},
                });
                console.log("API Response:", response.data); 
                this.token = response.data.access_token;
                localStorage.setItem('token', this.token);
                await this.fetchUser();
                router.push('/profile'); 
            } catch (error) {
                console.error('Login error:', error);
                this.errorMessage = 'Invalid username or password';
            }
        },
        async fetchUser() {
            if (this.isTokenExpired()) {
                this.logout();
                return;
            }
            try {
                const response = await api.get('http://localhost:8000/users/me', {
                    headers: {Authorization: `Bearer ${this.token}`,},
                });
                console.log(response)
                this.username = response.data.username;
                this.id = response.data.id;
            } catch (error) {
                console.error('Error fetching user data:', error);
            }
        },
        async resetPassword(email:string) {
            try {
                const response = await api.post('http://localhost:8000/auth/reset-password', { email });
                console.log(response)
                this.errorMessage = response.data;
            } catch (error) {
                console.error('Error fetching user data:', error);
            }
        },
        logout() {
            this.token = ''
            this.username = ''
            this.username = ''
            localStorage.removeItem('token')
            router.push('/login')
        },
        removeToken() {
            this.token = ''
            this.username = ''
            this.username = ''
            localStorage.removeItem('token')
        },
    },
});