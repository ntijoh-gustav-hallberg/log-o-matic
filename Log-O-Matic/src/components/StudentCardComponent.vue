<template>
    <v-container>
      <v-card>
        <v-card-title class="text-h6">Your Students</v-card-title>
        <v-card-text>
          <v-data-table
            :headers="headers"
            :items="students"
            item-value="name"
            class="elevation-1"
          >
  
          <template v-slot:body="{ items }">
            <tr v-for="student in items" :key="student.name">
              <td>{{ student.name }}</td>
              <td v-for="(status, index) in student.status" :key="index">
                  <v-icon v-if="status === 'missing'" color="orange">mdi-alert-circle</v-icon>
                <v-badge
                  v-else-if="status === 'unread'"
                  color="grey"
                  :content="student.comments[index]"
                  overlap
                >
                  <v-icon color="grey">mdi-check</v-icon>
                </v-badge>
                <v-badge
                  v-else-if="status === 'read'"
                  color="blue"
                  :content="student.comments[index]"
                  overlap
                >
                  <v-icon color="blue">mdi-check</v-icon>
                </v-badge>
                <v-badge
                  v-else
                  color="green"
                  :content="student.comments[index]"
                  overlap
                >
                  <v-icon>mdi-check-circle</v-icon>
                </v-badge>
              </td>
            </tr>
          </template>
          </v-data-table>
        </v-card-text>
      </v-card>
      <br>
      <hr>
      <br>
      <v-card>
        <v-card-title class="text-h6">All Other Students</v-card-title>
        <v-card-text>
          <v-data-table
            :headers="headers"
            :items="students"
            item-value="name"
            class="elevation-1"
          >
  
          <template v-slot:body="{ items }">
            <tr v-for="student in items" :key="student.name">
              <td>{{ student.name }}</td>
              <td v-for="(status, index) in student.status" :key="index">
                  <v-icon v-if="status === 'missing'" color="orange">mdi-alert-circle</v-icon>
                <v-badge
                  v-else-if="status === 'unread'"
                  color="grey"
                  :content="student.comments[index]"
                  overlap
                >
                  <v-icon color="grey">mdi-check</v-icon>
                </v-badge>
                <v-badge
                  v-else-if="status === 'read'"
                  color="blue"
                  :content="student.comments[index]"
                  overlap
                >
                  <v-icon color="blue">mdi-check</v-icon>
                </v-badge>
                <v-badge
                  v-else
                  color="green"
                  :content="student.comments[index]"
                  overlap
                >
                  <v-icon>mdi-check-circle</v-icon>
                </v-badge>
              </td>
            </tr>
          </template>
          </v-data-table>
        </v-card-text>
      </v-card>
    </v-container>

    
</template>

<script lang="ts" setup>
import { useRoute } from "vue-router";

const route = useRoute();
const week = route.query.week
console.log(week)

const headers = [
{ title: "Name", key: 'name' },
{ title: "Måndag", key: 'monday' },
{ title: "Tisdag", key: 'tuesday' },
{ title: "Onsdag", key: 'wednesday' },
{ title: "Torsdag", key: 'thursday' },
{ title: "Fredag", key: 'friday' },
];

// Students data
const students = [
  {
    name: "Lynwood Satterfield",
    teacher: 'bert',
    status: ["read", "unread", "read", "read", "unread"],
    comments: [5, 2, 3, 0, 1]
  },
  {
    name: "Andrew Robel",
    teacher: 'bert',
    status: ["missing", "read", "missing", "read", "read"],
    comments: [5, 2, 3, 0, 1]
  },
  {
    name: "Magdalena Gibson",
    teacher: 'bert',
    status: ["read", "read", "read", "read", "read"],
    comments: [5, 2, 3, 0, 1]
  },
  {
    name: "Neil Doyle",
    teacher: 'bert',
    status: ["unread", "missing", "read", "read", "read"],
    comments: [5, 2, 3, 0, 1]
  },
  {
    name: "Trinidad Reynolds",
    teacher: 'bert',
    status: ["unread", "unread", "read", "missing", "read"],
    comments: [5, 2, 3, 0, 1]
  },{
    name: "asd qwe",
    teacher: 'qwert',
    status: ["unread", "unread", "read", "missing", "read"],
    comments: [5, 2, 3, 0, 1]
  },{
    name: "dfhfrj 12313",
    teacher: 'qwert',
    status: ["unread", "unread", "read", "missing", "read"],
    comments: [5, 2, 3, 0, 1]
  },
];
</script>