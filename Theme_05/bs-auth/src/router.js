import { createRouter, createWebHistory } from 'vue-router';

import HomePage from './components/Home.vue';
import SignIn from './components/SignIn.vue';
import UserRegistration from './components/Registration.vue';
import AccountsManager from './components/AccountsManager.vue';
import SkillsManager from './components/SkillsManager.vue';
import UsersManager from './components/Users.vue';
import TasksManager from './components/Tasks.vue';

const routes = [
  { path: '/', component: HomePage, meta: { type: 'public' } },
  { path: '/sign_in', component: SignIn, meta: { type: 'public' } },
  { path: '/sign_up', component: UserRegistration, meta: { type: 'public' } },
  { path: '/profile', component: AccountsManager, meta: { type: 'private' } },
  { path: '/tasks', component: TasksManager, meta: { type: 'private' } },
  { path: '/skills', component: SkillsManager, meta: { type: 'administration' } },
  { path: '/skills/:skillId', component: SkillsManager, meta: { type: 'administration' } },
  { path: '/users', component: UsersManager, meta: { type: 'administration' } },
  { path: '/tasks/:taskId', component: TasksManager, meta: { type: 'administration' } }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('xsrfToken');
  const role = localStorage.getItem('role');

  if (to.meta.type === 'public') {
    next();
  } else if (to.meta.type === 'private') {
    if (token) next();
    else next('/sign_in');
  } else if (to.meta.type === 'administration') {
    if (token && role === 'Manager') next();
    else next('/sign_in');
  } else {
    next();
  }
});

export default router;