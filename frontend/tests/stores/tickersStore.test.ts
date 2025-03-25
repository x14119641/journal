import { describe, it, expect, vi } from "vitest";
import type { MockedFunction } from "vitest";
import { useTickersStore } from "@/stores/tickersStore";
import api from "@/services/api";

describe("tickersStore Test", () => {
    it("Get tickers", async () => {
        const mocktickerData = [
            { ticker: 'APPL', companyName: "APPLE" },
            { ticker: 'GOOGL', companyName: "Google" }
          ];
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mocktickerData
        });

        const  tickersStore = useTickersStore();
        await tickersStore.getTickers()

        expect(tickersStore.tickers.length).toBe(2)
        expect(tickersStore.tickers[0]['ticker']).toBe('APPL')
        expect(tickersStore.tickers[1]['companyName']).toBe('Google')
    });
    it("Get tickers but the response is empty", async () => {
        const mocktickerData: any[] = [];
        (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
            data: mocktickerData,
        });

        const tickersStore = useTickersStore();
        await tickersStore.getTickers();

        expect(tickersStore.tickers.length).toBe(0);
    });
    it("Get error fetching tickers", async () => {
        (api.get as MockedFunction<typeof api.get>).mockRejectedValue({
            response: { status:404, data:{detail: "There are not tickers"}}
        });

        const  tickersStore = useTickersStore();
        await tickersStore.getTickers()

        expect(tickersStore.tickers.length).toBe(0)
        expect(tickersStore.errorMessage).toBe("There are not tickers");
    })
})