import { defineStore } from 'pinia';

export const useRiskHeaderStore = defineStore('riskHeader', {
  state: () => ({
    showRiskHeader: false, 
  }),
  actions: {
    toggleRiskHeader() {
      this.showRiskHeader = !this.showRiskHeader;
    },
    setShowRiskHeader(value: boolean) {
        this.showRiskHeader = value;
      },
  },
});