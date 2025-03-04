import { describe, it, expect } from "vitest";
import { useNavBarStore } from "@/stores/navBarStore";

describe("navBarStore Test", () => {
    it("False by default", () => {
        const navBarStore = useNavBarStore();
        expect(navBarStore.isDropdownOpen).toBe(false)
    });
    it("Toogle to true", () => {
        const navBarStore = useNavBarStore();
        navBarStore.toggleDropdown()
        expect(navBarStore.isDropdownOpen).toBe(true)
    });
    it("Toogle twice, so should be false", () => {
        const navBarStore = useNavBarStore();
        navBarStore.toggleDropdown()
        navBarStore.toggleDropdown()
        expect(navBarStore.isDropdownOpen).toBe(false)
    });
    it("Toogle twice, so should be false", () => {
        const navBarStore = useNavBarStore();
        navBarStore.closeDropdown()
        expect(navBarStore.isDropdownOpen).toBe(false)
    });
});