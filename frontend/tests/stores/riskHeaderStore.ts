import { describe, expect, it } from "vitest";
import { useRiskHeaderStore } from "@/stores/riskHeaderStore";


describe("riskHeaderStore Test", () => {
    it("Check by default is false", () => {
        const sideBarStore = useRiskHeaderStore();
        expect(sideBarStore.showRiskHeader).toBe(false);
    });
    it("Check if toggle works and set its to true", () => {
        const sideBarStore = useRiskHeaderStore();
        sideBarStore.toggleRiskHeader()
        expect(sideBarStore.showRiskHeader).toBe(true);
    });
    it("Try two times to see if si set to false again", () => {
        const sideBarStore = useRiskHeaderStore();
        sideBarStore.toggleSidebar()
        sideBarStore.toggleSidebar()
        expect(sideBarStore.showRiskHeader).toBe(true);
    });
    it("setShowRiskHeader to false", () => {
        const sideBarStore = useRiskHeaderStore();
        sideBarStore.setShowRiskHeader(false)
        expect(sideBarStore.showRiskHeader).toBe(false);
    });
    it("setShowRiskHeader to true", () => {
        const sideBarStore = useRiskHeaderStore();
        sideBarStore.setShowRiskHeader(true)
        expect(sideBarStore.showRiskHeader).toBe(true);
    });
});