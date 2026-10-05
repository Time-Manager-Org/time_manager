<template>
  <div>
    <h2>Skills Manager</h2>
    <form @submit.prevent="createSkill">
      <input v-model="newSkillLabel" placeholder="Skill Name" required />
      <button type="submit">Add Skill</button>
    </form>
    <ul>
      <li v-for="skill in skills" :key="skill.id">
        {{ skill.label }}
        <button @click="deleteSkill(skill.id)">Delete</button>
      </li>
    </ul>
  </div>
</template>

<script>
import api from '../api';

export default {
  name: 'SkillsManager',
  data() {
    return {
      skills: [],
      newSkillLabel: ''
    };
  },
  async created() {
    this.fetchSkills();
  },
  methods: {
    async fetchSkills() {
      const res = await api.get('/skills');
      this.skills = res.data.data;
    },
    async createSkill() {
      await api.post('/skills', { skill: { label: this.newSkillLabel } });
      this.newSkillLabel = '';
      this.fetchSkills();
    },
    async deleteSkill(id) {
      await api.delete(`/skills/${id}`);
      this.fetchSkills();
    }
  }
};
</script>