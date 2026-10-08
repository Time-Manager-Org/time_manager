<template>
  <div class="workspace-shell">
    <aside class="sidebar">
      <div class="brand-lockup">
        <span class="brand-mark" aria-hidden="true">
          <svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="8.25"/><path d="M12 7v5l3.4 2"/></svg>
        </span>
        <span>Manager Dashboard</span>
      </div>

      <nav class="side-navigation" aria-label="Main navigation">
        <a class="nav-item" href="#page-1">
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="m3.5 10.5 8.5-7 8.5 7"/><path d="M5.5 9.5v10h5v-6h3v6h5v-10"/></svg>
          <span>Home</span>
        </a>
        <a class="nav-item" href="#page-2">
          <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="8.5"/><path d="M12 7v5l3.5 2"/></svg>
          <span>My Times</span>
        </a>
        <a class="nav-item" href="#page-3">
          <svg viewBox="0 0 24 24" aria-hidden="true"><rect x="4" y="5.5" width="16" height="15" rx="2"/><path d="M8 3.5v4M16 3.5v4M4 10h16"/></svg>
          <span>Schedule</span>
        </a>
        <a class="nav-item" href="#page-4">
          <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="8" r="3.5"/><path d="M4.5 20c.5-3.2 3.4-5.3 7.5-5.3s7 2.1 7.5 5.3"/></svg>
          <span>Profile</span>
        </a>
      </nav>

      <button class="sidebar-logout" @click="disconnect">
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M10 4H5.5A1.5 1.5 0 0 0 4 5.5v13A1.5 1.5 0 0 0 5.5 20H10M14 8l4 4-4 4M8 12h10"/></svg>
        <span>Log out</span>
      </button>
    </aside>

    <main class="page-content">
      <section id="page-1" class="page-placeholder">Page 1</section>
      <section id="page-2" class="page-placeholder">Page 2</section>
      <section id="page-3" class="page-placeholder">Page 3</section>
      <section id="page-4" class="page-placeholder profile-page">
        <div class="page-heading">
          <div>
            <p class="eyebrow">Account details</p>
            <h1>Profile</h1>
            <p class="date-line">Your Time Manager account information.</p>
          </div>
        </div>
        <article class="profile-card">
          <span class="profile-avatar">{{ initials }}</span>
          <div>
            <h2>{{ displayName }}</h2>
            <p>{{ profile.email || 'Email not available' }}</p>
            <span class="profile-role">Manager</span>
          </div>
        </article>
        <button class="profile-logout" @click="disconnect">Log out</button>
      </section>
    </main>
  </div>
</template>

<script>
import api from '../api'

export default {
  name: 'AdminDashboard',
  data() {
    return {
      userId: localStorage.getItem('userId'),
      profile: {}
    }
  },
  computed: {
    displayName() {
      return this.profile.username || this.profile.name || 'Welcome'
    },
    initials() {
      return this.displayName.split(/[\s._-]+/).filter(Boolean).slice(0, 2).map((part) => part[0]).join('').toUpperCase() || 'TM'
    }
  },
  mounted() {
    this.loadProfile()
  },
  methods: {
    async loadProfile() {
      if (!this.userId) return
      try {
        const response = await api.get(`/users/${this.userId}`)
        this.profile = response.data.data || {}
      } catch (error) {
        console.error('Could not load profile:', error)
      }
    },
    async disconnect() {
      try {
        await api.post('/users/sign_out')
      } catch (error) {
        console.error('Logout error:', error)
      } finally {
        localStorage.clear()
        this.$router.push('/login')
      }
    }
  }
}
</script>

