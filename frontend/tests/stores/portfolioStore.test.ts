import { describe, it, expect } from "vitest";
import type { MockedFunction } from "vitest";
import { usePortfolioStore } from "@/stores/portfolioStore";
import api from "@/services/api";

describe("portfolioStore Test", () => {
    const mockDataPortfolio1 = [
        {ticker:'MAIN', remainingQuantity:10, buyPrice:10, totalValue:105},
        {ticker:'MAIN', remainingQuantity:20, buyPrice:13, totalValue:215},
        {ticker:'EDR', remainingQuantity:5, buyPrice:3, totalValue:18},
    ];
    const mockDataEmpty = {value:0};
    const mockDataWithNumberValue = {value:1000};
    const mockDataTickerSummary1 = [
        {ticker: 'MAIN', remainingQuantity: 20, totalValue: 130, minPrice: 10, maxPrice: 12, avgBuyPrice:11.5, breakeven: 11.8, totalFees:3.4},
        {ticker: 'EDR', remainingQuantity: 10, totalValue: 110, minPrice: 10, maxPrice: 20, avgBuyPrice:13, breakeven: 15, totalFees:4}, 
    ]
    const mockDataTotalMonthly = {totalInvested:1000, totalEarned:10, totalFees:8,netProfitLoss:2};
    const mockDataExternalSummary = {totalInvested:1000, totalEarned:10, totalFees:8,netProfitLoss:2, marketValue:30};
    const mockDataSectorAllocation = [
        {ticker:'EDR', quantity:10, sector:"Television", industry:"Sports"},
        {ticker:'MAIN', quantity:30, sector:"Finances", industry:"Dividends"},
    ];
    it("Get Balance 0", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataEmpty
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getBalance();
        expect(portfolioStore.balance).toBe(0)
    });
    it("Get Balance 1000", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataWithNumberValue
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getBalance();
        console.log('Store balance after get:', portfolioStore.balance);
        expect(portfolioStore.balance).toBe(1000)
    });
    it("Get Portfolio Empty Error", async () => {
        (api.get as MockedFunction<typeof api.get>).mockRejectedValue({
            response: {status:404, data:{detail:"Portfolio is empty"}}
        });
        const portfolioStore = usePortfolioStore();
        await expect(portfolioStore.getPortfolio()).rejects.toThrow();
        expect(portfolioStore.portfolio.length).toBe(0)
        expect(portfolioStore.errorMessage).toBe("Portfolio is empty");
    });
    it("Get Portfolio", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataPortfolio1
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getPortfolio();
        expect(portfolioStore.portfolio.length).toBe(3)
        expect(portfolioStore.portfolio[0]['ticker']).toBe('MAIN')
        
    });
    it("Get Total Fees 0 ", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataEmpty
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getTotalFees();
        expect(portfolioStore.totalFees).toBe(0)   
    });
    it("Get Total Fees 1000 ", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataWithNumberValue
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getTotalFees();
        expect(portfolioStore.totalFees).toBe(1000)   
    });
    it("Get Total Fees 0 ", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataEmpty
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getTotalFees();
        expect(portfolioStore.totalMoneyInvested).toBe(0)   
    });
    it("Get Total Money Invested 1000 ", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataWithNumberValue
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getTotalMoneyInvested();
        expect(portfolioStore.totalMoneyInvested).toBe(1000)   
    });
    it("CurrentPortfolioValue 0 ", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataEmpty
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getCurrentPortfolioValue();
        expect(portfolioStore.currentPortfolioValue).toBe(0)   
    });
    it("CurrentPortfolioValue 1000 ", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataWithNumberValue
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getCurrentPortfolioValue();
        expect(portfolioStore.currentPortfolioValue).toBe(1000)   
    });
    it("netProfitLoss 0 ", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataEmpty
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getNetProfitLoss();
        expect(portfolioStore.netProfitLoss).toBe(0)   
    });
    it("netProfitLoss 1000 ", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataWithNumberValue
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getNetProfitLoss();
        expect(portfolioStore.netProfitLoss).toBe(1000)   
    });
    it("getTickerPortfolioSummary Test ", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataTickerSummary1
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getTickerPortfolioSummary();
        expect(portfolioStore.ticker_portfolio_summary.length).toBe(2)   
        expect(portfolioStore.ticker_portfolio_summary[0]['ticker']).toBe('MAIN') 
    });
    it("getMonthlyPerformance Test ", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataTotalMonthly
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getMonthlyPerformance();
        expect(portfolioStore.portfolio_monthly_summary['netProfitLoss']).toBe(2) 
    });
    it("getUnrealizedMoney is 0", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataEmpty
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getUnrealizedMoney();
        expect(portfolioStore.unrealizedMoney).toBe(0) 
    });
    it("getSummaryExternal test", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataExternalSummary
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getSummaryExternal();
        expect(portfolioStore.portfolio_external_summary.marketValue).toBe(30) 
    });
    it("getPortfolioAllocationSector test", async () => {
        
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataSectorAllocation
        });
        const portfolioStore = usePortfolioStore();
        await portfolioStore.getPortfolioAllocationSector();
        expect(portfolioStore.sector_allocation_portfolio.length).toBe(2) 
        expect(portfolioStore.sector_allocation_portfolio[0].ticker).toBe("EDR") 
    });
})