import { createRouter, createWebHistory } from 'vue-router';
import DemoPage from '../pages/DemoPage.vue';
import HelloPage from '../pages/HelloPage.vue';
import LoginPage from '../pages/LoginPage.vue';
import ProfilePage from '../pages/ProfilePage.vue';
import TablePage from '../pages/TablePage.vue';
import { useAuthStore } from '../stores/authStore';
import DividendsPage from '../pages/DividendsPage.vue';
import FullCalendarPage from '../pages/FullCalendarPage.vue';
import StockPage from '../pages/StockPage.vue';


const routes = [
  { path: '/demo', name: 'Demo', component: DemoPage },
  { path: '/hello', name: 'Hello', component: HelloPage },
  { path: '/table', name: 'Table', component: TablePage },
  { path: '/login', name: 'Login', component: LoginPage },
  { path: '/profile', name: 'Profile', component: ProfilePage, meta: { requiresAuth: true } },
  { path: '/dividends', name: 'Dividend', component: DividendsPage },
  { path: '/calendar', name: 'Calendar', component: FullCalendarPage },
  { path: '/stocks/:ticker', name: 'Stocks', component: StockPage },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();
  
  console.log('Token:', authStore.token); // Check the token
  console.log('Requires Auth:', to.meta.requiresAuth); // Check if the route requires auth
  console.log('Token Expired:', authStore.isTokenExpired()); // Debug token expiry

  const x = authStore.isTokenExpired()
  console.log(x)
  if (x==true) {
    if (to.name !== 'Login') {
      authStore.logout();
      next('/login');
    } else {
      next();
    }
  } else if (to.meta.requiresAuth && !authStore.token) {
    next('/login'); // Allow navigation
  } else {
    next();
  }
});

export default router;