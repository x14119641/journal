import { defineStore } from "pinia";
import api from "../services/api";



export const usePortfolioStore = defineStore('portfolio', {
    state: () => ({
        accountValue: 0,
        total_spent:0,
        cash:0,
        tickers_in_portfolio: [] as string[],
        realized_gains:0
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
                const response = await api.get('/portfolio/funds/totals')
                
                this.total_spent = response.data.total_spent
                this.accountValue = response.data.total_funds
                this.cash = this.accountValue -  this.total_spent
                this.realized_gains = response.data.total_gains
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