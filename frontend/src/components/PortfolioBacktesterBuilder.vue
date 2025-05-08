<template>
    <div class="p-6 text-center">
        <h2 class="title-component">Create Portfolios</h2>
        <div>
            <div class="grid grid-cols-[1fr_2fr_repeat(3,1fr)] gap-4 items-center mb-2 font-bold text-sm">
                <span>Asset</span>
                <span>Stock</span>
                <span>Portfolio 1 (%)</span>
                <span>Portfolio 2 (%)</span>
                <span>Portfolio 3 (%)</span>
            </div>
            <div v-for="(row, index) in rows" :key="index"
                class="grid grid-cols-[1fr_2fr_repeat(3,1fr)] gap-4 items-center mb-2">
                <span class="text-label">Asset {{ index + 1 }}</span>
                <SearchStock v-model="row.selectedStock" />
                <input type="number" v-model.number="row.portfolio1" min="0" max="100" class="input-style" />
                <input type="number" v-model.number="row.portfolio2" min="0" max="100" class="input-style" />
                <input type="number" v-model.number="row.portfolio3" min="0" max="100" class="input-style" />
            </div>
            <div class="mt-4 flex flex-row justify-end">
                <span @click="addAsset" class="text-sm text-blue-600 hover:underline cursor-pointer">
                    + Add row
                </span>
            </div>
            <!-- Totals per column -->
            <div class="grid grid-cols-[1fr_2fr_repeat(3,1fr)] gap-4 items-center mt-4 font-semibold text-sm">
                <span></span>
                <span class="text-right">Total</span>
                <span>{{ total1 }}%</span>
                <span>{{ total2 }}%</span>
                <span>{{ total3 }}%</span>
            </div>
            <div class="mt-4 flex flex-row justify-end">
                <button @click="calculate" type="button" class="button-blue w-32">
                    Calculate
                </button>
            </div>
        </div>
    </div>
    <pre v-if="isCalculated" class="mt-6 text-left bg-slate-800 text-white p-4 rounded">
  {{ rows }}
</pre>

</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import SearchStock from './SearchStock.vue';
import { useBacktesterStore } from "../stores/backTesterStore";
import api from '../services/api';

const backtesterStore = useBacktesterStore();

const isCalculated = ref<Boolean>(false);

const props = defineProps({
    defaultRows: { type: Number, default: 5 },
    maxAssets: { type: Number, default: 30 },
});

const rows = ref(
    Array.from({ length: props.defaultRows }, () => ({
        selectedStock: "",
        portfolio1: 0,
        portfolio2: 0,
        portfolio3: 0,
    }))
);


const total1 = computed(() =>
    rows.value.reduce((sum, r) => sum + (r.portfolio1 || 0), 0)
);
const total2 = computed(() =>
    rows.value.reduce((sum, r) => sum + (r.portfolio2 || 0), 0)
);
const total3 = computed(() =>
    rows.value.reduce((sum, r) => sum + (r.portfolio3 || 0), 0)
);

const addAsset = () => {
    if (rows.value.length < props.maxAssets) {
        rows.value.push({ selectedStock: "", portfolio1: 0, portfolio2: 0, portfolio3: 0 });
    }
}

const calculate = async () => {
    if (
        !backtesterStore.initialBalance ||
        !backtesterStore.monthStart ||
        !backtesterStore.yearStart ||
        !backtesterStore.monthEnd ||
        !backtesterStore.yearEnd
    ) {
        alert("Please fill in all the BackTester fields before calculating.");
        return;
    }
    console.log("Initial Balance:", backtesterStore.initialBalance);
    console.log("Start:", `${backtesterStore.monthStart}/${backtesterStore.yearStart}`);
    console.log("End:", `${backtesterStore.monthEnd}/${backtesterStore.yearEnd}`);

    const getPortfolio = (key: "portfolio1" | "portfolio2" | "portfolio3") => {
        const rawRows = rows.value.filter((r) => r[key] > 0);
        const hasMissingStock = rawRows.some((r) => !r.selectedStock);

        const validAssets = rawRows
            .filter((r) => r.selectedStock)
            .map((r) => ({ stock: r.selectedStock, weigth: r[key] }));

        const total = rawRows.reduce((sum, r) => sum + (r[key] || 0), 0);

        if (rawRows.length === 0) return null; // completely empty → skip

        if (hasMissingStock) return "missing-stock"; // quantity are present, but no stock

        if (total !== 100) return "invalid"; // stock present, but wrong total

        return validAssets; // valid
    };

    const p1 = getPortfolio("portfolio1");
    const p2 = getPortfolio("portfolio2");
    const p3 = getPortfolio("portfolio3");

    const portfolios = {
        ...(p1 && p1 !== "invalid" ? { portfolio1: p1 } : {}),
        ...(p2 && p2 !== "invalid" ? { portfolio2: p2 } : {}),
        ...(p3 && p3 !== "invalid" ? { portfolio3: p3 } : {}),
    };

    if ([p1, p2, p3].includes("missing-stock")) {
        alert("Some portfolio has a stock missing.");
        return;
    }

    if ([p1, p2, p3].includes("invalid")) {
        alert("Each portfolio that has values must sum exactly to 100%.");
        return;
    }

    if (Object.keys(portfolios).length === 0) {
        alert("Please fill in at least one portfolio.");
        return;
    }

    console.log("✅ Submitting portfolios:", portfolios);
    // Remove emtpy obkjects
    rows.value = rows.value.filter(row => row.selectedStock);
    isCalculated.value = true;
    // add 0 if one digit
    const padMonth = (month: string | number) => String(month).padStart(2, "0");

    const payload = {
        initial_balance: Number(backtesterStore.initialBalance),
        start_date: `${backtesterStore.yearStart}-${padMonth(backtesterStore.monthStart)}-01`,
        end_date: `${backtesterStore.yearEnd}-${padMonth(backtesterStore.monthEnd)}-01`,
        portfolios:portfolios
    }

    try {
        const response = await api.post("/portfolio/backtesting", payload)
        console.log(response.data)
    } catch (error) {
        console.error("Error in backtesting portfolio: ", error)
    }
};
</script>