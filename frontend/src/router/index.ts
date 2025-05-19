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
import ForgotPasswordPage from '../pages/ForgotPasswordPage.vue';
import ResetPasswordPage from '../pages/ResetPasswordPage.vue';
import BacktestingPage from '../pages/BacktestingPage.vue';

const isTest = process.env.NODE_ENV ==="test";


const routes = [
  { path: '/', name: 'Demo0', component: DemoPage, meta: { requiresAuth: false }},
  { path: '/demo', name: 'Demo', component: DemoPage, meta: { requiresAuth: false } },
  { path: '/backtesting', name: 'Backtesting', component: BacktestingPage, meta: { requiresAuth: false }},
  { path: '/hello', name: 'Hello', component: HelloPage, meta: { requiresAuth: false } },
  { path: '/table', name: 'Table', component: TablePage, meta: { requiresAuth: true } },
  { path: '/colors', name: 'Colors', component: ColorsPage, meta: { requiresAuth: false } },
  { path: '/funds', name: 'Funds', component: ManageFundsPage, meta: { requiresAuth: true } },
  { path: '/dashboard', name: 'Dashboard', component: DashboardPage, meta: { requiresAuth: true } },
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
  { path: '/reset-password', name: 'Reset Password', component: ResetPasswordPage, meta: { requiresAuth: false } },
];

const router = createRouter({
  history: isTest ? createMemoryHistory() : createWebHistory(), // Use memory history when tests
  routes,
});

let isRefreshing = false;
let refreshPromise: Promise<any> | null = null;

router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore();

  const routeNeedsAuth = to.meta.requiresAuth;
  const hasToken = !!authStore.token;
  const isExpired = authStore.isTokenExpired();

  // If the route doesn't need auth, just go
  if (!routeNeedsAuth) {
    return next();
  }

  // Route requires auth but no token and no refresh token
  if (!hasToken && !authStore.refreshToken) {
    console.warn('🔐 No token and no refresh token. Redirecting to login.');
    authStore.removeToken(); // Make sure we reset state
    return next('/login');
  }

  if (routeNeedsAuth && !authStore.token) {
    console.warn('❌ No valid token — redirecting to login.');
    authStore.removeToken();
    return next('/login');
  }

  // After refresh, or if token is still valid, make sure user is loaded
  if (!authStore.token || !authStore.username) {
    console.warn('❌ Token or user missing. Redirecting to login.');
    authStore.removeToken();
    return next('/login');
  }

  return next(); // ✅ All good, allow navigation
});

export default router;