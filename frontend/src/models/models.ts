import type { NumericLiteral } from "typescript";
import Decimal from "decimal.js";

export interface User {
    id: number;
    username: string;
    email: string;
    created_at: string;
}

export interface Stock {
    id:Int16Array;
    ticker: string;
    name: number;
}

export interface Fund {
    id:Int16Array;
    userId: string;
    amount: Decimal;
    description: string;
    created_at:string;
}

export interface PortfolioItem {
    ticker: string;
    totalValue: Decimal;
    totalQuantity: number;
}
export interface PortfolioItemAgreggate {
    totalValue: number;
    totalQuantity: number; 
    minPrice: number; 
    maxPrice: number;
    breakeven: number; 
}

export interface AllocationRecord {
    ticker: string;
    quantity: number;
    sector: string;
    industry: string;
}


export interface BarChartDataItem {
    ticker: string;
    totalValue: number;
}


export interface StockMetadata {
    ticker: string;
    companyName : string;
    isNasdaq100: Boolean | null;
    exchange: string;
    sector: string;
    industry: string;
    oneyrtarget: number | null;
    averagevolume: number;
    fiftTwoWeekHighLow:string;
    marketcap:string;
    peratio:string;
    forwardpe1yr:string;
    earningspershare:string;
    annualizeddividend:string;
    yield: number;
    sharesoutstandingpct: number;
    ratioholdersbuysold:number;
}


export interface StockDividend {
    exoreffdate:string; 
    paymenttype:string; 
    amount:number; 
    declarationdate:string; 
    recorddate:string; 
    paymentdate:string; 
    currency:string;
}
export interface StockScreener {
    ticker: string;
    numdividends:number;
    amount: number;
    declarationdate : string;
    sector: string;
    marketcap: number;
    peratio: number;
    forwardpe1yr:number;
    earningspershare: number;
    annualizeddividend: number;
    yield:number;
    sharesoutstandingpct:number;
    ratioholdersbuysold:number | null;
}

export interface Ticker {
    id:Int16Array;
    ticker: string;
    name: number;
}

export interface TickerName {
    ticker: string;
    companyName: string;
}

export interface TickerPrice {
    id:Int16Array;
    price:Decimal;
}

export interface Dividend {
    id:Int16Array;
    ticker: string;
    name: number;
}

export interface DividendCalendar {
    ticker: string;
    amount:NumericLiteral,
    name: number;
    paymentDate:string;
}

export interface Transaction {
    ticker: string;
    price: number;
    quantity: number;
    transaction_type: string;
    fee: number;
  }

  export interface RiskCalculatorRecord {
    quantity: number;
    stopLoss: string;
    willingToLose:number
}
