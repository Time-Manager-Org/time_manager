<template>
  <div>
    <h2>Registered Users</h2>
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Email</th>
          <th>Role</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="u in users" :key="u.id">
          <td>{{ u.id }}</td>
          <td>{{ u.first_name }} {{ u.last_name }}</td>
          <td>{{ u.email }}</td>
          <td>{{ u.role ? u.role.label : 'User' }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import api from '../api';

export default {
  name: 'UsersManager',
  data() {
    return {
      users: []
    };
  },
  async created() {
    const res = await api.get('/users');
    this.users = res.data.data;
  }
};
</script>