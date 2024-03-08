import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import './assets/text/text.css'
import { createPinia } from 'pinia'
import {router} from './router.js'
import { VueQueryPlugin } from '@tanstack/vue-query';
const app = createApp(App);
const pinia = createPinia();

app.use(router)
app.use(pinia)
app.use(VueQueryPlugin)
app.mount('#app')
