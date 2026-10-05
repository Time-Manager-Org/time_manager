<template>
  <div class="home-container" style="max-width: 800px; margin: 0 auto; padding: 20px;">
    <!-- If not logged in: Blank space -->
    <div v-if="!isLoggedIn"></div>

    <!-- If logged in: Display full dashboard -->
    <div v-else>
      <header style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ccc; padding-bottom: 10px;">
        <h2>Welcome, {{ user.firstName }} {{ user.lastName }}</h2>
        <button @click="disconnect" style="padding: 8px 16px; cursor: pointer;">Logout</button>
      </header>

      <section style="margin-top: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 4px;">
        <h3>Task Management</h3>
        <div style="display: flex; gap: 10px;">
          <input 
            type="text" 
            v-model="newTaskTitle" 
            placeholder="Enter task title..." 
            style="flex: 1; padding: 8px;"
          />
          <button @click="createAndAssignTask" style="padding: 8px 16px;">Add Task</button>
        </div>
      </section>

      <section style="margin-top: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 4px;">
        <h3>My Tasks</h3>
        <ul v-if="userTasks.length" style="list-style: none; padding: 0;">
          <li 
            v-for="task in userTasks" 
            :key="task.id" 
            style="display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #eee;"
          >
            <span>
              <input 
                type="checkbox" 
                :checked="task.status" 
                @change="toggleTaskStatus(task.id)" 
              />
              <strong :style="{ textDecoration: task.status ? 'line-through' : 'none', marginLeft: '8px' }">
                {{ task.title }}
              </strong>
            </span>
            <button @click="removeTask(task.id)" style="color: red; cursor: pointer;">Remove</button>
          </li>
        </ul>
        <p v-else style="color: #666;">No tasks currently assigned.</p>
      </section>

      <section style="margin-top: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 4px;">
        <h3>Skill Management</h3>
        <form @submit.prevent="addSkill" style="display: flex; gap: 10px;">
          <input
            v-model="newSkillName"
            type="text"
            placeholder="Enter a skill"
            required
            style="flex: 1; padding: 8px;"
          />
          <button type="submit" style="padding: 8px 16px;">Add Skill</button>
        </form>
      </section>

      <section style="margin-top: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 4px;">
        <h3>My Skills</h3>
        <ul v-if="userSkills.length" style="list-style: none; padding: 0;">
          <li 
            v-for="skill in userSkills" 
            :key="skill.id" 
            style="display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #eee;"
          >
            <span>{{ skill.name }}</span>
            <button @click="removeSkill(skill.id)" style="color: red; cursor: pointer;">Remove</button>
          </li>
        </ul>
        <p v-else style="color: #666;">No skills added yet.</p>
      </section>
    </div>
  </div>
</template>

<script>
import api from '../api';

export default {
  name: 'HomePage',
  data() {
    return {
      user: { firstName: '', lastName: '' },
      newTaskTitle: '',
      userTasks: [],
      newSkillName: '',
      userSkills: []
    };
  },
  computed: {
    isLoggedIn() {
      return !!localStorage.getItem('xsrfToken');
    },
    userId() {
      return localStorage.getItem('userId');
    }
  },
  mounted() {
    if (this.isLoggedIn && this.userId) {
      this.loadDashboard();
    }
  },
  methods: {
    async loadDashboard() {
      try {
        await Promise.all([
          this.fetchUserData(),
          this.fetchUserTasks(),
          this.fetchUserSkills()
        ]);
      } catch (err) {
        console.error('Error loading dashboard data:', err);
      }
    },
    async fetchUserData() {
      try {
        const res = await api.get('/profile');
        this.user = res.data.data || res.data;
      } catch (err) {
        console.error('Profile fetch failed:', err);
      }
    },
    async fetchUserTasks() {
      try {
        const res = await api.get('/tasks');
        const tasks = res.data.data || res.data;
        this.userTasks = tasks.filter(t => Number(t.user_id) === Number(this.userId));
      } catch (err) {
        console.error('Tasks fetch failed:', err);
      }
    },
    async fetchUserSkills() {
      try {
        const res = await api.get(`/users/${this.userId}/skills`);
        this.userSkills = res.data.data || res.data;
      } catch (err) {
        console.error('User skills fetch failed:', err);
      }
    },
    async createAndAssignTask() {
        if (!this.newTaskTitle.trim()) return;
        try {
            await api.post('/tasks', { 
            task: { 
                title: this.newTaskTitle, 
                status: false 
            } 
            });
            
            this.newTaskTitle = '';
            this.fetchUserTasks();
        } catch (err) {
            console.error('Add task failed:', err);
        }
    },
    async toggleTaskStatus(taskId) {
      try {
        await api.put(`/tasks/${taskId}/status`);
        this.fetchUserTasks();
      } catch (err) {
        console.error('Toggle status failed:', err);
      }
    },
    async removeTask(taskId) {
      try {
        await api.delete(`/tasks/${taskId}/user/${this.userId}`);
        this.fetchUserTasks();
      } catch (err) {
        console.error('Remove task failed:', err);
      }
    },
    async addSkill() {
      const name = this.newSkillName.trim();
      if (!name) return;

      try {
        await api.post(`/users/${this.userId}/skills`, { name });
        this.newSkillName = '';
        await this.fetchUserSkills();
      } catch (err) {
        console.error('Add skill failed:', err);
      }
    },
    async removeSkill(skillId) {
      try {
        await api.delete(`/users/${this.userId}/skills/${skillId}`);
        this.fetchUserSkills();
      } catch (err) {
        console.error('Remove skill failed:', err);
      }
    },
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
};
</script>