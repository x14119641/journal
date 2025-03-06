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
const router = createRouter({
  history:createMemoryHistory(),
  routes:[]
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