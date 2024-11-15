<template>
    <p>{{ week }}</p>
    </template>
    
    <script lang="ts" setup>
    import { useRoute } from 'vue-router';
    const route = useRoute();
    
    const week = route.query.week;
    console.log(week)
    </script>