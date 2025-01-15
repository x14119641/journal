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

export interface Ticker {
    ticker: string;
}


export interface Dividend {
    id:Int16Array;
    ticker: string;
    name: number;
}