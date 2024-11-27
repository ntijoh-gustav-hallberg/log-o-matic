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
          <template v-slot:headers="{ columns, isSorted, getSortIcon, toggleSort }">
      <tr>
        <template v-for="column in columns" :key="column.key">
          <th v-if="column.key === 'name'">
            <span class="mr-2 cursor-pointer" @click="() => toggleSort(column)">{{ column.title }}</span>
            <template v-if="isSorted(column)">
              <v-icon :icon="getSortIcon(column)"></v-icon>
            </template>
          </th>
          <th v-else="">
            <span class="mr-2 cursor-pointer" @click="handleCellClick(column.key!)">{{ column.title }}</span>
            <template v-if="isSorted(column)">
              <v-icon :icon="getSortIcon(column)"></v-icon>
            </template>
          </th>

        </template>
      </tr>
    </template>
  
          <template v-slot:body="{ items }">

            <tr v-for="student in items" :key="student.name" >
                
              <td v-if="student.teacher === whatTeacherAreYou"><v-btn @click="studentView(student.id)">{{ student.name }}</v-btn></td>
              <td v-if="student.teacher === whatTeacherAreYou" v-for="(status, index) in student.status" :key="index">
                <v-btn
                  v-if="status === 'missing'"
                  @click="seperateStudentView(student.id, headers[index+1].key)"
                  icon
                >
                  <v-icon color="orange">mdi-alert-circle</v-icon>
                </v-btn>
                <v-btn
                  v-else-if="status === 'unread'"
                  @click="seperateStudentView(student.id, headers[index+1].key)"
                  icon
                >
                <v-badge
                  
                  color="grey"
                  :content="student.comments[index]"
                  overlap
                >
                  <v-icon color="grey">mdi-check</v-icon>
                </v-badge>
            </v-btn>
            <v-btn
                  v-else-if="status === 'read'"
                  @click="seperateStudentView(student.id, headers[index+1].key)"
                  icon
                >
                <v-badge
                  
                  color="blue"
                  :content="student.comments[index]"
                  overlap
                >
                  <v-icon color="blue">mdi-check</v-icon>
                </v-badge>
                </v-btn>
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

        <template v-slot:headers="{ columns, isSorted, getSortIcon, toggleSort }">
      <tr>
        <template v-for="column in columns" :key="column.key">
          <th v-if="column.key === 'name'">
            <span class="mr-2 cursor-pointer" @click="() => toggleSort(column)">{{ column.title }}</span>
            <template v-if="isSorted(column)">
              <v-icon :icon="getSortIcon(column)"></v-icon>
            </template>
          </th>
          <th v-else="">
            <span class="mr-2 cursor-pointer" @click="handleCellClick(column.key!)">{{ column.title }}</span>
            <template v-if="isSorted(column)">
              <v-icon :icon="getSortIcon(column)"></v-icon>
            </template>
          </th>

        </template>
      </tr>
    </template>

          <template v-slot:body="{ items }">
            <tr v-for="student in items" :key="student.name">
              <td v-if="student.teacher !== whatTeacherAreYou">
                <v-btn @click="studentView(student.id)">
                  {{ student.name }}
                </v-btn>
              </td>
              <td
                v-if="student.teacher !== whatTeacherAreYou"
                v-for="(status, index) in student.status"
                :key="index"
              >
                <v-btn
                  v-if="status === 'missing'"
                  @click="seperateStudentView(student.id, headers[index+1].key)"
                  icon
                >
                  <v-icon color="orange">mdi-alert-circle</v-icon>
            </v-btn>
                <v-btn
                  v-else-if="status === 'unread'"
                  @click="seperateStudentView(student.id, headers[index+1].key)"
                  icon
                >
                <v-badge
                  
                  color="grey"
                  :content="student.comments[index]"
                  overlap
                >
                  <v-icon color="grey">mdi-check</v-icon>
                </v-badge>
            </v-btn>
            <v-btn
                  v-else-if="status === 'read'"
                  @click="seperateStudentView(student.id, headers[index+1].key)"
                  icon
                >
                <v-badge
                  
                  color="blue"
                  :content="student.comments[index]"
                  overlap
                >
                  <v-icon color="blue">mdi-check</v-icon>
                </v-badge>
                </v-btn>
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
import router from "@/router";

const route = useRoute();
const week = route.query.week
console.log(week)

const whatTeacherAreYou = 'bert'

type Header = {
  title: string;
  key: string;
};

const headers: Header[] = [
  { title: "Name", key: "name" },
  { title: "Måndag", key: "monday" },
  { title: "Tisdag", key: "tuesday" },
  { title: "Onsdag", key: "wednesday" },
  { title: "Torsdag", key: "thursday" },
  { title: "Fredag", key: "friday" },
];

// Students data
const students = [
  {
    id: 1,
    name: "Lynwood Satterfield",
    teacher: 'bert',
    status: ["read", "unread", "read", "read", "unread"],
    comments: [5, 2, 3, 0, 1]
  },
  {
    id: 2,
    name: "Andrew Robel",
    teacher: 'bert',
    status: ["missing", "read", "missing", "read", "read"],
    comments: [5, 2, 3, 0, 1]
  },
  {
    id: 3,
    name: "Magdalena Gibson",
    teacher: 'bert',
    status: ["read", "read", "read", "read", "read"],
    comments: [5, 2, 3, 0, 1]
  },
  {
    id: 4,
    name: "Neil Doyle",
    teacher: 'bert',
    status: ["unread", "missing", "read", "read", "read"],
    comments: [5, 2, 3, 0, 1]
  },
  {
    id: 5,
    name: "Trinidad Reynolds",
    teacher: 'bert',
    status: ["unread", "unread", "read", "missing", "read"],
    comments: [5, 2, 3, 0, 1]
  },{
    id: 6,
    name: "asd qwe",
    teacher: 'qwert',
    status: ["unread", "unread", "read", "missing", "read"],
    comments: [5, 2, 3, 0, 1]
  },{
    id: 7,
    name: "dfhfrj 12313",
    teacher: 'qwert',
    status: ["unread", "unread", "read", "missing", "read"],
    comments: [1,2,3,4,5]
  },
];

function studentView(id: number){
//     router.push({
//     path: `/logs/student/${id}`,
//     query: {
//       week: week
//     },
//   });
    router.push({
        path: `/logs/weekly`,
        query: {
            week: week,
            studentId: id
        }

    })
}

function seperateStudentView(id: number, day: string){
    router.push({
        path: `/logs/student`,
        query: {
            week: week,
            studentId: id,
            day: day
        }

    })
}

function handleCellClick(dag: string) {
    router.push({
        path: `/logs/daily`,
        query: {
            day: dag,
            week: week
        }
    })
  console.log(`Clicked on: ${dag}`);
}
</script>