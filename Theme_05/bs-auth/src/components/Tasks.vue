<template>
  <div>
    <h2>Tasks</h2>
    
    <!-- Manager Creation Form -->
    <form v-if="isManager" @submit.prevent="createTask">
      <input v-model="newTaskName" placeholder="Task Name" required />
      <button type="submit">Create Task</button>
    </form>

    <ul>
      <li v-for="task in tasks" :key="task.id">
        <span>{{ task.title }} - Status: {{ task.status ? 'Completed' : 'Pending' }}</span>
        
        <button @click="toggleStatus(task)">
          Mark as {{ task.status ? 'Pending' : 'Completed' }}
        </button>

        <!-- Manager Operations -->
        <div v-if="isManager" style="display:inline-block; margin-left: 10px;">
          <button @click="assignUser(task.id)">Assign User</button>
          <button @click="assignSkill(task.id)">Assign Skill</button>
          <button @click="deleteTask(task.id)">Delete Task</button>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import api from '../api';

export default {
  name: 'TasksManager',
  data() {
    return {
      tasks: [],
      newTaskName: ''
    };
  },
  computed: {
    isManager() {
      return localStorage.getItem('role') === 'Manager';
    }
  },
  async created() {
    this.fetchTasks();
  },
  methods: {
    async fetchTasks() {
      const res = await api.get('/tasks');
      this.tasks = res.data.data;
    },
    async createTask() {
      await api.post('/tasks', { task: { title: this.newTaskName, status: false } });
      this.newTaskName = '';
      this.fetchTasks();
    },
    async toggleStatus(task) {
      await api.put(`/tasks/${task.id}/status`, { status: !task.status });
      this.fetchTasks();
    },
    async assignUser(taskId) {
      const userId = prompt('Enter User ID to assign:');
      if (userId) {
        await api.post(`/tasks/${taskId}/user/${userId}`);
        this.fetchTasks();
      }
    },
    async assignSkill(taskId) {
      const skillId = prompt('Enter Skill ID to assign:');
      if (skillId) {
        await api.put(`/tasks/${taskId}/skills/${skillId}`);
        this.fetchTasks();
      }
    },
    async deleteTask(id) {
      await api.delete(`/tasks/${id}`);
      this.fetchTasks();
    }
  }
};
</script>