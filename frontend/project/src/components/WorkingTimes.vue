<template>
  <section>
    <h2>Working Times</h2>

    <button @click="getWorkingTimes">Get Working Times</button>

    <div v-for="workingTime in workingTimes" :key="workingTime.id">
      <p>
        ID: {{ workingTime.id }}
        <br />
        Duration: <strong>{{ formatDuration(workingTime.start, workingTime.end) }}</strong>
        <br />
        Start: {{ workingTime.start }}
        <br />
        End: {{ workingTime.end }}
      </p>
    </div>
  </section>
</template>

<script>
import api from '../api'

export default {
  name: "WorkingTimes",

  props: ["userId"],

  data() {
    return {
      workingTimes: []
    }
  },

  watch: {
    userId() {
      this.workingTimes = []
    }
  },

  methods: {
    getWorkingTimes() {
      if (!this.userId) {
        return
      }

      api
        .get(`/workingtime/${this.userId}`)
        .then((response) => {
          this.workingTimes = response.data.data
        })
        .catch((error) => {
          console.error(error)
        })
    },

    formatDuration(startStr, endStr) {
      if (!startStr || !endStr) return '0s'

      const start = new Date(startStr)
      const end = new Date(endStr)
      
      // Difference in seconds
      const diffInSeconds = Math.floor((end - start) / 1000)

      if (isNaN(diffInSeconds) || diffInSeconds < 0) return '0s'

      const hours = Math.floor(diffInSeconds / 3600)
      const minutes = Math.floor((diffInSeconds % 3600) / 60)
      const seconds = diffInSeconds % 60

      if (hours > 0) return `${hours}h ${minutes}m`
      if (minutes > 0) return `${minutes}m ${seconds}s`
      return `${seconds}s`
    },
  }
}
</script>
