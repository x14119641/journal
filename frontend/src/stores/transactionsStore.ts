import { defineStore } from "pinia";
import api from "../services/api";
import type  {  StockTransactionHistoryRecord, FundsTransaction, SellStockTransaction, BuyStockTransaction, TransactionHistoryRecord, UpdateTransactionDescription, DeleteTransaction } from "../models/models";
import { usePortfolioStore } from "./portfolioStore";




export const useTransactionsStore = defineStore('transactions', {
    state: () => ({
        total_transactions : 0,
        transaction_message_return:"",
        transactions_history: [] as TransactionHistoryRecord[],
        stocks_transactions_history: [] as StockTransactionHistoryRecord[],
        transaction_detail: {} as TransactionHistoryRecord,
        // sellTransaction: {} as StockSoldRecord, 
        default_limit:10,
        transactionTypeOrDontExist:"",
        updateDescriptionMessage:"",
        deleteMessage:"",
    }),
    getters: {
        getFundsTransactions: (state) => {
            return state.transactions_history.filter((transaction) => transaction.ticker === null)
        },
        getTransactionType: (state) => {
            return state.transaction_detail.ticker===null ? 'Balance':'Stock'
        },
        getTransactionIsBalance: (state) => {
            return state.transaction_detail.ticker===null ? true:false
        },
        getTransactionIsStock: (state) => {
            return state.transaction_detail.ticker!==null ? true:false
        },
    },
    actions: {
        async addFunds(transaction:FundsTransaction) {
            try {
                const portfolioStore = usePortfolioStore();
                await api.post('transactions/add_funds', transaction);
                this.transaction_message_return = "Funds added successfully";
                const stockTransactionHistory = await this.getStocksTransactionsHistory();
                const transactionHistory = await this.getTransactionHistory();
                const portfolioUpdate = await portfolioStore.getPortfolio();
                await Promise.allSettled([stockTransactionHistory, transactionHistory, portfolioUpdate]);
                

            } catch (error) {
                throw error;
            }
        },
        async withdrawFunds(transaction:FundsTransaction) {
            try {
                await api.post('transactions/withdraw_funds', transaction);
                this.transaction_message_return = "Funds withdrew successfully";
                // Update everything throghout getPortfolio
                const portfolioStore = usePortfolioStore();
                const stockTransactionHistory = await this.getStocksTransactionsHistory();
                const transactionHistory = await this.getTransactionHistory();
                const portfolioUpdate = await portfolioStore.getPortfolio();
                await Promise.allSettled([stockTransactionHistory, transactionHistory, portfolioUpdate]);
                
            } catch (error) {
                throw error;
            }
        },
        async buyStock(transaction:BuyStockTransaction) {
            try {
                const response = await api.post('transactions/buy_stock', transaction);
                this.transaction_message_return = response.data.message;// Update everything throghout getPortfolio
                const portfolioStore = usePortfolioStore();
                await portfolioStore.getPortfolio();
                const stockTransactionHistory = await this.getStocksTransactionsHistory();
                const transactionHistory = await this.getTransactionHistory();
                const portfolioUpdate = await portfolioStore.getPortfolio();
                await Promise.allSettled([stockTransactionHistory, transactionHistory, portfolioUpdate]);
                
            } catch (error) {
                throw error;
            }
        },
        async sellStock(transaction:SellStockTransaction) {
            try {
                const response = await api.post('transactions/sell_stock', transaction);
                this.transaction_message_return = response.data.message;
                // Update everything throghout getPortfolio
                const portfolioStore = usePortfolioStore();
                await portfolioStore.getPortfolio();
                const stockTransactionHistory = await this.getStocksTransactionsHistory();
                const transactionHistory = await this.getTransactionHistory();
                const portfolioUpdate = await portfolioStore.getPortfolio();
                await Promise.allSettled([stockTransactionHistory, transactionHistory, portfolioUpdate]);
                
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
        async getStocksTransactionsHistory() {
            try {
                const response = await api.get('transactions/get_stocks_transactions_history');
                // this.stocks_transactions_history = [...response.data];
                this.stocks_transactions_history.splice(0, this.stocks_transactions_history.length, ...response.data);
            } catch (error) {
                throw error;
            }
        },
        async getTransactionById(transactionId:number) {
            try {
                const response = await api.get(`transactions/${transactionId}`);
                this.transaction_detail = response.data;
            } catch (error) {
                throw error;
            }
        },
        async getTransactionTypeOrDontExists(transactionId:number) {
            try {
                const response = await api.get(`transactions/${transactionId}/type`);
                this.transactionTypeOrDontExist = response.data.value;
            } catch (error) {
                throw error;
            }
        },
        async updateTransactionDescription(transaction:UpdateTransactionDescription) {
            try {
                const response = await api.post(
                    `transactions/${transaction.transaction_id.toString()}/description/update`,
                    transaction
                );
                this.updateDescriptionMessage = response.data.message;
            } catch (error) {
                throw error;
            }
        },
        async deleteTransaction(transaction:DeleteTransaction) {
            try {
                const response = await api.post(
                    `transactions/${transaction.transaction_id.toString()}/delete`,
                    transaction
                );
                this.deleteMessage = response.data.message;
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