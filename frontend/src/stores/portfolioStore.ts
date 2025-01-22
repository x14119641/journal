import { defineStore } from "pinia";
import api from "../services/api";



export const usePortfolioStore = defineStore('portfolio', {
    state: () => ({
        total_funds: 0,
        total_spent:0,
        tickers_in_portfolio: [] as string[]
    }),
    actions: {
        async getPortfolio() {
            try {
                const response = await api.get('/portfolio')
                this.tickers_in_portfolio = [...response.data]
            } catch (error) {
                throw error;
            }
        },
        async getFunds() {
            try {
                const response = await api.get('/portfolio/funds')
                this.total_funds = response.data.total_funds
                this.total_spent = response.data.total_spent
            } catch (error) {
                throw error;
            }
        },
        async addFunds(total_funds_to_add:number) {
            try {
                const response = await api.post(`portfolio/funds/add?amount=${total_funds_to_add}`);
                await this.getFunds()
            } catch (error) {
                throw error;
            }
        },
        async removeFunds(total_funds_to_remove:number) {
            try {
                const response = await api.post(`portfolio/funds/withdraw?amount=${total_funds_to_remove}`);
                await this.getFunds()
            } catch (error) {
                throw error;
            }
        },
        
    }
})