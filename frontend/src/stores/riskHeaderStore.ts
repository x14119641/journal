import { defineStore } from 'pinia';

export const useRiskHeaderStore = defineStore('riskHeader', {
  state: () => ({
    showRiskHeader: false,
    quantityToBuy:0,
    stopLoss:0,
    willingToLose:0,
  }),
  actions: {
    toggleRiskHeader() {
      this.showRiskHeader = !this.showRiskHeader;
    },
    setShowRiskHeader(value: boolean) {
      this.showRiskHeader = value;
    },
    setRiskValues(quantityToBuy:number, stopLoss:number, willingToLose:number) {
      this.quantityToBuy = quantityToBuy;
      this.stopLoss = stopLoss;
      this.willingToLose = willingToLose;
    },
    resetRiskValues() {
      this.quantityToBuy = 0;
      this.stopLoss = 0;
      this.willingToLose = 0;
    },
  },
});