<style scoped>
.workspace-shell { --accent: var(--app-accent); --ink: var(--app-text); display: grid; min-height: 100vh; grid-template-columns: 248px minmax(0, 1fr); color: var(--ink); background: var(--app-background); font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "Segoe UI", sans-serif; }
.sidebar { position: sticky; top: 0; display: flex; height: 100vh; flex-direction: column; padding: 24px 16px; color: #fff; background: #102c4b; }
.brand-lockup { display: flex; min-height: 54px; align-items: center; gap: 12px; padding: 0 8px; font-size: 18px; font-weight: 700; }
.brand-mark { display: grid; width: 40px; height: 40px; flex: 0 0 40px; place-items: center; border-radius: 12px; background: var(--accent); }
.brand-mark svg { width: 24px; stroke: #fff; stroke-linecap: round; stroke-linejoin: round; stroke-width: 1.8; }
.side-navigation { display: grid; gap: 7px; margin-top: 42px; }
.nav-item { display: flex; min-height: 48px; align-items: center; gap: 13px; padding: 0 14px; border-radius: 12px; color: #aebed0; text-decoration: none; font-size: 14px; }
.nav-item:hover, .nav-item:focus-visible { color: #f2f8ff; background: #183d62; outline: none; }
.nav-item svg { width: 19px; height: 19px; flex: 0 0 19px; fill: none; stroke: currentColor; stroke-linecap: round; stroke-linejoin: round; stroke-width: 1.8; }
.sidebar-logout { display: flex; align-items: center; gap: 12px; margin: auto 0 4px; padding: 12px 14px; border: 0; color: #adbdce; background: none; text-align: left; font: inherit; cursor: pointer; }
.sidebar-logout:hover, .sidebar-logout:focus-visible { color: #fff; outline: none; }
.sidebar-logout svg { width: 19px; height: 19px; flex: 0 0 19px; fill: none; stroke: currentColor; stroke-linecap: round; stroke-linejoin: round; stroke-width: 1.8; }
.page-content { display: grid; min-width: 0; min-height: 100vh; place-items: center; padding: 32px; }
.page-placeholder { display: none; font-size: 24px; font-weight: 600; }
.page-placeholder:first-child { display: block; }
.page-content:has(.page-placeholder:target) .page-placeholder { display: none; }
.page-content:has(.page-placeholder:target) .page-placeholder:target { display: block; }
.page-content:has(#page-4:target) { display: block; padding: 36px clamp(28px, 4vw, 64px) 52px; }
.profile-page { width: min(100%, 1500px); margin: 0 auto; font-size: 14px; font-weight: 400; }
.page-heading { display: flex; align-items: flex-end; justify-content: space-between; gap: 18px; margin-bottom: 26px; }
.eyebrow { margin: 0 0 7px; color: #8b929d; font-size: 12px; font-weight: 650; text-transform: uppercase; }
.page-heading h1 { margin: 0; color: #20242c; font-size: clamp(26px, 3vw, 34px); font-weight: 720; }
.date-line { margin: 8px 0 0; color: #8b929d; font-size: 14px; }
.profile-card { display: flex; align-items: center; gap: 18px; padding: 24px; border: 1px solid #eceef2; border-radius: 20px; background: #fff; box-shadow: 0 6px 20px rgb(27 41 61 / 5%); }
.profile-avatar { display: grid; width: 62px; height: 62px; flex: 0 0 62px; place-items: center; border-radius: 50%; color: #fff; background: var(--accent); font-size: 19px; font-weight: 700; }
.profile-card h2 { margin: 0 0 6px; font-size: 18px; }
.profile-card p { margin: 0; color: #89919c; font-size: 14px; }
.profile-role { display: inline-block; margin-top: 10px; padding: 5px 9px; border-radius: 999px; color: var(--app-accent-strong); background: var(--app-accent-soft); font-size: 11px; font-weight: 650; }
.profile-logout { min-height: 44px; margin-top: 16px; padding: 0 17px; border: 1px solid #e1e4e9; border-radius: 11px; color: #48515c; background: #fff; font: inherit; font-weight: 600; cursor: pointer; }

@media (max-width: 700px) {
  .workspace-shell { grid-template-columns: minmax(150px, 38vw) minmax(0, 1fr); }
  .sidebar { padding: 20px 10px; }
  .brand-lockup { gap: 8px; padding: 0 4px; font-size: 15px; }
  .brand-mark { width: 34px; height: 34px; flex-basis: 34px; }
  .nav-item { gap: 8px; padding: 0 8px; font-size: 13px; }
  .page-content { padding: 16px; }
  .page-content:has(#page-4:target) { padding: 24px 18px 30px; }
  .page-heading { align-items: center; margin-bottom: 20px; }
  .page-heading h1 { font-size: 27px; }
  .eyebrow { font-size: 11px; }
  .date-line { font-size: 13px; }
}

@media (max-width: 380px) {
  .page-content:has(#page-4:target) { padding-right: 13px; padding-left: 13px; }
}
</style>
