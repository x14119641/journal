import { defineStore } from "pinia";
import api from "../services/api";
import type  {  FundsTransaction, StockTransaction, TransactionHistoryRecord } from "../models/models";
import { usePortfolioStore } from "./portfolioStore";



export const useTransactionsStore = defineStore('transactions', {
    state: () => ({
        total_transactions : 0,
        transaction_message_return:"",
        transactions_history: [] as TransactionHistoryRecord[],
        // sellTransaction: {} as StockSoldRecord, 
        default_limit:10
    }),
    actions: {
        async addFunds(transaction:FundsTransaction) {
            try {
                await api.post('transactions/add_funds', transaction);
                this.transaction_message_return = "Funds added successfully";
            } catch (error) {
                throw error;
            }
        },
        async withdrawFunds(transaction:FundsTransaction) {
            try {
                await api.post('transactions/withdraw_funds', transaction);
                this.transaction_message_return = "Funds withdrew successfully";
            } catch (error) {
                throw error;
            }
        },
        async buyStock(transaction:StockTransaction) {
            try {
                const response = await api.post('transactions/buy_stock', transaction);
                this.transaction_message_return = response.data.message;
            } catch (error) {
                throw error;
            }
        },
        async sellStock(transaction:StockTransaction) {
            try {
                const response = await api.post('transactions/sell_stock', transaction);
                this.transaction_message_return = response.data.message;
            } catch (error) {
                throw error;
            }
        },
        async getTransactionHistory() {
            try {
                const response = await api.get('transactions/get_transaction_history');
                this.transactions_history = [...response.data];
            } catch (error) {
                throw error;
            }
        },
        // async getLatestTransactions(limit?:number) {
        //     const finalLimit = limit || this.default_limit
        //     try {
        //         const response = await api.get('transactions/latest', {params:{limit:finalLimit}});
        //         this.latest_transactions = [...response.data]
        //     } catch (error) {
        //         throw error;
        //     }
        // },
    }
})