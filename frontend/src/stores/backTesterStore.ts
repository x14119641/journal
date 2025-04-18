import { defineStore } from "pinia";
import { ref, computed } from "vue";

export const useBacktesterStore = defineStore("backtester", () => {
  const initialBalance = ref<number | null>(null);
  const monthStart = ref<string>("");
  const yearStart = ref<string>("");
  const monthEnd = ref<string>("");
  const yearEnd = ref<string>("");

  const startPeriod = computed(() => ({
    month: monthStart.value,
    year: yearStart.value,
  }));

  const endPeriod = computed(() => ({
    month: monthEnd.value,
    year: yearEnd.value,
  }));

  return {
    initialBalance,
    monthStart,
    yearStart,
    monthEnd,
    yearEnd,
    startPeriod,
    endPeriod,
  };
});
