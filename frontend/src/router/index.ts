import { createRouter, createWebHistory } from 'vue-router';
import DemoPage from '../pages/DemoPage.vue';
import HelloPage from '../pages/HelloPage.vue';

const routes = [
  { path: '/demo', name: 'Demo', component: DemoPage },
  { path: '/hello', name: 'Hello', component: HelloPage },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;