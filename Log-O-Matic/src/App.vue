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
  import {useQuestionStore} from "./stores/questionStore.ts"

  const questionStore = useQuestionStore();
  const studentStore = useStudentStore();
  const teacherStore = useTeacherStore();

  questionStore.ensureQuestionsLoaded();
  studentStore.ensureStudentsLoaded();
  teacherStore.ensureTeachersLoaded();
</script>
