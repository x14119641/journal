import { mount } from "@vue/test-utils";
import { describe, it , expect } from "vitest";
import LoginPage from "@/pages/LoginPage.vue";

describe('LoginPage', () => {
    it('renders LoginComponent', () => {
      const wrapper = mount(LoginPage)
      expect(wrapper.findComponent({ name: 'LoginComponent' }).exists()).toBe(true)
    })
  });