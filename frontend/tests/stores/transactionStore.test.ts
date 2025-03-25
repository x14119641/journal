import { describe, it, expect, vi } from "vitest";
import type { MockedFunction } from "vitest";
import { useTransactionsStore } from "@/stores/transactionsStore";
import api from "@/services/api";
import { usePortfolioStore } from "@/stores/portfolioStore";
import { flushPromises } from "@vue/test-utils";


describe("Transaction Store Test", () => {
    const mockDataDepositNoDate = { amount: 1000, description: "Initial Deposit" };
    const mockDataDepositWithDate = {
        amount: 1000, description: "Initial Deposit",
        created_at: new Date()
    };


    const mockDataBuyStockNoDate = {
        ticker: 'MAIN', buy_price: 10,
        quantity: 10, fee: 3.5
    };
    const mockDataBuyStockWithDate = {
        ticker: 'MAIN', buy_price: 10,
        quantity: 10, fee: 3.5, created_at: new Date()
    };


    const mockDataPortfolio = [
        { ticker: 'MAIN', remainingQuantity: 10, buyPrice: 10, totalValue: 100 },
        { ticker: 'EDR', remainingQuantity: 5, buyPrice: 3, totalValue: 15 },
    ];

    const mockDataTransactionsHistory = [
        {
            transactionId: 1, ticker: "MAIN", transactionType: " Transaction tyoe", price: 10,
            quantity: 10, fee: 2, realizedProfitLoss: 4.2, description: "Some description", created_at: "2025-03-05 12:30:00.000"
        },
        {
            transactionId: 2, ticker: "EDR", transactionType: " Transaction tyoe", price: 3,
            quantity: 5, fee: 2, realizedProfitLoss: 0, description: "Some description", created_at: "2025-03-05 12:30:00.000"
        }
    ]
    it("Deposit  Funds (no date)", async () => {
        const transactionStore = useTransactionsStore();
        const portfolioStore = usePortfolioStore();
        portfolioStore.getPortfolio = vi.fn().mockResolvedValue({
            data: mockDataPortfolio
        });
        
        transactionStore.getTransactionHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        transactionStore.getStocksTransactionsHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        await transactionStore.addFunds(mockDataDepositNoDate);
        await flushPromises();
        const mockResponse = { data: { message: "Funds added successfully" } };
        api.post.mockResolvedValueOnce(mockResponse);
        expect(api.post).toHaveBeenCalledWith('transactions/add_funds', mockDataDepositNoDate);
        expect(transactionStore.transaction_message_return).toBe("Funds added successfully")
    });
    it("Deposit  Funds (with date)", async () => {
        const transactionStore = useTransactionsStore();
        const portfolioStore = usePortfolioStore();
        portfolioStore.getPortfolio = vi.fn().mockResolvedValue({
            data: mockDataPortfolio
        });
        
        transactionStore.getTransactionHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        transactionStore.getStocksTransactionsHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        
        await transactionStore.withdrawFunds(mockDataDepositWithDate);
        await flushPromises();
        const mockResponse = { data: { message: "Funds withdrew successfully" } };
        api.post.mockResolvedValueOnce(mockResponse);
        expect(api.post).toHaveBeenCalledWith('transactions/withdraw_funds', mockDataDepositWithDate);
        expect(transactionStore.transaction_message_return).toBe("Funds withdrew successfully")
    });
    it('should throw an error if API call fails', async () => {
        const transactionStore = useTransactionsStore();
        const mockTransaction = { amount: 'bla', description: 'FAIL' };
        const mockError = new Error('API error');

        api.post.mockRejectedValueOnce(mockError);

        await expect(transactionStore.addFunds(mockTransaction)).rejects.toThrow('API error');
    });
    it("Buy stock without date", async () => {
        const transactionStore = useTransactionsStore();
        const portfolioStore = usePortfolioStore();
        portfolioStore.getPortfolio = vi.fn().mockResolvedValue({
            data: mockDataPortfolio
        });
        
        transactionStore.getTransactionHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        transactionStore.getStocksTransactionsHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        const mockResponse = { data: { message: "Stock purchased" } };
        api.post.mockResolvedValueOnce(mockResponse);
        await transactionStore.buyStock(mockDataBuyStockNoDate);
        await flushPromises();
        expect(api.post).toHaveBeenCalledWith('transactions/buy_stock', mockDataBuyStockNoDate);
        expect(transactionStore.transaction_message_return).toBe("Stock purchased")
    });
    it("Buy stock with date", async () => {
        const transactionStore = useTransactionsStore();
        const portfolioStore = usePortfolioStore();
        portfolioStore.getPortfolio = vi.fn().mockResolvedValue({
            data: mockDataPortfolio
        });
        
        transactionStore.getTransactionHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        transactionStore.getStocksTransactionsHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        const mockResponse = { data: { message: "Stock purchased" } };
        api.post.mockResolvedValueOnce(mockResponse);
        await transactionStore.buyStock(mockDataBuyStockWithDate);
        await flushPromises();

        expect(api.post).toHaveBeenCalledWith('transactions/buy_stock', mockDataBuyStockWithDate);
        expect(transactionStore.transaction_message_return).toBe("Stock purchased")
    });
    it('should throw an error if API call fails', async () => {
        const transactionStore = useTransactionsStore();
        const mockTransaction = {
            ticker: 'bla bla', buy_price: 10,
            quantity: 10, fee: 3.5
        };
        const mockError = new Error('API error');

        api.post.mockRejectedValueOnce(mockError);

        await expect(transactionStore.buyStock(mockTransaction)).rejects.toThrow('API error');
    });
    it("Sell stock without date", async () => {
        const transactionStore = useTransactionsStore();
        const portfolioStore = usePortfolioStore();
        portfolioStore.getPortfolio = vi.fn().mockResolvedValue({
            data: mockDataPortfolio
        });
        
        transactionStore.getTransactionHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        transactionStore.getStocksTransactionsHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        const mockResponse = { data: { message: "Sold x quantity with value y" } };
        api.post.mockResolvedValueOnce(mockResponse);
        await transactionStore.sellStock(mockDataBuyStockNoDate);
        await flushPromises();

        expect(api.post).toHaveBeenCalledWith('transactions/sell_stock', mockDataBuyStockNoDate);
        expect(transactionStore.transaction_message_return).includes("Sold")
    });
    it("Sell stock with date", async () => {
        const transactionStore = useTransactionsStore();
        const portfolioStore = usePortfolioStore();
        portfolioStore.getPortfolio = vi.fn().mockResolvedValue({
            data: mockDataPortfolio
        });
        
        transactionStore.getTransactionHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        transactionStore.getStocksTransactionsHistory = vi.fn().mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        const mockResponse = { data: { message: "Succes:..." } };

        api.post.mockResolvedValueOnce(mockResponse);
        await transactionStore.sellStock(mockDataBuyStockWithDate);


        expect(api.post).toHaveBeenCalledWith('transactions/sell_stock', mockDataBuyStockWithDate);
        expect(transactionStore.transaction_message_return).toBe("Succes:...")
    });
    it('should throw an error if API call fails', async () => {
        const transactionStore = useTransactionsStore();
        const mockTransaction = {
            ticker: 'bla bla', buy_price: 10,
            quantity: 10, fee: 3.5
        };
        const mockError = new Error('API error');

        api.post.mockRejectedValueOnce(mockError);

        await expect(transactionStore.sellStock(mockTransaction)).rejects.toThrow('API error');
    });
    it("Get Transactions History", async () => {

        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        const transactionsStore = useTransactionsStore();
        await transactionsStore.getTransactionHistory();
        expect(transactionsStore.transactions_history.length).toBe(2)
        expect(transactionsStore.transactions_history[0].ticker).toBe("MAIN")
    });
    it("Reset user transactions try (Should no work!", async () => {

        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mockDataTransactionsHistory
        });
        const transactionsStore = useTransactionsStore();
        await transactionsStore.getTransactionHistory();

    });
})