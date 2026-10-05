<template>
  <div class="auth-container">
    <h2>Create Account</h2>
    <p style="color: #6b7280; margin-bottom: 24px;">Register a new user account</p>

    <form @submit.prevent="signUp">
      <div class="form-group">
        <label>First Name</label>
        <input v-model="firstName" type="text" placeholder="John" required />
      </div>
      <div class="form-group">
        <label>Last Name</label>
        <input v-model="lastName" type="text" placeholder="Doe" required />
      </div>
      <div class="form-group">
        <label>Email Address</label>
        <input v-model="email" type="email" placeholder="you@example.com" required />
      </div>
      <div class="form-group">
        <label>Password</label>
        <input v-model="password" type="password" placeholder="••••••••" required />
      </div>
      <button type="submit" class="btn-primary">Sign Up</button>
      <div v-if="error" class="error-badge">{{ error }}</div>
    </form>
  </div>
</template>

<script>
import api from '../api';

export default {
  name: 'UserRegistration',
  data() {
    return {
      firstName: '',
      lastName: '',
      email: '',
      password: '',
      error: ''
    };
  },
  methods: {
    async signUp() {
      try {
        await api.post('/users/sign_up', {
          user: {
            first_name: this.firstName,
            last_name: this.lastName,
            email: this.email,
            password: this.password
          }
        });
        this.$router.push('/sign_in');
      } catch (err) {
        this.error = err.response?.data?.error || 'Registration failed';
      }
    }
  }
};
</script>