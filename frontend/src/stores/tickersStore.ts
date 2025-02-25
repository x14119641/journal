import { defineStore } from "pinia";
import api from "../services/api";
import { type TickerName } from "../models/models";

export const useTickersStore = defineStore('tickers', {
    state: () => ({
        tickers: [] as TickerName[],
    }),
    actions: {
        async getTickers() {
            try {
                const response = await api.get('/stocks/tickers')
                this.tickers = [...response.data]
            } catch (error) {
                console.error('Error un tickers store: ', error)
            }
        }
    }
})