<template>
  <v-app>
    <v-main>
      <router-view />
    </v-main>
  </v-app>
</template>

<script lang="ts" setup>
  import {useStudentStore} from "./stores/studentStore";
  import {useTeacherStore} from "./stores/teacherStore";
  const studentStore = useStudentStore();
  const teacherStore = useTeacherStore();

  studentStore.ensureStudentsLoaded()
  teacherStore.ensureTeachersLoaded()
</script>
