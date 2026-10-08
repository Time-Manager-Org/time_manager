<template>
  <div class="login-page">
    <AuthBrandPanel />

    <div class="login-content">
      <div class="desktop-top-action">
        <span>New to Time Manager?</span>
        <router-link to="/sign_up">Create account</router-link>
      </div>

      <header class="login-hero"></header>

      <main class="login-card">
        <div class="desktop-heading">
          <h1>Welcome back</h1>
          <p>Enter your details to continue to your workspace.</p>
        </div>

        <div class="auth-tabs" aria-label="Account access">
          <router-link to="/login" class="tab active" aria-current="page">Sign in</router-link>
          <router-link to="/sign_up" class="tab">Sign up</router-link>
        </div>

        <form class="login-form" @submit.prevent="signIn">
          <div class="form-group">
            <label for="login-username">Username</label>
            <div class="input-shell">
              <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M20 21a8 8 0 0 0-16 0M12 13a5 5 0 1 0 0-10 5 5 0 0 0 0 10Z" />
              </svg>
              <input
                id="login-username"
                v-model="username"
                type="text"
                placeholder="your_username"
                autocomplete="username"
                required
              />
            </div>
          </div>

          <div class="form-group">
            <label for="login-password">Password</label>
            <div class="input-shell">
              <svg viewBox="0 0 24 24" aria-hidden="true">
                <rect x="4" y="10" width="16" height="11" rx="2" />
                <path d="M8 10V7a4 4 0 1 1 8 0v3" />
                <path d="M12 14v3" />
              </svg>
              <input
                id="login-password"
                v-model="password"
                type="password"
                placeholder="Enter your password"
                autocomplete="current-password"
                required
              />
            </div>
          </div>

          <div v-if="error" class="error-badge" role="alert">{{ error }}</div>
          <button type="submit" class="login-submit">Sign in to Time Manager</button>
        </form>
      </main>

      <p class="login-footer">Secure time management for modern teams</p>
    </div>
  </div>
</template>

<script>
import api from '../api';
import AuthBrandPanel from './AuthBrandPanel.vue';

export default {
  name: 'SignIn',
  components: { AuthBrandPanel },
  data() {
    return {
      username: '',
      password: '',
      error: ''
    };
  },
  methods: {
    async signIn() {
      try {
        const response = await api.post('/users/sign_in', {
          username: this.username,
          password: this.password
        });

        const data = response.data.data || response.data;
        const token = data.xsrf_token || data.xsrfToken || data.token;
        const userId = data.user_id || data.userId || data.user?.id;

        if (token) {
          localStorage.setItem('xsrfToken', token);
          localStorage.setItem('userId', userId);
          localStorage.removeItem('role');
          this.$router.push('/');
        } else {
          this.error = 'Token missing in response';
        }
      } catch (err) {
        this.error = err.response?.data?.error || 'Invalid credentials';
      }
    }
  }
};
</script>

