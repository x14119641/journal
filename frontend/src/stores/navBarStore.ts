import { defineStore } from "pinia";

export const useNavBarStore = defineStore('navBar', {
    state: () => ({
        isDropdownOpen: false, // close by default
    }),
    actions: {
        toogleDropdown() {
            this.isDropdownOpen = !this.isDropdownOpen;
        },
        closeDropdown() {
            this.isDropdownOpen = false;
          },
    }
})