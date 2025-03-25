import { describe, expect, it } from "vitest";
import { useSidebarStore } from "@/stores/sideBarStore";


describe("sideBarStore Test", () => {
    it("Check by default is true", () => {
        const sideBarStore = useSidebarStore();
        expect(sideBarStore.isSidebarOpen).toBe(true);
    });
    it("Check if toggle works and set its to false", () => {
        const sideBarStore = useSidebarStore();
        sideBarStore.toggleSidebar()
        expect(sideBarStore.isSidebarOpen).toBe(false);
    });
    it("Try two times to see if si set to true again", () => {
        const sideBarStore = useSidebarStore();
        sideBarStore.toggleSidebar()
        sideBarStore.toggleSidebar()
        expect(sideBarStore.isSidebarOpen).toBe(true);
    });
});