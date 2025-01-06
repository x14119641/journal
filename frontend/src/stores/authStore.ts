import { defineStore } from 'pinia';
import axios from 'axios';
import router from '../router';


export const useAuthStore = defineStore('auth', {
    state: () => ({
        token: localStorage.getItem('token') || '',
        username: '',
        id:'',
        errorMessage: '',
    }),
    actions: {
        async login(username: string, password: string) {
            try {
                const response = await axios.post(
                    'http://localhost:8000/login',
                    new URLSearchParams({username,password,}),
                    {headers: {'Content-Type': 'application/x-www-form-urlencoded',},
                });

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
            try {
                const response = await axios.get('http://localhost:8000/users/me', {
                    headers: {Authorization: `Bearer ${this.token}`,},
                });
                console.log(response)
                this.username = response.data.username;
                this.id = response.data.id;
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
    },
});