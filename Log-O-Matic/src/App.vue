<template>
  <v-app>
    <v-main>
      <router-view />
    </v-main>
  </v-app>
</template>

<script lang="ts" setup>
  import {useStudentStore} from "./stores/studentStore";
  const studentStore = useStudentStore();

  studentStore.ensureStudentsLoaded()
</script>
