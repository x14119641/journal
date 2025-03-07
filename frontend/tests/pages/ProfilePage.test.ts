import { mount, flushPromises  } from "@vue/test-utils";
import { describe, it, expect, beforeEach, vi } from "vitest";
import ProfilePage from "@/pages/ProfilePage.vue";
import ProfileInfo from "@/components/ProfileInfo.vue";
import FundsHeader from "@/components/FundsHeader.vue";
import AllocationDoughnout from "@/components/AllocationDoughnout.vue";
import PortfolioBarChart from "@/components/PortfolioBarChart.vue";
import PortfolioSummary from "@/components/PortfolioSummary.vue";
import { usePortfolioStore } from "@/stores/portfolioStore"; 



describe("ProfilePage", () => {
  // Need to load all the sotres that are used in the components
  beforeEach(() => {
    const portfolioStore = usePortfolioStore();
    const mockDataPortfolio1 = [
      {ticker:'MAIN', remainingQuantity:10, buyPrice:10, totalValue:105},
      {ticker:'MAIN', remainingQuantity:20, buyPrice:13, totalValue:215},
      {ticker:'EDR', remainingQuantity:5, buyPrice:3, totalValue:18},
  ];
    // Override default store behavior for this test
    portfolioStore.getPortfolio = vi.fn().mockResolvedValue({
      data: mockDataPortfolio1,
    });
    portfolioStore.portfolioData = mockDataPortfolio1;
  });
  it("renders all components correctly", async () => {
    const wrapper = mount(ProfilePage);

    // Check if all components exist in the page
    expect(wrapper.findComponent(ProfileInfo).exists()).toBe(true);
    expect(wrapper.findComponent(FundsHeader).exists()).toBe(true);
    expect(wrapper.findComponent(AllocationDoughnout).exists()).toBe(true);
    expect(wrapper.findComponent(PortfolioBarChart).exists()).toBe(true);
    expect(wrapper.findComponent(PortfolioSummary).exists()).toBe(true);
  });

  it("has the correct number of layout containers", async () => {
    const wrapper = mount(ProfilePage);
    await flushPromises(); // Ensures all async tasks are finished
    await wrapper.vm.$nextTick();
    console.log(wrapper.html())
    // Check if there are 3 components in the first row (lg:grid-cols-3)
    expect(wrapper.findAll("#grid3 .slate-container").length).toBe(3);

    // Check if there are 2 components in the second row (lg:grid-cols-2)
    expect(wrapper.findAll("#grid2 .slate-container").length).toBe(2);
  });
});