<template>
  <div class="login-page">
    <header class="login-hero">
    </header>

    <main class="login-card">
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
        <button type="submit" class="login-submit">Sign in</button>
      </form>
    </main>

    <p class="login-footer">Secure time management for modern teams</p>
  </div>
</template>

<script>
import api from '../api';

export default {
  name: 'SignIn',
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
  --blue: #0b84ff;
  position: fixed;
  z-index: 20;
  inset: 0;
  overflow-y: auto;
  min-height: 100vh;
  min-height: 100dvh;
  background: #f0f0f6;
  color: #33343a;
  font-family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.login-hero {
  position: relative;
  min-height: 390px;
  padding: max(48px, env(safe-area-inset-top)) 42px 112px;
  overflow: hidden;
  color: #fff;
  background: linear-gradient(128deg, #12345a 0%, #124b7c 100%);
}

.login-card {
  position: relative;
  width: min(528px, calc(100% - 48px));
  margin: -40px auto 0;
  padding: 36px;
  border-radius: 40px;
  background: #fff;
  box-shadow: 0 18px 55px rgb(24 42 75 / 9%);
}

.auth-tabs {
  display: flex;
  gap: 6px;
  padding: 6px;
  border-radius: 21px;
  background: #f1f1f6;
}

.tab {
  display: grid;
  min-height: 70px;
  flex: 1;
  place-items: center;
  border-radius: 17px;
  color: #888990;
  font-size: 22px;
  font-weight: 650;
  text-decoration: none;
}

.tab.active {
  background: #fff;
  box-shadow: 0 3px 14px rgb(27 37 62 / 9%);
  color: #24252a;
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
  color: #3c3d42;
  font-size: 22px;
  font-weight: 650;
}

.input-shell {
  display: flex;
  min-height: 92px;
  align-items: center;
  gap: 18px;
  padding: 0 24px;
  border: 2px solid #dedee5;
  border-radius: 23px;
  background: #fafafd;
  transition: border-color 150ms ease, box-shadow 150ms ease;
}

.input-shell:focus-within {
  border-color: var(--blue);
  box-shadow: 0 0 0 4px rgb(11 132 255 / 12%);
}

.input-shell svg {
  width: 28px;
  height: 28px;
  flex: 0 0 28px;
  fill: none;
  stroke: #92949b;
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
  color: #303139;
  font: inherit;
  font-size: 24px;
}

.input-shell input:focus {
  border: 0;
  outline: 0;
}

.input-shell input::placeholder {
  color: #96979d;
  opacity: 1;
}

.login-submit {
  min-height: 92px;
  margin: 0;
  border-radius: 24px;
  background: var(--blue);
  box-shadow: 0 14px 30px rgb(11 132 255 / 22%);
  font-size: 24px;
  font-weight: 700;
}

.login-submit:hover {
  background: #0878e8;
  opacity: 1;
}

.error-badge {
  margin-top: -12px;
  color: #b42318;
  font-size: 15px;
}

.login-footer {
  margin: 34px 20px max(28px, env(safe-area-inset-bottom));
  color: #94959d;
  font-size: 18px;
  text-align: center;
}

@media (max-width: 480px) {
  .login-hero {
    min-height: 355px;
    padding-right: 26px;
    padding-left: 26px;
  }

  .login-card {
    width: calc(100% - 28px);
    padding: 24px 22px 28px;
    border-radius: 32px;
  }

  .tab {
    min-height: 60px;
    font-size: 18px;
  }

  .login-form {
    gap: 24px;
    margin-top: 30px;
  }

  .form-group label {
    font-size: 19px;
  }

  .input-shell {
    min-height: 72px;
    gap: 13px;
    padding: 0 17px;
    border-radius: 19px;
  }

  .input-shell input {
    font-size: 18px;
  }

  .login-submit {
    min-height: 74px;
    border-radius: 20px;
    font-size: 20px;
  }

  .login-footer {
    font-size: 15px;
  }
}
</style>
