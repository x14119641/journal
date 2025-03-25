import { describe, it, expect, vi } from "vitest";
import { useAuthStore } from "@/stores/authStore";
import type { MockedFunction } from "vitest";
import api from "@/services/api";



describe("authStore Test", () => {
  const validMockJWT =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." +
    "eyJleHAiOjI0MDE5MjAwMDB9." +
    "dGVzdFNpZ25hdHVyZQ";

  const expiredTokenJWT = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." +
    "eyJleHAiOjE2NzI4MzQyMDB9." + // Expired timestamp
    "dGVzdFNpZ25hdHVyZQ";
  const futureTokenJWT = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." +
    "eyJleHAiOjI0MDE5MjAwMDB9." + // Future timestamp
    "dGVzdFNpZ25hdHVyZQ";

  it("logs in successfully and saves token to localStorage", async () => {
    // Login
    (api.post as MockedFunction<typeof api.post>).mockResolvedValue({
      data: { access_token: validMockJWT },
    });

    const authStore = useAuthStore();
    await authStore.login("test", "test");

    console.log("API Calls:", (api.post as MockedFunction<typeof api.post>).mock.calls);
    console.log("Auth Store Token:", authStore.token);
    console.log("LocalStorage Calls:", localStorage.setItem.mock.calls);


    expect(authStore.token).toBe(validMockJWT);
    expect(localStorage.setItem as MockedFunction<(key: string, value: string) => void>)
      .toHaveBeenCalledWith("token", validMockJWT);
  });
  // Logout
  it("removes token from localStorage on logout", () => {
    const authStore = useAuthStore();
    authStore.token = validMockJWT;
    authStore.logout();

    expect(localStorage.removeItem as MockedFunction<(key: string) => void>)
      .toHaveBeenCalledWith("token");
    expect(authStore.token).toBe("");
  });
  // Is token Expired
  it("returns true if the token is expired", () => {
    const authStore = useAuthStore();
    authStore.token = expiredTokenJWT


    expect(authStore.isTokenExpired()).toBe(true);
  });
  it("returns false if the token is expired", () => {
    const authStore = useAuthStore();
    authStore.token = futureTokenJWT


      expect(authStore.isTokenExpired()).toBe(false);
  });
  // Fetch user
  it("fetches user data succesfully", async () => {

    const authStore = useAuthStore();

    authStore.token = validMockJWT;
    (api.get as MockedFunction<typeof api.get>).mockResolvedValue({
      data: {
        id: "1",
        username: "test",
        email: "test@email.com",
        created_at: "1/1/2025"
      },
    });

    await authStore.fetchUser();
    expect(authStore.username).toBe("test")
    expect(authStore.id).toBe("1")
  });

  // Fetch user when token is expiored ( dont get any user)
  it("logs out if the token is experied when trying to fetchUSer", async () => {
    const authStore = useAuthStore();
    authStore.token = expiredTokenJWT;
    const logoutSpy = vi.spyOn(authStore, "logout");
    await authStore.fetchUser();
    expect(logoutSpy).toHaveBeenCalled();
    expect(authStore.token).toBe("")
  });

  // Handle API erro on fetchUSer
  it("does not update user data if API calls fails", async ()=>{
    const authStore = useAuthStore();
    authStore.token =validMockJWT;
    authStore.username = "userexists";
    authStore.id="2";
    (api.get as MockedFunction<typeof api.get>).mockRejectedValue(new Error("API error"));

    await authStore.fetchUser();

    expect(authStore.username).toBe("userexists");
    expect(authStore.id).toBe("2");
  });

  // Handle FAil Login
  it("sets error message when login fails", async () => {
    (api.post as MockedFunction<typeof api.post>).mockRejectedValue(new Error("Login Fail"));
    const authStore = useAuthStore();
    await authStore.login("wrongUSer", "wrongPassword");
    expect(authStore.errorMessage).toBe("Invalid username or password")
  });
});