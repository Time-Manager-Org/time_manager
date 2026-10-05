import { createRouter, createWebHistory } from 'vue-router';

import Home from './components/Home.vue';
import SignIn from './components/SignIn.vue';
import SignUp from './components/SignUp.vue';

const routes = [
  { path: '/', component: Home, meta: { requiresAuth: true } },
  { path: '/sign_in', component: SignIn },
  { path: '/sign_up', component: SignUp }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('xsrfToken')

  if (to.meta.requiresAuth && !token) {
    next('/sign_in')
  } else {
    next()
  }
});

export default router;