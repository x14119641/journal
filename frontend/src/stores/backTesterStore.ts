import { defineStore } from "pinia";
import { ref, computed } from "vue";
import api from "../services/api";

export const useBacktesterStore = defineStore("backtester", () => {
  const drip = ref<boolean>(true);
  const currentDate = new Date();
  const currentMonth = String(currentDate.getMonth() + 1);
  const currentYear = String(currentDate.getFullYear());    

  const initialBalance = ref<number | null>(null);

  const monthStart = ref<string>("1");        
  const yearStart = ref<string>("1990");       
  const monthEnd = ref<string>(currentMonth);  
  const yearEnd = ref<string>(currentYear);    

  const portfolioResults = ref<{ [key: string]: { date: string; invested_value: number, cash?:number }[] }>({});


  const startPeriod = computed(() => ({
    month: monthStart.value,
    year: yearStart.value,
  }));

  const endPeriod = computed(() => ({
    month: monthEnd.value,
    year: yearEnd.value,
  }));


  async function simulatePortfolios(portfolios:Record<string, { stock: string; weigth: number }[]>) {
    const padMonth = (m: string | number) => String(m).padStart(2, "0");

    const payload = {
      initial_balance: Number(initialBalance.value),
      start_date: `${yearStart.value}-${padMonth(monthStart.value)}-01`,
      end_date: `${yearEnd.value}-${padMonth(monthEnd.value)}-01`,
      portfolios: portfolios,
    };

    try {
      const endpoint = drip.value 
      ? "/portfolio/backtesting" : "/portfolio/backtesting/drip";
      const response = await api.post(endpoint, payload);
      portfolioResults.value = response.data;
    } catch (error) {
      console.error("Error in simulatePortfolios:", error);
    }
  }

  return {
    drip,
    initialBalance,
    monthStart,
    yearStart,
    monthEnd,
    yearEnd,
    startPeriod,
    endPeriod,
    portfolioResults,
    simulatePortfolios
  };
});

