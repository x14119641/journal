import { createRouter, createWebHistory, createMemoryHistory  } from 'vue-router';
import DemoPage from '../pages/DemoPage.vue';
import HelloPage from '../pages/HelloPage.vue';
import LoginPage from '../pages/LoginPage.vue';
import ProfilePage from '../pages/ProfilePage.vue';
import TablePage from '../pages/TablePage.vue';
import { useAuthStore } from '../stores/authStore';
import DividendsPage from '../pages/DividendsPage.vue';
import FullCalendarPage from '../pages/FullCalendarPage.vue';
import StockPage from '../pages/StockPage.vue';
import ScreenerPage from '../pages/ScreenerPage.vue';
import RegisterPage from '../pages/RegisterPage.vue';
import ManageFundsPage from '../pages/ManageFundsPage.vue';
import TransactionsPage from '../pages/TransactionsPage.vue';
import ColorsPAge from '../pages/ColorsPAge.vue';


const isTest = process.env.NODE_ENV ==="test";


const routes = [
  { path: '/', name: 'Demo0', component: DemoPage, meta: { requiresAuth: false }},
  { path: '/logout', name: 'Logout', beforeEnter: (to, from, next) => {
    const authStore = useAuthStore();
    authStore.logout()
  }},
  { path: '/demo', name: 'Demo', component: DemoPage, meta: { requiresAuth: false } },
  { path: '/hello', name: 'Hello', component: HelloPage, meta: { requiresAuth: false } },
  { path: '/table', name: 'Table', component: TablePage, meta: { requiresAuth: true } },
  { path: '/colors', name: 'Colors', component: ColorsPAge, meta: { requiresAuth: false } },
  { path: '/funds', name: 'Funds', component: ManageFundsPage, meta: { requiresAuth: true } },
  { path: '/transactions', name: 'Transactions', component: TransactionsPage, meta: { requiresAuth: true } },
  { path: '/login', name: 'Login', component: LoginPage, meta: { requiresAuth: false } },
  { path: '/profile', name: 'Profile', component: ProfilePage, meta: { requiresAuth: true } },
  { path: '/dividends', name: 'Dividend', component: DividendsPage, meta: { requiresAuth: true } },
  { path: '/calendar', name: 'Calendar', component: FullCalendarPage, meta: { requiresAuth: true } },
  { path: '/screener', name: 'Screener', component: ScreenerPage, meta: { requiresAuth: true } },
  { path: '/stocks/:ticker', name: 'Stocks', component: StockPage, meta: { requiresAuth: false } },
  { path: '/register', name: 'Register', component: RegisterPage, meta: { requiresAuth: false } },
];

const router = createRouter({
  history: isTest ? createMemoryHistory() : createWebHistory(), // Use memory history when tests
  routes,
});

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();
  // Dubugging
  // console.log('Token:', authStore.token); 
  // console.log('Requires Auth:', to.meta.requiresAuth); 
  

  const isAuthenticated = !!authStore.token;
  const isTokenExpired = authStore.isTokenExpired();
  
  // console.log('Token isAuthenticated:', isAuthenticated); 
  // console.log('Token Expired:', isTokenExpired); 

  if (isTokenExpired) {
    console.log("Token is indeed expired: ", isTokenExpired)
    authStore.removeToken();
  }

  if (to.meta.requiresAuth && !authStore.token) {
    console.log('Redirecting to login');
    next('/login');
  } else {
    next(); 
  }
});

export default router;