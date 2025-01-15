import { defineStore } from 'pinia';
import api from '../services/api';

export const useFavoriteStocksStore = defineStore('favorites', {
    state: () => ({
        favorites: [] as Array<Object>
    }),
    actions: {
        async getFavorites() {
            try {
                const response = await api.get('/stocks/dividends/myfavorites');
                this.favorites = response.data;
            } catch (error) {
                console.error('Getting Favourites error:', error);
            }
        }
    }
})