import { defineStore } from 'pinia';
import { ref } from "vue";
import api from "../services/api";
import type { DividendCalendar } from '../models/models';

export const useCalendarStore = defineStore("calendarStore",  {
    state: () => ({
        today: new Date(),
        currentMonth : new Date().getMonth(),
        dividends:  [] as DividendCalendar[],
    }),
    actions: {
        async fetchDividends(){
            try {
                const correct_index = this.currentMonth+1
                const response = await api.get(`/stocks/dividends/calendar/${correct_index}`);
         
                this.dividends = [...response.data];
            } catch (error) {
                console.error("Error fetching dividends:", error);
            }
        },
        async nextMonth () {
            if (this.currentMonth < 11) this.currentMonth++;
            else this.currentMonth = 0;
            await this.fetchDividends()
        },
        async prevMonth () {
            if (this.currentMonth > 0) this.currentMonth--;
            else this.currentMonth = 11;
            this.fetchDividends()
        },
        async setMonth (monthIndex: number) {
            this.currentMonth = monthIndex;
            await this.fetchDividends()
        },
    }

});
