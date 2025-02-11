import { defineStore } from "pinia";
import api from "../services/api";
import { type Transaction } from "../models/models";
import { usePortfolioStore } from "./portfolioStore";



export const useTransactionsStore = defineStore('transactions', {
    state: () => ({
        total_transactions : 0,
        transaction_message_return:"",
        latest_transactions: [] as Transaction[],
        default_limit:10
    }),
    actions: {
        async addTransaction(transaction:Transaction) {
            try {
                const response = await api.post('transactions/add', transaction);
                this.transaction_message_return = response.data.message
                await this.getLatestTransactions()
                const portfolioStore = usePortfolioStore()
                await portfolioStore.getFunds()
                await portfolioStore.getPortfolio()
            } catch (error) {
                throw error;
            }
        },
        async getLatestTransactions(limit?:number) {
            const finalLimit = limit || this.default_limit
            try {
                const response = await api.get('transactions/latest', {params:{limit:finalLimit}});
                this.latest_transactions = [...response.data]
            } catch (error) {
                throw error;
            }
        },
    }
})