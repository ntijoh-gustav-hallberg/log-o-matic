<template>
    <p>Week: {{ week }}</p>
    <p>Day: {{ day }}</p>
  </template>
  
  <script lang="ts" setup>
  import { useRoute } from 'vue-router';

  const route = useRoute();

  const week = (route.params as any).week;
  const day = route.query.day;
  </script>
  