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
                <v-btn color="blue" rounded="2" @click="resetPassword(item)">
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
            @update:model-value="updateStudentTeacher(item)"
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
                <v-btn color="blue" rounded="2" @click="resetPassword(item)">
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

    <v-card title="Questions" class="ma-5">
        <v-confirm-edit v-model="confirmEdit" @save="updateQuestion()" @cancel="cancelQuestion()" v-if="viewChangeQuestion">
            <template v-slot:default="{ model: proxyModel, actions }">
                <v-card
                class="mx-auto"
                max-width="400"
                title="Change Question"
                v-model="changeQuestionCard"
                >
                <template v-slot:text>
                    <v-textarea
                    v-model="proxyModel.value"
                    messages="Confirm edit"
                    ref="editTextArea"
                    @update:focused="renderQuestion(proxyModel)"
                    @update:model-value="updateCurrentQuestion(proxyModel)"
                    ></v-textarea>
                </template>

                <template v-slot:actions>
                    <v-spacer></v-spacer>

                    <component :is="actions"></component>
                </template>
                </v-card>
            </template>
        </v-confirm-edit>

        <v-data-table-virtual
            :headers="questionHeaders"
            :items="virtualQuestions"
            item-value="name"
        >
        <template #item.actions="{ item }">
            <div class="d-flex align-center">
                <v-btn color="blue" rounded="2" @click="toggleChangeQuestion(item)">
                Change
                </v-btn>
                <!-- Button -->
                <v-btn color="red" rounded="2" @click="deleteQuestion(item)">
                Delete
                </v-btn>
            </div>
        </template>
        </v-data-table-virtual>

        <v-card-subtitle class="my-4">Add New Question</v-card-subtitle>
        <v-form v-model="valid">
            <v-container>
            <v-row>

                <v-textarea
                    v-model="questionInput"
                    label="Question"
                    variant="outlined"
                    required
                ></v-textarea>
            </v-row>
            <v-row>
                <v-spacer></v-spacer>
                <v-btn color="green" rounded="2" class="mb-2" @click="addQuestion">
                Create
                </v-btn>
            </v-row>
            </v-container>
        </v-form>
    </v-card>
</template>

<script>
import {useTeacherStore} from "../stores/teacherStore.ts"
import {useStudentStore} from "../stores/studentStore.ts"
import {useQuestionStore} from "../stores/questionStore.ts"

const questionStore = useQuestionStore();
const teacherStore = useTeacherStore();
const studentStore = useStudentStore();

// For tables
    export default {
        data () {
            return {
                teacherHeaders: [
                    { title: 'Email', align: 'start', key: 'email' },
                    { title: 'Name', align: 'start', key: 'name' },
                    { title: '', align: 'end', key: 'password' },

                ],
                teachers: teacherStore.getAll,
                teacherEmail: "",
                teacherName: "",
                teacherPassword: "",

                studentHeaders: [
                    { title: 'Email', align: 'start', key: 'email' },
                    { title: 'Name', align: 'start', key: 'name' },
                    { title: 'Teacher', align: 'start', key: 'teacher' },
                    { title: '', align: 'end', key: 'password' },

                ],
                students: studentStore.getAll,
                studentTeacher: "",
                studentEmail: "",
                studentName: "",
                studentPassword: "",

                questionHeaders: [
                    { title: 'Questions', align: 'start', key: 'question' },
                    { title: '', align: 'end', key: 'actions' },
                ],
                questions: questionStore.getAll,
                viewChangeQuestion: false,
                selectedQuestionId: 0,
                currentQuestion: "",
                questionInput: "",
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

            virtualQuestions () {
                return [...Array(this.questions.length).keys()].map(i => {
                    const question = { ...this.questions[i % this.questions.length] }
                    return question
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
                    password: this.studentPassword,
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

            resetPassword(data) {
                studentStore.resetPassword(data.email, data.password)
            },

            updateStudentTeacher(item) {
                item.teacherId = teacherStore.getTeacherIdByName(item.teacher);
                studentStore.updateStudentTeacher(item);
            },

            toggleChangeQuestion(item) {
                //Toggles visibility of form
                if(this.selectedQuestionId === item.questionId || !this.viewChangeQuestion) {
                    this.viewChangeQuestion = !this.viewChangeQuestion;
                }
                this.selectedQuestionId = item.questionId;

                this.currentQuestion = item.question

                // Focus the textarea after it becomes visible
                this.$nextTick(() => {
                    const textarea = this.$refs.editTextArea;
                    if (textarea && textarea.focus) {
                        textarea.focus(); // Programmatically focus the textarea
                    }
                });
            },

            addQuestion() {
                questionStore.addQuestion(this.questionInput);
            },

            renderQuestion(proxyModel) {
                proxyModel.value = this.currentQuestion
            },

            updateCurrentQuestion(proxyModel) {
                this.currentQuestion = proxyModel.value;
            },

            cancelQuestion() {
                this.viewChangeQuestion = !this.viewChangeQuestion;
            },

            updateQuestion() {
                questionStore.updateQuestion({questionId: this.selectedQuestionId, question: this.currentQuestion});
            },

            deleteQuestion(item) {
                questionStore.removeQuestion(item.questionId);
            },
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