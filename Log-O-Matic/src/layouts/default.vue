<template>
  <v-app>
    <v-app-bar :elevation="12" rounded>

    <v-app-bar-title @click="StartMenu()">Log-O-Matic</v-app-bar-title>

    <template v-slot:append>
      <v-btn v-if="!token" @click="LoginMenu()">
        <v-icon  icon="mdi-lock"/>
        logga in
      </v-btn>
      <v-btn v-if="token">
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

  const token = "";


  function StartMenu(){
    router.push('/')
  }

  function LoginMenu(){
    router.push('/loginPage')
  }
</script>
