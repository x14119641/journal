import { createRouter, createWebHistory } from 'vue-router';
import DemoPage from '../pages/DemoPage.vue';
import HelloPage from '../pages/HelloPage.vue';
import LoginPage from '../pages/LoginPage.vue';
import ProfilePage from '../pages/ProfilePage.vue';
import TablePage from '../pages/TablePage.vue';
import { useAuthStore } from '../stores/authStore';

const routes = [
  { path: '/demo', name: 'Demo', component: DemoPage },
  { path: '/hello', name: 'Hello', component: HelloPage },
  { path: '/table', name: 'Table', component: TablePage },
  { path: '/login', name: 'Login', component: LoginPage },
  { path: '/profile', name: 'Profile', component: ProfilePage, meta: { requiresAuth: true } },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();
  
  console.log('Token:', authStore.token); // Check the token
  console.log('Requires Auth:', to.meta.requiresAuth); // Check if the route requires auth
  
  if (to.meta.requiresAuth && !authStore.token) {
    console.log('Redirecting to login');
    next('/login'); // Redirect to login if not authenticated
  } else {
    next(); // Allow navigation
  }
});

export default router;