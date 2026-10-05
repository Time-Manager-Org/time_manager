<script>
import User from './User.vue'
import WorkingTimes from './WorkingTimes.vue'
import WorkingTime from './WorkingTime.vue'
import ClockManager from './ClockManager.vue'
import ChartManager from './ChartManager.vue'

export default {
  components: {
    User,
    WorkingTimes,
    WorkingTime,
    ClockManager,
    ChartManager
  },

  data() {
    return {
      currentUserId: localStorage.getItem('userId') || null
    }
  },

  methods: {
    changeUser(userId) {
      this.currentUserId = userId
      if (userId) {
        localStorage.setItem('userId', userId)
      } else {
        localStorage.removeItem('userId')
      }
    }
  }
}
</script>

<template>
  <main>
    <User @userChanged="changeUser" />
    <ClockManager :userId="currentUserId" />
    <WorkingTimes :userId="currentUserId" />
    <WorkingTime :userId="currentUserId" />
    <ChartManager :userId="currentUserId" />
  </main>
</template>
