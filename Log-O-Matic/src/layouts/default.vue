<template>
  <v-app>
    <v-btn @click="goToLogs">logs</v-btn>
    <v-main>
      <router-view />
    </v-main>

    <AppFooter />
  </v-app>
</template>

<script lang="ts" setup>
import router from '@/router';
import { getISOWeek } from 'date-fns';

const today = new Date();
const weekNumber = getISOWeek(today);

console.log(`Today is in week: ${weekNumber}`);

const goToLogs = () => {
  router.push({
    path: '/logs',
    query: {
      week: weekNumber,
    },
  });
};

</script>
