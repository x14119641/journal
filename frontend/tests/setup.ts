import { createPinia, setActivePinia } from "pinia";
import { beforeEach, vi } from "vitest";

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
  

// ✅ Mock localStorage globally
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

beforeEach(() => {
    vi.resetAllMocks();
    setActivePinia(createPinia());
});