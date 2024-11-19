import { defineStore } from 'pinia'
import { API_BASE_URL } from '../../config';

interface IStudent {
    email: string,
    name: string,
    teacherId: number,
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
                        teacherId: element.teacher_id,
                        teacher: element.teacher_name,
                        password: ""
                    })

                });

                this.isDataFetched = true;
            } catch (error) {
                console.error("Error fetching students: ", error);
            }
        },
        addStudent(student: IStudent) {
            try {
                const response = fetch(`${API_BASE_URL}/admin/student/add`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(student)
                })

                if(!response)
                    throw new Error("Failed to add student")
                
                this.students.push(student);
            } catch (error) {
                console.error("Error adding student: ", error);
            }
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
        updateStudentTeacher(studentData: IStudent) { 
            try {
                const response = fetch(`${API_BASE_URL}/admin/student/changeTeacher`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(studentData)
                })

                if(!response)
                    throw new Error("Failed to add student")
                
                const studentIndex = this.students.findIndex(
                    (student) => student.email === studentData.email);
                    
                if(studentIndex !== -1) {
                    this.students[studentIndex].teacher = studentData.teacher;
                    this.students[studentIndex].teacherId = studentData.teacherId;
                }
            } catch (error) {
                console.error("Error adding student: ", error);
            }
        }
    },
});
  