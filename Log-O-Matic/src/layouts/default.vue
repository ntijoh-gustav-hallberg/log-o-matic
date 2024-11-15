<template>
  <v-app>
    <v-app-bar :elevation="12" rounded>

    <v-app-bar-title @click="StartMenu()">Log-O-Matic</v-app-bar-title>

    <template v-slot:append>
      <v-btn v-if="userStore.token && userStore.teacher">
        <v-icon  icon="mdi-cog"/>
        Admin
      </v-btn>
      <v-btn v-if="userStore.token">
        <v-icon  icon="mdi-list-box"/>
        Log
      </v-btn>
      <v-btn v-if="!userStore.token" @click="LoginMenu()">
        <v-icon  icon="mdi-lock"/>
        logga in
      </v-btn>
      <v-btn v-if="userStore.token">
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
import useUserStore from '@/stores/userStore';

  const userStore = useUserStore();

  function StartMenu(){
    router.push('/')
  }
  function LoginMenu(){
    router.push('/loginPage')
  }
</script>