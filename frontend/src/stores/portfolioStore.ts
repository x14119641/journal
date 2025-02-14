import { defineStore } from "pinia";
import { type Fund, type Ticker } from "../models/models";
import api from "../services/api";
import  { type PortfolioItem } from "../models/models";
import { type AllocationRecord } from "../models/models";
import { type BarChartDataItem } from "../models/models";
import { type TickerPrice } from "../models/models";
import Decimal from "decimal.js";


export const usePortfolioStore = defineStore('portfolio', {
    state: () => ({
        accountValue: 0,
        total_spent:0,
        cash:0,
        latest_funds_transactions: [] as Fund[],
        portfolio: [] as PortfolioItem[],
        allocation_portfolio: [] as AllocationRecord[],
        portfolio_barchart_data: [] as latest_funds_transactionsItem[],
        portfolio_summary: [] as TickerPrice[],
        realized_gains:0,
        default_limit:10
    }),
    getters: {
        // Sum the totalValue field from portfolio_summary
        sumTotalValue(state): number {
          return state.portfolio_summary.reduce((acc, item) => {
            // Convert to number in case it is a string or Decimal type
            return acc + Number(item.totalValue);
          }, 0);
        },
        // Alternatively, if you want to sum marketValue instead:
        sumMarketValue(state): number {
          return state.portfolio_summary.reduce((acc, item) => {
            return acc + Number(item.marketValue);
          }, 0);
        },
        getTickersPortfolio(state):Ticker[] {
            return state.portfolio_summary.map((stock) => stock.ticker)
        },
        getUnrealizedGains(state): number {
            return state.portfolio_summary.reduce((acc, item) => {
              return acc + Number(item.marketValue);
            }, 0);
          },
      },
    actions: {
        async getFunds(limit?:number) {
            const finalLimit = limit || this.default_limit
            try {
                const response = await api.get('/portfolio/funds', {params:{limit:finalLimit}})
                this.latest_funds_transactions = [...response.data]
                await this.getFundsTotals()
            } catch (error) {
                throw error;
            }
        },
        async getPortfolio() {
            try {
                const response = await api.get('/portfolio/')
                this.portfolio = [...response.data]
            } catch (error) {
                throw error;
            }
        },
        async getPortfolioAllocation() {
            try {
                const response = await api.get('/portfolio/allocation')
                this.allocation_portfolio = [...response.data]
            } catch (error) {
                throw error;
            }
        },
        async getPortSummary() {
            try {
                const response = await api.get('/portfolio/summary')
                this.portfolio_summary = [...response.data]
            } catch (error) {
                throw error;
            }
        },
        async getPortfolioAllocationInitialCost() {
            try {
                const response = await api.get('/portfolio/allocation/inital_cost')
                this.portfolio_barchart_data = [...response.data]
            } catch (error) {
                throw error;
            }
        },
        async getFundsTotals() {
            try {
                const response = await api.get('/portfolio/funds/totals')
                
                this.total_spent = response.data.total_spent
                this.accountValue = response.data.total_funds
                this.realized_gains = response.data.total_gains
                this.cash = response.data.cash
            } catch (error) {
                throw error;
            }
        },
        async addFunds(total_funds_to_add:number) {
            try {
                await api.post(`portfolio/funds/add?amount=${total_funds_to_add}`);
                await this.getFunds()
            } catch (error) {
                throw error;
            }
        },
        async removeFunds(total_funds_to_remove:number) {
            try {
                await api.post(`portfolio/funds/withdraw?amount=${total_funds_to_remove}`);
                await this.getFunds()
            } catch (error) {
                throw error;
            }
        },
        
    }
})

