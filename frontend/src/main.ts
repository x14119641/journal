import { createApp } from 'vue'
import "@/assets/css/style.css"; 
import App from './App.vue'
import { createPinia } from 'pinia'
import router from './router';
import { useAuthStore } from './stores/authStore';
import VueClickAway from "vue3-click-away";


const app = createApp(App)
app.use(createPinia()).use(VueClickAway)


// Fetch user if click refresh and user is logged in and token is ok 
const authStore = useAuthStore();
authStore.fetchUser().then(() => {
  app.use(router);
  app.mount('#app');
});


