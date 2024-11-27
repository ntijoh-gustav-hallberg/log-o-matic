<template> 
    <p>{{ student }}</p>
    <p> {{ week }}</p>
</template>
<script lant="ts" setup>
import { useRoute } from 'vue-router';

const route = useRoute();
const student = route.query.studentId;
const week = route.query.week;  
</script>