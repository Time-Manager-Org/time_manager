<template>
  <div class="auth-container">
    <h2>Create Account</h2>
    <p style="color: #6b7280; margin-bottom: 24px;">Register a new user account</p>

    <form @submit.prevent="signUp">
      <div class="form-group">
        <label>Full Name</label>
        <input v-model="full_name" type="text" placeholder="John Habibi" required />
      </div>
      <div class="form-group">
        <label>Username</label>
        <input v-model="username" type="text" placeholder="your_username" required />
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
  name: 'SignUp',
  data() {
    return {
    //   firstName: '',
    //   lastName: '',
    //   email: '',
    //   password: '',
        
        username: '',
        full_name: '',
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
            username: this.username,
            email: this.email,
            full_name: this.full_name,
            password: this.password

            // first_name: this.firstName,
            // last_name: this.lastName,
            // email: this.email,
            // password: this.password
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