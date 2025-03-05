import { defineStore } from "pinia";
import api from "../services/api";
import type {
     Fund,  Ticker,  PortfolioItem,
     SectorAllocationRecord,  PortfolioItemSummary,
     BarChartDataItem,  TickerPrice,
     RiskCalculatorRecord,
     PortfolioItemMontly,
     PortfolioItemSummaryExternal
} from "../models/models";

import Decimal from "decimal.js";



export const usePortfolioStore = defineStore('portfolio', {
    state: () => ({
        balance: 0,
        totalFees: 0,
        totalMoneyInvested: 0,
        currentPortfolioValue:0,
        netProfitLoss:0,
        unrealizedMoney:0,
        cash: 0,
        latest_funds_transactions: [] as Fund[],
        portfolio: [] as PortfolioItem[],
        sector_allocation_portfolio: [] as SectorAllocationRecord[],
        portfolio_barchart_data: [] as BarChartDataItem[],
        portfolio_summary: [] as TickerPrice[],
        realized_gains: 0,
        riskCalculatorValues: [] as RiskCalculatorRecord[],
        ticker_portfolio_summary: [] as PortfolioItemSummary[],
        portfolio_monthly_summary: {} as PortfolioItemMontly,
        portfolio_external_summary: {} as PortfolioItemSummaryExternal,
        default_limit: 10,
        errorMessage:""
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
        getTickersPortfolio(state): Ticker[] {
            return state.portfolio_summary.map((stock) => stock.ticker)
        },
        getTickerInPortfolio: (state) => {
            return (ticker: string): PortfolioItem[] => {
                return state.portfolio.filter((stock) => stock.ticker === ticker);
            };
        },
        getUnrealizedGains(state): number {
            return state.portfolio_summary.reduce((acc, item) => {
                return acc + Number(item.marketValue);
            }, 0);
        },
    },
    actions: {
        async getBalance() {
            try {
                const response = await api.get('/portfolio/get_balance')
                this.balance = response.data.value
            } catch (error) {
                this.errorMessage = "Error in balance"
                throw error;
            }
        },
        async getPortfolio() {
            try {
                const response = await api.get('portfolio/get_portfolio')
                this.portfolio = [...response.data]
            } catch (error) {
                this.errorMessage = "Portfolio is empty"
                throw error;
            }
        },
        async getTotalFees() {
            try {
                const response = await api.get('/portfolio/get_total_fees')
                this.totalFees = response.data.value
            } catch (error) {
                this.errorMessage = "Error in TotalFees"
                throw error;
            }
        },
        async getTotalMoneyInvested() {
            try {
                const response = await api.get('/portfolio/get_total_money_invested')
                this.totalMoneyInvested = response.data.value
            } catch (error) {
                this.errorMessage = "Error in get_total_money_invested"
                throw error;
            }
        },
        async getCurrentPortfolioValue() {
            try {
                const response = await api.get('/portfolio/get_current_portfolio_value')
                this.currentPortfolioValue = response.data.value
            } catch (error) {
                this.errorMessage = "Error in getCurrentPortfolioValue"
                throw error;
            }
        },
        async getNetProfitLoss() {
            try {
                const response = await api.get('/portfolio/get_net_profit_loss')
                this.netProfitLoss = response.data.value
            } catch (error) {
                this.errorMessage = "Error in getNetProfitLoss"
                throw error;
            }
        },
        async getTickerPortfolioSummary() {
            try {
                const response = await api.get('/portfolio/get_ticker_portfolio_summary')
                this.ticker_portfolio_summary = [...response.data]
            } catch (error) {
                this.errorMessage = "Error in getTickerPortfolioSummary"
                throw error;
            }
        },
        async getMonthlyPerformance() {
            try {
                const response = await api.get('/portfolio/get_monthly_performance')
                this.portfolio_monthly_summary = response.data
                
            } catch (error) {
                this.errorMessage = "Error in getMonthlyPerformance"
                throw error;
            }
        },
        async getSummaryExternal() {
            try {
                const response = await api.get('/portfolio/get_summary_external')
                this.portfolio_external_summary = response.data
                
            } catch (error) {
                this.errorMessage = "Error in get_summary_external"
                throw error;
            }
        },
        async getUnrealizedMoney() {
            try {
                const response = await api.get('/portfolio/get_unrealized_money')
                this.unrealizedMoney = response.data.value
                
            } catch (error) {
                this.errorMessage = "Error in get_unrealized_money"
                throw error;
            }
        },
        async getPortfolioAllocationSector() {
            try {
                const response = await api.get('/portfolio/allocation/sector')
                this.sector_allocation_portfolio = [...response.data]
            } catch (error) {
                this.errorMessage = "Error in getPortfolioAllocation"
                throw error;
            }
        },
        async getFunds(limit?: number) {
            const finalLimit = limit || this.default_limit
            try {
                const response = await api.get('/portfolio/funds', { params: { limit: finalLimit } })
                this.latest_funds_transactions = [...response.data]
                await this.getFundsTotals()
            } catch (error) {
                throw error;
            }
        },
        
        async getPortfolioSummary() {
            try {
                const response = await api.get('/portfolio/summary')
                this.portfolio_summary = [...response.data]
            } catch (error) {
                throw error;
            }
        },
        async getPortfolioTickerAggregate(ticker:string) {
            try {
                const response = await api.get(`/portfolio/summary/${ticker}`)
                return response.data
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
        async addFunds(total_funds_to_add: number) {
            try {
                await api.post(`portfolio/funds/add?amount=${total_funds_to_add}`);
                await this.getFunds()
            } catch (error) {
                throw error;
            }
        },
        async removeFunds(total_funds_to_remove: number) {
            try {
                await api.post(`portfolio/funds/withdraw?amount=${total_funds_to_remove}`);
                await this.getFunds()
            } catch (error) {
                throw error;
            }
        },
        async getRiskPortfolioTicker(stockPrice:number, capital: number, riskPortfolio=1, riskPercent=10) {
            try {

                this.riskCalculatorValues.quantity = ((capital * (riskPortfolio / 100)) / stockPrice).toFixed(2);
                this.riskCalculatorValues.stopLoss = (stockPrice - stockPrice * (riskPercent / 100)).toFixed(2);
                this.riskCalculatorValues.willingToLose = ((this.riskCalculatorValues.stopLoss-stockPrice)*this.riskCalculatorValues.quantity).toFixed(2)
            } catch (error) {
                throw error;
            }
        },

    }
})

