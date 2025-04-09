import { defineStore } from 'pinia';
import api from '../services/api';
import router from '../router';
import { jwtDecode } from 'jwt-decode';

export const useAuthStore = defineStore('auth', {
    state: () => ({
        token: localStorage.getItem('token') || '',
        refreshToken: localStorage.getItem('refreshToken') || '',
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
                this.refreshToken = response.data.refresh_token;
                localStorage.setItem('token', this.token);
                localStorage.setItem('refreshToken', this.refreshToken);
                
                await this.fetchUser();
                router.push('/profile'); 
            } catch (error) {
                console.error('Login error:', error);
                this.errorMessage = 'Invalid username or password';
            }
        },
        async fetchUser() {

            try {
                const response = await api.get('http://localhost:8000/users/me');
                console.log(response)
                this.username = response.data.username;
                this.id = response.data.id;
            } catch (error) {
                console.error('Error fetching user data:', error);
            }
        },
        async forgotPassword(email:string) {
            try {
                const response = await api.post('http://localhost:8000/forgot-password', { email });
                console.log(response)
                this.errorMessage = response.data;
            } catch (error) {
                console.error('Error resetPassword:', error);
            }
        },
        async resetPassword(password:string) {
            try {
                const response = await api.post('http://localhost:8000/reset-password', { password },
                    {
                        headers: {
                          Authorization: `Bearer ${this.token}`
                        }
                      }
                );
                console.log(response)
                this.token = response.data.access_token;
                this.refreshToken = response.data.refresh_token;
                localStorage.setItem('token', this.token);
                localStorage.setItem('refreshToken', this.refreshToken);
                
                await this.fetchUser();
                router.push('/profile'); 
            } catch (error) {
                console.error('ErrorupdatePassword:', error);
            }
        },
        async logout() {
            await api.post('/logout', {
                refresh_token: this.refreshToken
                }
              );
            console.log("The token: ", this.refreshToken)
            this.removeToken()
            router.push('/login')
        },
        removeToken() {
            this.token = ''
            this.username = ''
            this.refreshToken = ''
            localStorage.removeItem('token')
            localStorage.removeItem('refreshToken')
        },
    },
});