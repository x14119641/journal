import { mount, flushPromises } from "@vue/test-utils";
import { describe, it, expect, beforeEach, vi } from "vitest";
import { createTestingPinia } from "@pinia/testing";
import FundsHeader from "@/components/FundsHeader.vue";
import { usePortfolioStore } from "@/stores/portfolioStore";
import { useRoute } from "vue-router";
import { config } from "@vue/test-utils";

describe("FundsHeader Test", () => {
    let pinia;
    let portfolioStore;

    beforeEach(() => {
        vi.resetAllMocks();
        pinia = createTestingPinia({ stubActions: false });
        portfolioStore = usePortfolioStore(pinia);

        // Mock portfolio values
        portfolioStore.balance = 1000;
        portfolioStore.totalMoneyInvested = 800;
        portfolioStore.unrealizedMoney = 200;
        portfolioStore.netProfitLoss = 50;
        portfolioStore.getPortfolio = vi.fn().mockResolvedValue({});
    });
    it("calls getPortfolio on mount", async () => {
        mount(FundsHeader, {
            global: { plugins: [pinia] },
        });

        await flushPromises();
        expect(portfolioStore.getPortfolio).toHaveBeenCalled();
    });
    it("renders user balance and investment details", async () => {
        const wrapper = mount(FundsHeader, { global: { plugins: [pinia] } });
        await flushPromises();

        expect(wrapper.text()).toContain("User Balance");
        expect(wrapper.text()).toContain("Balance");
        expect(wrapper.text()).toContain("1000"); // Balance
        expect(wrapper.text()).toContain("Money Invested");
        expect(wrapper.text()).toContain("800"); // Total Invested
        expect(wrapper.text()).toContain("unrealizedMoney");
        expect(wrapper.text()).toContain("200"); // Unrealized Money
        expect(wrapper.text()).toContain("Realized Gains");
        expect(wrapper.text()).toContain("50"); // Realized Gains
    });

    it("calls getPortfolio on mount", async () => {
        mount(FundsHeader, { global: { plugins: [pinia] } });
        await flushPromises();

        expect(portfolioStore.getPortfolio).toHaveBeenCalled();
    });

    it("renders correct router links ", async () => {

        const wrapper = mount(FundsHeader, { global: { plugins: [pinia] } });
        await flushPromises();

        expect(wrapper.find("a[to='/funds']").exists()).toBe(true); // Back to Profile
        expect(wrapper.find("a[to='/transactions']").exists()).toBe(true); // Manage Transactions
    });

    it("renders correct router links if path is funds", async () => {
        await config.global.plugins[0].push("/funds");
        const wrapper = mount(FundsHeader, { global: { plugins: [pinia] } });
        await flushPromises();

        expect(wrapper.find("a[to='/profile']").exists()).toBe(true); // Back to Profile
        expect(wrapper.find("a[to='/transactions']").exists()).toBe(true); // Manage Transactions
    });
    it("renders correct router links if path is transactions", async () => {
        await config.global.plugins[0].push("/transactions");
        const wrapper = mount(FundsHeader, { global: { plugins: [pinia] } });
        await flushPromises();

        expect(wrapper.find("a[to='/funds']").exists()).toBe(true);
        expect(wrapper.find("a[to='/profile']").exists()).toBe(true);
    });
});
