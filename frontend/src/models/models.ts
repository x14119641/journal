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
    name : string;
    country: string;
    sector: string;
    industry: string;
    institutional_ownership_perc: number;
    increased_positions_holders: number;
    decreased_positions_holders:number;
    held_positions_holders: number;
    total_institutional_holders: number;
    new_positions_holders:number;
    sold_out_positions_holders:number;
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
    payment_date:string;
}

export interface Transaction {
    ticker: string;
    price: number;
    quantity: number;
    transaction_type: string;
    fee: number;
  }