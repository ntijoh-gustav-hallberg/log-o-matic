<template>
  <v-app>
    <v-app-bar :elevation="12" rounded>

    <v-app-bar-title @click="StartMenu()">Log-O-Matic</v-app-bar-title>

    <template v-slot:append>
      <v-btn v-if="userStore.token && userStore.teacher" @click="router.push('/admin')">
        <v-icon  icon="mdi-cog"/>
        Admin
      </v-btn>
      <v-btn v-if="userStore.token" @click="goToLogs">
        <v-icon  icon="mdi-list-box"/>
        Logs
      </v-btn>
      <v-btn v-if="!userStore.token" @click="LoginMenu()">
        <v-icon  icon="mdi-lock"/>
        logga in
      </v-btn>
      <v-btn v-if="userStore.token" @click="Logout()">
        <v-icon  icon="mdi-lock-open"/>
        logga ut
      </v-btn>
      </template>
    </v-app-bar>
<br>
    <v-main>
      <router-view />
    </v-main>


    <AppFooter />
  </v-app>
</template>

<script lang="ts" setup>
import router from '@/router';
import { getISOWeek } from 'date-fns';
import useUserStore from '@/stores/userStore';

const today = new Date();
const weekNumber = getISOWeek(today);

function goToLogs(){
  router.push({
    path: '/logs',
    query: {
      week: weekNumber,
    },
  });
};

  const userStore = useUserStore();

  function StartMenu(){
    router.push('/')
  }
  function LoginMenu(){
    router.push('/loginPage')
  }
  function Logout(){
    userStore.token = '';
    userStore.teacher = false;
    router.push('/')
  }
</script>
