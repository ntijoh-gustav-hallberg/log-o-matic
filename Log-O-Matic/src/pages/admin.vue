<script>
import {useTeacherStore} from "../stores/teacherStore.ts"
import {useStudentStore} from "../stores/studentStore.ts"

const teacherStore = useTeacherStore();
const studentStore = useStudentStore();

// For tables
    export default {
        data () {
            return {
                teacherHeaders: [
                    { title: 'email', align: 'start', key: 'email' },
                    { title: 'name', align: 'start', key: 'name' },
                    { title: '', align: 'end', key: 'password' },

                ],
                teachers: teacherStore.getAll,
                teacherEmail: "",
                teacherName: "",
                teacherPassword: "",

                studentHeaders: [
                    { title: 'email', align: 'start', key: 'email' },
                    { title: 'name', align: 'start', key: 'name' },
                    { title: 'teacher', align: 'start', key: 'teacher' },
                    { title: '', align: 'end', key: 'password' },

                ],
                students: studentStore.getAll,
                studentTeacher: "",
                studentEmail: "",
                studentName: "",
                studentPassword: "",
            }
        },
  
        computed: {
            virtualTeachers () {
                return [...Array(this.teachers.length).keys()].map(i => {
                    const teacher = { ...this.teachers[i % this.teachers.length] }
                    return teacher
                })
            },

            virtualStudents () {
                return [...Array(this.students.length).keys()].map(i => {
                    const student = { ...this.students[i % this.students.length] }
                    student.teacher = student.teacher || '';
                    return student
                })
            },
        },
        methods: {
            addStudent() {
                const student = {
                    email: this.studentEmail,
                    name: this.studentName,
                    teacherId: teacherStore.getTeacherIdByName(this.studentTeacher),
                    teacher: this.studentTeacher,
                    password: this.studentPassword
                }

                studentStore.addStudent(student);
            },

            addTeacher() {
                const teacher = {
                    email: this.teacherEmail,
                    name: this.teacherName,
                    password: this.teacherPassword
                }

                teacherStore.addTeacher(teacher);
            },

            resetPassword(data, isTeacher) {
                if(isTeacher) {
                    teacherStore.resetPassword(data.email, data.password)
                } else {
                    studentStore.resetPassword(data.email, data.password)
                }
            },

            updateTeacher(item) {
                console.log(item);
                item.teacherId = teacherStore.getTeacherIdByName(item.teacher);
                studentStore.updateStudentTeacher(item);
            }
        },

        setup() {
            const teachersList = computed(() =>
                teacherStore.teachers.map(teacher => teacher.name));
            
            return {
                teachersList
            };

        },
    }
</script>

<template>
    <v-card title="Teachers" class="ma-5">
        <v-data-table-virtual
            :headers="teacherHeaders"
            :items="virtualTeachers"
            item-value="name"
        >
        <template #item.password="{ item }">
            <div class="d-flex align-center">
                <!-- Input Field -->
                <v-text-field
                label="Password"
                variant="underlined"
                hide-details
                v-model="item.password"
                type="password"
                dense
                ></v-text-field>

                <!-- Button -->
                <v-btn color="blue" rounded="2" @click="resetPassword(item, true)">
                Reset
                </v-btn>
            </div>
        </template>
        </v-data-table-virtual>

        <v-card-subtitle class="my-4">Add New Teacher</v-card-subtitle>
        <v-form v-model="valid">
            <v-container>
            <v-row>
                <v-col
                cols="12"
                md="4"
                >
                <v-text-field
                    v-model="teacherEmail"
                    label="Email"
                    variant="underlined"
                    required
                ></v-text-field>
                </v-col>

                <v-col
                cols="12"
                md="4"
                >
                <v-text-field
                    v-model="teacherName"
                    label="Name"
                    variant="underlined"
                    required
                ></v-text-field>
                </v-col>

                <v-col
                cols="12"
                md="4"
                >
                <v-text-field
                    v-model="teacherPassword"
                    label="Password"
                    variant="underlined"
                    required
                    type="password"
                ></v-text-field>
                </v-col>
            </v-row>
            <v-row>
                <v-spacer></v-spacer>
                <v-btn color="green" rounded="2" class="mb-2" @click="addTeacher">
                Create
                </v-btn>
            </v-row>
            </v-container>
        </v-form>
    </v-card>

    <v-card title="Students" class="ma-5">
        <v-data-table-virtual
            :headers="studentHeaders"
            :items="virtualStudents"
            item-value="name"
        >
        <template #item.teacher="{ item }">
            <!-- Input Field -->
            <v-select
            label="Teacher"
            :items="teachersList"
            v-model="item.teacher"
            variant="underlined"
            @update:model-value="updateTeacher(item)"
            ></v-select>
        </template>
        <template #item.password="{ item }">
            <div class="d-flex align-center">
                <!-- Input Field -->
                <v-text-field
                label="Password"
                variant="underlined"
                hide-details
                v-model="item.password"
                type="password"
                dense
                ></v-text-field>

                <!-- Button -->
                <v-btn color="blue" rounded="2" @click="resetPassword(item, true)">
                Reset
                </v-btn>
            </div>
        </template>
        </v-data-table-virtual>

        <v-card-subtitle class="my-4">Add New Student</v-card-subtitle>
        <v-form v-model="valid">
            <v-container>
            <v-row>
                <v-col
                cols="12"
                md="4"
                >
                <v-text-field
                    v-model="studentEmail"
                    label="Email"
                    variant="underlined"
                    required
                ></v-text-field>
                </v-col>

                <v-col
                cols="12"
                md="4"
                >
                <v-text-field
                    v-model="studentName"
                    label="Name"
                    variant="underlined"
                    required
                ></v-text-field>
                </v-col>

                <v-col
                cols="12"
                md="4"
                >
                <v-select
                v-model="studentTeacher"
                label="Teacher"
                :items="teachersList"
                variant="underlined"
                ></v-select>
                </v-col>

                <v-col
                cols="12"
                md="4"
                >
                <v-text-field
                    v-model="studentPassword"
                    label="Password"
                    variant="underlined"
                    required
                    type="password"
                ></v-text-field>
                </v-col>
            </v-row>
            <v-row>
                <v-spacer></v-spacer>
                <v-btn color="green" rounded="2" class="mb-2" @click="addStudent">
                Create
                </v-btn>
            </v-row>
            </v-container>
        </v-form>
    </v-card>
</template>