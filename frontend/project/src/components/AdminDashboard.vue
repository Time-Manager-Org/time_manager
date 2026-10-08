<template>
  <div class="workspace-shell">
    <aside class="sidebar">
      <div class="brand-lockup">
        <span class="brand-mark" aria-hidden="true">
          <svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="8.25"/><path d="M12 7v5l3.4 2"/></svg>
        </span>
        <span>Admin Dashboard</span>
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
      <section id="page-4" class="page-placeholder">Page 4</section>
    </main>
  </div>
</template>

<script>
import api from '../api'

export default {
  name: 'AdminDashboard',
  methods: {
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

@media (max-width: 700px) {
  .workspace-shell { grid-template-columns: minmax(150px, 38vw) minmax(0, 1fr); }
  .sidebar { padding: 20px 10px; }
  .brand-lockup { gap: 8px; padding: 0 4px; font-size: 15px; }
  .brand-mark { width: 34px; height: 34px; flex-basis: 34px; }
  .nav-item { gap: 8px; padding: 0 8px; font-size: 13px; }
  .page-content { padding: 16px; }
}
</style>
