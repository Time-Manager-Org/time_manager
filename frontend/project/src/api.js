// src/api.js
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:4000/api',
  headers: {
    'Content-Type': 'application/json'
  }
});

api.interceptors.request.use((config) => {
  // Skip attaching token for unauthenticated auth routes
  const publicEndpoints = ['/users/sign_in', '/users/sign_up'];
  const isPublicRoute = publicEndpoints.some(path => config.url.endsWith(path));

  const token = sessionStorage.getItem('xsrfToken');

  if (!isPublicRoute && token && token !== 'undefined' && token !== 'null') {
    config.headers['x-xsrf-token'] = token;
  } else {
    delete config.headers['x-xsrf-token'];
  }

  return config;
}, (error) => {
  return Promise.reject(error);
});

export default api;
