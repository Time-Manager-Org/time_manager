<template>
  <div class="auth-container">
    <h2>Welcome Back</h2>
    <p style="color: #6b7280; margin-bottom: 24px;">Sign in to your account</p>
    
    <form @submit.prevent="signIn">
      <div class="form-group">
        <label>Username</label>
        <input v-model="username" type="text" placeholder="your_username" required />
      </div>
      <div class="form-group">
        <label>Password</label>
        <input v-model="password" type="password" placeholder="••••••••" required />
      </div>
      <button type="submit" class="btn-primary">Sign In</button>
      <div v-if="error" class="error-badge">{{ error }}</div>
    </form>
  </div>
</template>

<script>
import api from '../api';

export default {
  name: 'SignIn',
  data() {
    return {
      username: '',
      password: '',
      error: ''
    };
  },
  methods: {
    async signIn() {
      try {
        const response = await api.post('/users/sign_in', {
          username: this.username,
          password: this.password
        });
        
        // Check snake_case first (standard Phoenix output) or camelCase fallback
        const data = response.data.data || response.data;
        const token = data.xsrf_token || data.xsrfToken || data.token;
        const userId = data.user_id || data.userId || data.user?.id;

        if (token) {
          localStorage.setItem('xsrfToken', token);
          localStorage.setItem('userId', userId);

          localStorage.removeItem('role');

          // this.currentUserId = userId;

          this.$router.push('/');
        } else {
          this.error = 'Token missing in response';
        }
      } catch (err) {
        this.error = err.response?.data?.error || 'Invalid credentials';
      }
    }
  }
};
</script>