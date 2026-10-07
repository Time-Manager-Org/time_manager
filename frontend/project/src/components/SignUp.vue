<template>
  <div class="signup-page">
    <header class="signup-hero"></header>

    <main class="signup-card">
      <div class="auth-tabs" aria-label="Account access">
        <router-link to="/login" class="tab">Login</router-link>
        <router-link to="/sign_up" class="tab active" aria-current="page">Sign up</router-link>
      </div>

      <form class="signup-form" @submit.prevent="signUp">
        <div class="form-group">
          <label for="signup-full-name">Full name</label>
          <div class="input-shell">
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <path d="M20 21a8 8 0 0 0-16 0M12 13a5 5 0 1 0 0-10 5 5 0 0 0 0 10Z" />
            </svg>
            <input id="signup-full-name" v-model="full_name" type="text" placeholder="Your full name" autocomplete="name" required />
          </div>
        </div>

        <div class="form-group">
          <label for="signup-username">Username</label>
          <div class="input-shell">
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <circle cx="12" cy="12" r="10" />
              <path d="M16 8v5a2 2 0 0 0 4 0v-1a8 8 0 1 0-3 6" />
              <path d="M16 12a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" />
            </svg>
            <input id="signup-username" v-model="username" type="text" placeholder="your_username" autocomplete="username" required />
          </div>
        </div>

        <div class="form-group">
          <label for="signup-email">Email address</label>
          <div class="input-shell">
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <rect x="3" y="5" width="18" height="14" rx="2" />
              <path d="m4 7 8 6 8-6" />
            </svg>
            <input id="signup-email" v-model="email" type="email" placeholder="you@example.com" autocomplete="email" required />
          </div>
        </div>

        <div class="form-group">
          <label for="signup-password">Password</label>
          <div class="input-shell">
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <rect x="4" y="10" width="16" height="11" rx="2" />
              <path d="M8 10V7a4 4 0 1 1 8 0v3M12 14v3" />
            </svg>
            <input id="signup-password" v-model="password" type="password" placeholder="Create a password" autocomplete="new-password" required />
          </div>
        </div>

        <div v-if="error" class="error-badge" role="alert">{{ error }}</div>
        <button type="submit" class="signup-submit">Create account</button>
      </form>
    </main>

    <p class="signup-footer">Secure time management for modern teams</p>
  </div>
</template>

<script>
import api from '../api';

export default {
  name: 'SignUp',
  data() {
    return {
      username: '',
      full_name: '',
      email: '',
      password: '',
      error: ''
    };
  },
  methods: {
    async signUp() {
      try {
        await api.post('/users/sign_up', {
          user: {
            username: this.username,
            email: this.email,
            full_name: this.full_name,
            password: this.password
          }
        });
        this.$router.push('/login');
      } catch (err) {
        this.error = err.response?.data?.error || 'Registration failed';
      }
    }
  }
};
</script>

<style scoped>
.signup-page {
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

.signup-hero {
  min-height: 390px;
  padding-top: max(48px, env(safe-area-inset-top));
  background: linear-gradient(128deg, #12345a 0%, #124b7c 100%);
}

.signup-card {
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

.signup-form {
  display: grid;
  gap: 23px;
  margin-top: 34px;
}

.form-group {
  display: grid;
  gap: 12px;
}

.form-group label {
  color: #3c3d42;
  font-size: 20px;
  font-weight: 650;
}

.input-shell {
  display: flex;
  min-height: 78px;
  align-items: center;
  gap: 16px;
  padding: 0 22px;
  border: 2px solid #dedee5;
  border-radius: 21px;
  background: #fafafd;
  transition: border-color 150ms ease, box-shadow 150ms ease;
}

.input-shell:focus-within {
  border-color: var(--blue);
  box-shadow: 0 0 0 4px rgb(11 132 255 / 12%);
}

.input-shell svg {
  width: 26px;
  height: 26px;
  flex: 0 0 26px;
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
  font-size: 21px;
}

.input-shell input:focus {
  border: 0;
  outline: 0;
}

.input-shell input::placeholder {
  color: #96979d;
  opacity: 1;
}

.signup-submit {
  min-height: 84px;
  margin: 0;
  border-radius: 23px;
  background: var(--blue);
  box-shadow: 0 14px 30px rgb(11 132 255 / 22%);
  font-size: 22px;
  font-weight: 700;
}

.signup-submit:hover {
  background: #0878e8;
  opacity: 1;
}

.error-badge {
  margin-top: -8px;
  color: #b42318;
  font-size: 15px;
}

.signup-footer {
  margin: 32px 20px max(28px, env(safe-area-inset-bottom));
  color: #94959d;
  font-size: 18px;
  text-align: center;
}

@media (max-width: 480px) {
  .signup-hero {
    min-height: 355px;
    padding-top: max(40px, env(safe-area-inset-top));
  }

  .signup-card {
    width: calc(100% - 28px);
    padding: 24px 22px 28px;
    border-radius: 32px;
  }

  .tab {
    min-height: 60px;
    font-size: 18px;
  }

  .signup-form {
    gap: 19px;
    margin-top: 28px;
  }

  .form-group label {
    font-size: 18px;
  }

  .input-shell {
    min-height: 68px;
    gap: 13px;
    padding: 0 16px;
    border-radius: 18px;
  }

  .input-shell input {
    font-size: 17px;
  }

  .signup-submit {
    min-height: 72px;
    border-radius: 20px;
    font-size: 19px;
  }

  .signup-footer {
    font-size: 15px;
  }
}
</style>
