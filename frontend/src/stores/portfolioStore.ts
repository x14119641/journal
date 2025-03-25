import { defineStore } from "pinia";
import api from "../services/api";
import type {
    StockTransactionHistoryRecord, Ticker, PortfolioItem,
    SectorAllocationRecord, PortfolioItemSummary,
    BarChartDataItem, TickerPrice,
    RiskCalculatorRecord,
    PortfolioItemMontly,
    PortfolioItemSummaryExternal
} from "../models/models";




export const usePortfolioStore = defineStore('portfolio', {
    state: () => ({
        balance: 0,
        totalFees: 0,
        totalMoneyInvested: 0,
        currentPortfolioValue: 0,
        netProfitLoss: 0,
        unrealizedMoney: 0,
        
        portfolio: [] as PortfolioItem[],
        sector_allocation_portfolio: [] as SectorAllocationRecord[],
        portfolio_barchart_data: [] as BarChartDataItem[],
        portfolio_summary: [] as PortfolioItemSummary[],
        riskCalculatorValues: [] as RiskCalculatorRecord[],
        ticker_portfolio_summary: [] as PortfolioItemSummary[],
        portfolio_monthly_summary: {} as PortfolioItemMontly,
        portfolio_external_summary: {} as PortfolioItemSummaryExternal,
        default_limit: 10,
        errorMessage: ""
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
            return (ticker: string): PortfolioItemSummary[] => {
                return state.portfolio_summary.find((stock) => stock.ticker === ticker);
            };
        },
        getTotalValueByTickerInPortfolio: (state) => {
            return (ticker: string): PortfolioItem[] => {
                return state.portfolio_summary.filter((stock) => stock.ticker === ticker);
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
            //When i call getPOrtfolio i will call ghe other aggregators
            try {
                const response = await api.get('portfolio/get_portfolio')
                // console.log(response.data)
                // Object.assign(this.portfolio, response.data)
                this.portfolio = [...response.data]
                // Like this stores are updated
                // Ensure all necessary properties update
                await Promise.allSettled([
                    this.getBalance(),
                    this.getTotalMoneyInvested(),
                    this.getCurrentPortfolioValue(),
                    this.getUnrealizedMoney(),  
                    this.getNetProfitLoss() ,
                    this.getPortfolioSummary()
                ]);
                // await this.getCurrentPortfolioValue()
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
                console.log(response)
                if (response == undefined) { console.log("WAWA") }
                this.sector_allocation_portfolio = [...response.data]
            } catch (error) {
                this.errorMessage = "Error in getPortfolioAllocation"
                console.log('ERROR"')
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
        async getPortfolioTickerAggregate(ticker: string) {
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
    }
})

