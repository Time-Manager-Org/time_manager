<script> 
import api from './api'

export default {
  name: 'App',

  computed: {
    isLoggedIn() {
      return !!localStorage.getItem('xsrfToken');
    }
  },

  methods: {
    async disconnect() {
      try {
        await api.post('/users/sign_out');
      } catch (err) {
        console.error('Logout error:', err);
      } finally {
        localStorage.clear();
        this.$router.push('/sign_in');
      }
    }
  }
}



</script>

<template>
  <div id="app">
    <nav style="padding: 15px; border-bottom: 1px solid #ddd; margin-bottom: 20px;">
      <router-link to="/">Home</router-link> |
      <router-link to="/sign_in">Sign In</router-link> |
      <router-link to="/sign_up">Sign Up</router-link>

      <button 
        v-if="isLoggedIn" 
        @click="disconnect" 
        style="margin-left: 15px; cursor: pointer;"
      >
        Logout
      </button>
    </nav>
    <router-view />
  </div>
</template>
