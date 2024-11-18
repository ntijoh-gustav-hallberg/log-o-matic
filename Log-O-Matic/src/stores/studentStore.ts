import { defineStore } from 'pinia'
import { API_BASE_URL } from '../../config';

interface IStudent {
    email: string,
    name: string,
    teacher: string,
    password: string
}

export const useStudentStore = defineStore("studentStore", {
    // State
    state: () => ({
        students:[] as IStudent[],
        isDataFetched: false,
    }),
  
    // Getters
    getters: {
        getAll: (state) => {
            return state.students;
        },
        getStudentByEmail: (state) => (email: string) => {
            return state.students.find((student) => student.email === email);
        },
    },
  
    actions: {
        // Inside your store
        async ensureStudentsLoaded() {
            if (!this.isDataFetched) {
                await this.fetchStudents();
            }
        },

        async fetchStudents() {
            try {
                const response = await fetch(`${API_BASE_URL}/admin/students`, {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                if (!response.ok)
                    throw new Error("Failed to get students")

                const data = await response.json();

                data.forEach(element => {
                    this.students.push({
                        email: element.email,
                        name: element.name,
                        teacher: element.teacher_name,
                        password: ""
                    })

                });

                console.log(JSON.stringify(this.students));

                this.isDataFetched = true;
            } catch (error) {
                console.error("Error fetching students: ", error);
            }
        },
        addStudent(student: IStudent) {
            this.students.push(student);
        },
        removeStudent(email: string) {
            this.students = this.students.filter((student) => student.email !== email);
        },
        resetPassword(email: string, password: string) {
            const studentIndex = this.students.findIndex(
                (student) => student.email === email);
            if (studentIndex !== -1) {
                this.students[studentIndex].password = password;
            }
        },
        updateStudentTeacher(email: string, teacher: string) {
            const studentIndex = this.students.findIndex(
                (student) => student.email === email);
            
            if(studentIndex !== -1) {
                this.students[studentIndex].teacher = teacher;
            }
        }
    },
});
  