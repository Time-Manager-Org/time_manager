<template>
  <div class="account-container">
    <h2>Account Profile</h2>
    <form @submit.prevent="updateProfile">
      <div>
        <label>First Name:</label>
        <input v-model="user.first_name" type="text" />
      </div>
      <div>
        <label>Last Name:</label>
        <input v-model="user.last_name" type="text" />
      </div>
      <div>
        <label>Email:</label>
        <input v-model="user.email" type="email" />
      </div>
      <div>
        <label>New Password:</label>
        <input v-model="user.password" type="password" placeholder="Leave blank to keep unchanged" />
      </div>
      <div>
        <label>Role:</label>
        <input :value="user.role" type="text" disabled />
      </div>
      <button type="submit">Save Changes</button>
    </form>
  </div>
</template>

<script>
import api from '../api';

export default {
  name: 'AccountManager',
  data() {
    return {
      user: {
        first_name: '',
        last_name: '',
        email: '',
        password: '',
        role: ''
      }
    };
  },
  async created() {
    const userId = localStorage.getItem('userId');
    const res = await api.get(`/users/${userId}`);
    this.user = { ...res.data.data, password: '' };
  },
  methods: {
    async updateProfile() {
      const userId = localStorage.getItem('userId');
      await api.put(`/users/${userId}`, { user: this.user });
      alert('Profile updated');
    }
  }
};
</script>