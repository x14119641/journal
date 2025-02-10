import { defineStore } from "pinia";
import { type Fund } from "../models/models";
import api from "../services/api";



export const usePortfolioStore = defineStore('portfolio', {
    state: () => ({
        accountValue: 0,
        total_spent:0,
        cash:0,
        latest_portfolio: [] as Fund[],
        realized_gains:0,
        default_limit:10
    }),
    actions: {
        async getPortfolio(limit?:number) {
            const finalLimit = limit || this.default_limit
            try {
                const response = await api.get('/portfolio/funds', {params:{limit:finalLimit}})
                this.latest_portfolio = [...response.data]
                console.log(this.latest_portfolio)
                await this.getFundsTotals()
            } catch (error) {
                throw error;
            }
        },
        async getFundsTotals() {
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
                await api.post(`portfolio/funds/add?amount=${total_funds_to_add}`);
                await this.getPortfolio()
            } catch (error) {
                throw error;
            }
        },
        async removeFunds(total_funds_to_remove:number) {
            try {
                await api.post(`portfolio/funds/withdraw?amount=${total_funds_to_remove}`);
                await this.getPortfolio()
            } catch (error) {
                throw error;
            }
        },
        
    }
})