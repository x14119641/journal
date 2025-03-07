import { mount, flushPromises } from "@vue/test-utils";
import { describe, it, expect, beforeEach, vi } from "vitest";
import { createTestingPinia } from "@pinia/testing";
import ProfileInfo from "@/components/ProfileInfo.vue";
import { useAuthStore } from "@/stores/authStore";
import api from "@/services/api";

describe("PropfileInfo Component Test", () => {
    it("get user data", async () => {
        api.get.mockResolvedValue({
            data: {
                id: 1,
                username: "testuser",
                email: "testuser@example.com",
                created_at: "2023-05-15T12:34:56Z",
            },
        });

        // Set the token BEFORE mounting the component
        const pinia = createTestingPinia({ stubActions: false });
        const authStore = useAuthStore(pinia);

        const validMockJWT =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." +
            "eyJleHAiOjI0MDE5MjAwMDB9." +
            "dGVzdFNpZ25hdHVyZQ";
        // We need to set token before mount the component
        // Cause in the component the data is fetched by onMounted()
        authStore.token = validMockJWT;const wrapper = mount(ProfileInfo, {
            global: { plugins: [pinia] },
        });
        await flushPromises(); // Wait for the API call to resolve
        console.log(wrapper.html())
        // Check if the correct data is displayed
        expect(wrapper.text()).toContain("User ID");
        expect(wrapper.text()).toContain("1");
        expect(wrapper.text()).toContain("Username");
        expect(wrapper.text()).toContain("testuser");
        expect(wrapper.text()).toContain("Email");
        expect(wrapper.text()).toContain("testuser@example.com");
        expect(wrapper.text()).toContain("Created At");
        expect(wrapper.text()).toContain("15-May-2023");
    })
});