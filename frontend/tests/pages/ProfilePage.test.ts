import { mount } from "@vue/test-utils";
import { describe, it, expect } from "vitest";
import ProfilePage from "@/pages/ProfilePage.vue";
import ProfileInfo from "@/components/ProfileInfo.vue";
import FundsHeader from "@/components/FundsHeader.vue";
import AllocationDoughnout from "@/components/AllocationDoughnout.vue";
import PortfolioBarChart from "@/components/PortfolioBarChart.vue";
import PortfolioSummary from "@/components/PortfolioSummary.vue";

describe("ProfilePage", () => {
  it("renders all components correctly", () => {
    const wrapper = mount(ProfilePage);

    // Check if all components exist in the page
    expect(wrapper.findComponent(ProfileInfo).exists()).toBe(true);
    expect(wrapper.findComponent(FundsHeader).exists()).toBe(true);
    expect(wrapper.findComponent(AllocationDoughnout).exists()).toBe(true);
    expect(wrapper.findComponent(PortfolioBarChart).exists()).toBe(true);
    expect(wrapper.findComponent(PortfolioSummary).exists()).toBe(true);
  });

  it("has the correct number of layout containers", () => {
    const wrapper = mount(ProfilePage);

    // Check if there are 3 components in the first row (lg:grid-cols-3)
    expect(wrapper.findAll(".grid-cols-3 .slate-container").length).toBe(3);

    // Check if there are 2 components in the second row (lg:grid-cols-2)
    expect(wrapper.findAll(".grid-cols-2 .slate-container").length).toBe(2);
  });
});