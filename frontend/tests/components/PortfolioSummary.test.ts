import { mount, flushPromises } from "@vue/test-utils";
import { describe, it, expect, beforeEach, vi } from "vitest";
import { createTestingPinia } from "@pinia/testing";
import PortfolioSummary from "@/components/PortfolioSummary.vue";
import { usePortfolioStore } from "@/stores/portfolioStore";
import { config } from "@vue/test-utils";
import { Router } from "vue-router";

const router = config.global.plugins[0] as Router
describe("Portfolio Summary test", () => {
    let pinia;
    let portfolioStore

    beforeEach(() => {
        vi.resetAllMocks();
        pinia = createTestingPinia({ stubActions: false });
        portfolioStore = usePortfolioStore(pinia);
        portfolioStore.getPortfolio = vi.fn().mockResolvedValue({
            data: [{ticker: 'MAIN',
                remainingQuantity: 100,
                buyPrice: 10,
                totalValue: 1000}]
        });
    })
    it("calls getPortfolio on moun", async () => {
        await router.push("/");
        await router.isReady()
        mount(PortfolioSummary, {
            global: { plugins: [pinia] },
        })
        await flushPromises();
        expect(portfolioStore.getPortfolio).toHaveBeenCalled()
    })
})