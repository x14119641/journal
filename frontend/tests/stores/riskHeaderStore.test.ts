import { describe, expect, it } from "vitest";
import { useRiskHeaderStore } from "@/stores/riskHeaderStore";


describe("riskHeaderStore Test", () => {
    it("Check by default is false", () => {
        const riskHeaderStore = useRiskHeaderStore();
        expect(riskHeaderStore.showRiskHeader).toBe(false);
    });
    it("Check if toggle works and set its to true", () => {
        const riskHeaderStore = useRiskHeaderStore();
        riskHeaderStore.toggleRiskHeader()
        expect(riskHeaderStore.showRiskHeader).toBe(true);
    });
    it("Try two times to see if si set to false again", () => {
        const riskHeaderStore = useRiskHeaderStore();
        riskHeaderStore.toggleRiskHeader()
        riskHeaderStore.toggleRiskHeader()
        expect(riskHeaderStore.showRiskHeader).toBe(false);
    });
    it("setShowRiskHeader to false", () => {
        const riskHeaderStore = useRiskHeaderStore();
        riskHeaderStore.setShowRiskHeader(false)
        expect(riskHeaderStore.showRiskHeader).toBe(false);
    });
    it("setShowRiskHeader to true", () => {
        const riskHeaderStore = useRiskHeaderStore();
        riskHeaderStore.setShowRiskHeader(true)
        expect(riskHeaderStore.showRiskHeader).toBe(true);
    });
});