<template>
    <v-container>
      <p>Week: {{ week }}</p>
      <v-card>
        <v-card-title class="text-h6">Your Students</v-card-title>
        <v-card-text>
          <v-data-table
            :headers="headers"
            :items="students"
            item-value="name"
            class="elevation-1"
          >
  
            <!-- Customize Rows -->
            <template v-slot:body="{ items }">
              <tr v-for="student in items" :key="student.name">
                <td>{{ student.name }}</td>
                <td v-for="(status, index) in student.status" :key="index">
                  <v-icon v-if="status === 'missing'" color="orange">mdi-alert-circle</v-icon>
                  <v-icon v-else-if="status === 'unread'" color="grey">mdi-check</v-icon>
                  <v-icon v-else-if="status === 'read'" color="blue">mdi-check</v-icon>
                  <v-icon v-else>mdi-check-circle</v-icon>
                </td>
              </tr>
            </template>
          </v-data-table>
        </v-card-text>
      </v-card>
    </v-container>


    <v-app>
    <v-btn @click="incrementNotifications">
      <v-badge
        color="red"
        :content="notificationCount"
        overlap
      >
        Notifications
      </v-btn>
    </v-btn>
  </v-app>

  </template>
  
  <script lang="ts" setup>
  import { Ref } from "vue";


      const notificationCount = ref()


    function incrementNotifications() {
      notificationCount++;
    }

  import { useRoute } from "vue-router";
  
  const route = useRoute();
  const week = route.query.week || "Not Specified";

  const headers = [
  { title: "Name", key: 'name' },
  { title: "Måndag", key: 'monday' },
  { title: "Tisdag", key: 'tuesday' },
  { title: "Onsdag", key: 'wednesday' },
  { title: "Torsdag", key: 'thursday' },
  { title: "Fredag", key: 'friday' },
];
  
  // Days of the week for the header
  const weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  
  // Students data
  const students = [
    {
      name: "Lynwood Satterfield",
      status: ["read", "unread", "read", "read", "unread"],
    },
    {
      name: "Andrew Robel",
      status: ["missing", "read", "missing", "read", "read"],
    },
    {
      name: "Magdalena Gibson",
      status: ["read", "read", "read", "read", "read"],
    },
    {
      name: "Neil Doyle",
      status: ["unread", "missing", "read", "read", "read"],
    },
    {
      name: "Trinidad Reynolds",
      status: ["unread", "unread", "read", "missing", "read"],
    },
  ];
  </script>
  
  <style scoped>
  </style>
  