<style scoped>
.login-page {
  --accent: #173f65;
  position: fixed;
  z-index: 20;
  inset: 0;
  height: 100vh;
  height: 100dvh;
  overflow: hidden;
  background: var(--app-background);
  color: var(--app-text);
  font-family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.login-content {
  display: contents;
}

.login-hero {
  position: relative;
  box-sizing: border-box;
  min-height: 0;
  height: 31vh;
  padding: max(24px, env(safe-area-inset-top)) 42px 30px;
  overflow: hidden;
  color: var(--app-text);
  background: linear-gradient(128deg, #f6faf7 0%, #eaf3ed 100%);
}

.desktop-top-action,
.desktop-heading {
  display: none;
}

.login-card {
  position: relative;
  width: min(528px, calc(100% - 48px));
  margin: -40px auto 0;
  padding: 36px;
  border-radius: 40px;
  border: 1px solid #e3ebe5;
  background: var(--app-surface);
  box-shadow: 0 18px 55px rgb(39 74 52 / 10%);
}

.auth-tabs {
  display: flex;
  gap: 6px;
  padding: 6px;
  border-radius: 21px;
  background: #f0f4f1;
}

.tab {
  display: grid;
  min-height: 70px;
  flex: 1;
  place-items: center;
  border-radius: 17px;
  color: #77847b;
  font-size: 22px;
  font-weight: 650;
  text-decoration: none;
}

.tab.active {
  background: #fff;
  box-shadow: 0 3px 14px rgb(39 74 52 / 9%);
  color: var(--accent);
}

.login-form {
  display: grid;
  gap: 28px;
  margin-top: 38px;
}

.form-group {
  display: grid;
  gap: 14px;
}

.form-group label {
  color: #303a33;
  font-size: 22px;
  font-weight: 650;
}

.input-shell {
  display: flex;
  min-height: 92px;
  align-items: center;
  gap: 18px;
  padding: 0 24px;
  border: 1px solid #dce5de;
  border-radius: 23px;
  background: #fafcfb;
  transition: border-color 150ms ease, box-shadow 150ms ease;
}

.input-shell:focus-within {
  border-color: var(--accent);
  box-shadow: 0 0 0 4px rgb(23 63 101 / 12%);
}

.input-shell svg {
  width: 28px;
  height: 28px;
  flex: 0 0 28px;
  fill: none;
  stroke: #89958d;
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-width: 2;
}

.input-shell input {
  width: 100%;
  min-width: 0;
  margin: 0;
  padding: 0;
  border: 0;
  outline: 0;
  background: transparent;
  box-shadow: none;
  color: #263129;
  font: inherit;
  font-size: 24px;
}

.input-shell input:focus {
  border: 0;
  outline: 0;
}

.input-shell input::placeholder {
  color: #89958d;
  opacity: 1;
}

.login-submit {
  min-height: 92px;
  margin: 0;
  border: 0;
  border-radius: 24px;
  background: linear-gradient(100deg, #173f65, #285b86);
  box-shadow: 0 14px 30px rgb(23 63 101 / 18%);
  color: #fff;
  font-size: 24px;
  font-weight: 700;
}

.login-submit:hover {
  background: linear-gradient(100deg, #123553, #214b70);
  opacity: 1;
}

.error-badge {
  margin-top: -12px;
  color: #b8443f;
  font-size: 15px;
}

.login-footer {
  margin: 34px 20px max(28px, env(safe-area-inset-bottom));
  color: #78857c;
  font-size: 18px;
  text-align: center;
}

@media (max-width: 480px) {
  .login-hero {
    height: 22vh;
    min-height: 118px;
    max-height: 160px;
    padding-right: 26px;
    padding-left: 26px;
  }

  .login-card {
    width: calc(100% - 28px);
    margin-top: -28px;
    padding: 18px 18px 20px;
    border-radius: 32px;
  }

  .tab {
    min-height: 48px;
    font-size: 18px;
  }

  .login-form {
    gap: 16px;
    margin-top: 18px;
  }

  .form-group label {
    font-size: 16px;
  }

  .input-shell {
    min-height: 56px;
    gap: 11px;
    padding: 0 14px;
    border-radius: 16px;
  }

  .input-shell input {
    font-size: 16px;
  }

  .login-submit {
    min-height: 58px;
    border-radius: 17px;
    font-size: 17px;
  }

  .login-footer {
    margin-top: 14px;
    font-size: 13px;
  }
}

@media (min-width: 960px) {
  .login-page {
    display: grid;
    grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
    overflow: hidden;
    background: var(--app-background);
  }

  .login-content {
    grid-column: 2;
    grid-row: 1;
    position: relative;
    display: flex;
    height: 100vh;
    height: 100dvh;
    min-height: 0;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    padding: 100px clamp(24px, 2.4vw, 44px) 32px;
  }

  .desktop-top-action {
    position: absolute;
    top: 42px;
    right: clamp(24px, 2.4vw, 44px);
    display: flex;
    align-items: center;
    gap: 16px;
    color: #738078;
    font-size: 17px;
  }

  .desktop-top-action a {
    padding: 12px 20px;
    border: 1px solid var(--accent);
    border-radius: 13px;
    color: #fff;
    background: var(--accent);
    font-weight: 650;
    text-decoration: none;
    transition: background-color 150ms ease, border-color 150ms ease;
  }

  .desktop-top-action a:hover {
    border-color: #102f4b;
    background: #102f4b;
  }

  .desktop-heading {
    display: block;
    width: 100%;
    margin-bottom: 30px;
  }

  .desktop-heading h1 {
    margin: 0 0 18px;
    color: #202923;
    font-size: clamp(38px, 4vw, 58px);
    letter-spacing: -1.7px;
  }

  .desktop-heading p {
    margin: 0;
    color: #768279;
    font-size: 21px;
    line-height: 1.55;
  }

  .login-hero,
  .auth-tabs,
  .login-footer {
    display: none;
  }

  .login-card {
    box-sizing: border-box;
    width: min(100%, 520px);
    margin: 0;
    padding: clamp(30px, 3.5vw, 52px);
    border: 1px solid #e3ebe5;
    border-radius: 28px;
    background: var(--app-surface);
    box-shadow: 0 24px 70px rgb(39 74 52 / 10%), 0 0 45px rgb(33 135 90 / 7%);
  }

  .login-form {
    gap: 24px;
    margin-top: 0;
  }

  .form-group {
    gap: 12px;
  }

  .form-group label {
    font-size: 18px;
  }

  .input-shell {
    min-height: 74px;
    border-radius: 17px;
  }

  .input-shell input {
    font-size: 20px;
  }

  .login-submit {
    min-height: 80px;
    border-radius: 18px;
    font-size: 21px;
  }
}

@media (min-width: 960px) and (max-height: 850px) {
  .login-content {
    padding-top: 78px;
    padding-bottom: 18px;
  }

  .login-card {
    padding: 24px;
  }

  .desktop-heading {
    margin-bottom: 18px;
  }

  .desktop-heading h1 {
    margin-bottom: 10px;
    font-size: clamp(34px, 3.4vw, 46px);
  }

  .desktop-heading p {
    font-size: 17px;
  }

  .login-form {
    gap: 15px;
  }

  .form-group {
    gap: 7px;
  }

  .input-shell {
    min-height: 58px;
  }

  .login-submit {
    min-height: 62px;
  }
}

@media (min-width: 960px) and (max-height: 650px) {
  .login-content {
    padding: 58px 30px 12px;
  }

  .login-card {
    padding: 16px 20px;
  }

  .desktop-heading h1 {
    font-size: 32px;
  }

  .desktop-heading p {
    font-size: 15px;
  }

  .form-group label {
    font-size: 15px;
  }

  .input-shell {
    min-height: 48px;
  }

  .login-submit {
    min-height: 52px;
    font-size: 17px;
  }
}

@media (max-height: 620px) and (max-width: 480px) {
  .login-hero {
    height: 18vh;
    min-height: 88px;
  }

  .login-card {
    padding-top: 14px;
    padding-bottom: 14px;
  }

  .login-form {
    gap: 10px;
    margin-top: 12px;
  }

  .input-shell {
    min-height: 48px;
  }

  .login-footer {
    margin-top: 8px;
  }
}
</style>
