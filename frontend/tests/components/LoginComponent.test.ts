import { mount } from "@vue/test-utils";
import { describe, it, expect, vi } from "vitest";
import { createTestingPinia } from "@pinia/testing";
import LoginComponent from "@/components/LoginComponent.vue"
import  {useAuthStore } from "@/stores/authStore";


describe("Login Component Test", () => {
    it("Renders login forms", () => {
        const wrapper = mount(LoginComponent, {
            global: {plugins:[createTestingPinia()]}
        });

        expect(wrapper.find('h3').text()).toBe('Login')
        expect(wrapper.find('form').exists()).toBe(true)
        expect(wrapper.find('input#username').exists()).toBe(true)
        expect(wrapper.find('input#password').exists()).toBe(true)
        expect(wrapper.find('errorMessage').exists()).toBe(false)
    });

    it("CAlls submit login", async () => {
        const wrapper = mount(LoginComponent, {
            global: {plugins:[createTestingPinia({stubActions:false})]}
        });
        const authStore = useAuthStore()
        authStore.login = vi.fn()

        await wrapper.find('#username').setValue('test')
        await wrapper.find('#password').setValue('bla')
        await wrapper.find('form').trigger('submit.prevent')

        expect(authStore.login).toHaveBeenCalledWith('test', 'bla')
    });
    it("Calls submit login, test user exist", async () => {
        const wrapper = mount(LoginComponent, {
            global: {plugins:[createTestingPinia({stubActions:false})]}
        });
        const authStore = useAuthStore()
        authStore.login = vi.fn().mockImplementation(() => {
            authStore.errorMessage = "Invalid username or password"
        })

        await wrapper.find('#username').setValue('foo')
        await wrapper.find('#password').setValue('bla')
        await wrapper.find('form').trigger('submit.prevent')

        expect(authStore.login).toHaveBeenCalledWith('foo', 'bla')
        await wrapper.vm.$nextTick();
        expect(wrapper.text()).toContain("Invalid username");
    });
})
