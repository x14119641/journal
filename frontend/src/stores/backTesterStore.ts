import { defineStore } from "pinia";
import { ref, computed } from "vue";

export const useBacktesterStore = defineStore("backtester", () => {
  const currentDate = new Date();
  const currentMonth = String(currentDate.getMonth() + 1);
  const currentYear = String(currentDate.getFullYear());    

  const initialBalance = ref<number | null>(null);

  const monthStart = ref<string>("1");        
  const yearStart = ref<string>("1990");       
  const monthEnd = ref<string>(currentMonth);  
  const yearEnd = ref<string>(currentYear);    

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

