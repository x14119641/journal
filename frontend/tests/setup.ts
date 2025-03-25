import { createPinia, setActivePinia } from "pinia";
import { beforeEach, vi } from "vitest";
import { config } from "@vue/test-utils";
import { createRouter, createMemoryHistory } from "vue-router";


// Mock `api.ts`
vi.mock("@/services/api", () => {
    const apiMock = {
      post: vi.fn(),
      get: vi.fn(),
      delete: vi.fn(),
      put: vi.fn(),
      interceptors: {
        request: { use: vi.fn() },
        response: { use: vi.fn() },
      },
    };
    return { default: apiMock };
  });
  

// Mock localStorage globally
Object.defineProperty(globalThis, "localStorage", {
    value: {
        getItem: vi.fn(),
        setItem: vi.fn(),
        removeItem: vi.fn(),
        clear: vi.fn(),
        length: 0,
        key: vi.fn(),
    },
    writable: true,
});

// Mock Vue Router
const testRoutes = [
  { path: '/', component: {} },
  { path: '/logout', component: {} },
  { path: '/demo', component: {} },
  { path: '/hello', component: {} },
  { path: '/table', component: {} },
  { path: '/colors', component: {} },
  { path: '/funds', component: {} },
  { path: '/dashboard', component: {} },
  { path: '/transactions', component: {} },
  { path: '/transactions/:id', component: {} },
  { path: '/login', component: {} },
  { path: '/profile', component: {} },
  { path: '/dividends', component: {} },
  { path: '/calendar', component: {} },
  { path: '/screener', component: {} },
  { path: '/stocks/:ticker', component: {} },
  { path: '/register', component: {} },
]

const router = createRouter({
  history:createMemoryHistory(),
  routes:testRoutes
});
config.global.plugins = [router];
// Stub components like `router-link` to avoid errors
config.global.stubs = {
  "router-link": {
    template: "<a><slot /></a>", // Renders links properly
  },
  "router-view": true, // Prevents `router-view` errors
};

// Mock console.warn to avoid spammy logs during tests
vi.spyOn(console, "warn").mockImplementation(() => {});

beforeEach(() => {
    vi.resetAllMocks();
    setActivePinia(createPinia());
});