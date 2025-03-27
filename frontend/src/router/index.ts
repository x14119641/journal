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
import TransactionDetailPage from '../pages/TransactionDetailPage.vue';
import ColorsPage from '../pages/ColorsPage.vue';
import DashboardPage from '../pages/DashboardPage.vue';
import ForgotPasswordPage from '../pages/ForgotPasswoPage.vue';

const isTest = process.env.NODE_ENV ==="test";
import api from '../services/api';

const routes = [
  { path: '/', name: 'Demo0', component: DemoPage, meta: { requiresAuth: false }},
  { path: '/demo', name: 'Demo', component: DemoPage, meta: { requiresAuth: false } },
  { path: '/hello', name: 'Hello', component: HelloPage, meta: { requiresAuth: false } },
  { path: '/table', name: 'Table', component: TablePage, meta: { requiresAuth: true } },
  { path: '/colors', name: 'Colors', component: ColorsPage, meta: { requiresAuth: false } },
  { path: '/funds', name: 'Funds', component: ManageFundsPage, meta: { requiresAuth: true } },
  { path: '/dashboard', name: 'Funds', component: DashboardPage, meta: { requiresAuth: true } },
  { path: '/transactions', name: 'Transactions', component: TransactionsPage, meta: { requiresAuth: true } },
  { path: '/transactions/:id', name: 'TransactionDetail', component: TransactionDetailPage, meta: { requiresAuth: true } },
  { path: '/login', name: 'Login', component: LoginPage, meta: { requiresAuth: false } },
  { path: '/profile', name: 'Profile', component: ProfilePage, meta: { requiresAuth: true }},
  { path: '/dividends', name: 'Dividend', component: DividendsPage, meta: { requiresAuth: true } },
  { path: '/calendar', name: 'Calendar', component: FullCalendarPage, meta: { requiresAuth: true } },
  { path: '/screener', name: 'Screener', component: ScreenerPage, meta: { requiresAuth: true } },
  { path: '/stocks/:ticker', name: 'Stocks', component: StockPage, meta: { requiresAuth: false } },
  { path: '/register', name: 'Register', component: RegisterPage, meta: { requiresAuth: false } },
  { path: '/forgot-password', name: 'Forgot Password', component: ForgotPasswordPage, meta: { requiresAuth: false } },
];

const router = createRouter({
  history: isTest ? createMemoryHistory() : createWebHistory(), // Use memory history when tests
  routes,
});

let isRefreshing = false;
let refreshPromise: Promise<any> | null = null;

router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore();
  const isTokenExpired = authStore.isTokenExpired();

  if (isTokenExpired && authStore.refreshToken) {
    console.log('🔁 Token expired — attempting refresh');

    try {
      if (!isRefreshing) {
        isRefreshing = true;
        refreshPromise = api.post('/refresh', null, {
          headers: {
            Authorization: `Bearer ${authStore.refreshToken}`
          }
        });
        const response = await refreshPromise;

        authStore.token = response.data.access_token;
        authStore.refreshToken = response.data.refresh_token;
        await authStore.fetchUser()
        
        isRefreshing = false;
        refreshPromise = null;
      } else {
        // Wait for the other refresh to complete
        await refreshPromise;
      }

      next(); // ✅ Proceed after refresh
      return;
    } catch (err) {
      console.warn('🔒 Refresh failed, logging out...');
      authStore.removeToken();
      isRefreshing = false;
      refreshPromise = null;
      return next('/login');
    }
  }

  // Not authenticated and route requires auth
  if (to.meta.requiresAuth && !authStore.token) {
    console.log('🔐 No token, redirecting to login...');
    return next('/login');
  }

  next(); // ✅ Default forward
});

export default router;