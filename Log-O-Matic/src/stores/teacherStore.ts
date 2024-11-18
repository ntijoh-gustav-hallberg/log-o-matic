import { defineStore } from 'pinia'
import { API_BASE_URL } from '../../config';

interface ITeacher {
    userId: number,
    email: string,
    name: string,
    password: string
}
  
export const useTeacherStore = defineStore("teacherStore", {
    // State
    state: () => ({
        teachers: [] as ITeacher[],
        isDataFetched: false,
    }),
  
    // Getters
    getters: {
        getAll: (state) => {
            return state.teachers;
        },
        getTeacherByEmail: (state) => (email: string) => {
            return state.teachers.find((teacher) => teacher.email === email);
        },
        teacherCount: (state) => {
            return state.teachers.length;
        },
        getTeacherIdByName: (state) => (name: string) => {
            return state.teachers.find((teachers) => teachers.name === name)?.userId;
        },
    },
  
    actions: {
        async ensureTeachersLoaded() {
            if (!this.isDataFetched) {
                await this.fetchTeachers();
            }
        },

        async fetchTeachers() {
            try {
                const response = await fetch(`${API_BASE_URL}/admin/teachers`, {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                if (!response.ok)
                    throw new Error("Failed to get teachers")

                const data = await response.json();

                data.forEach(element => {
                    this.teachers.push({
                        userId: element.userId,
                        email: element.email,
                        name: element.name,
                        password: ""
                    })

                });

                this.isDataFetched = true;
            } catch (error) {
                console.error("Error fetching teachers: ", error);
            }
        },
        addTeacher(teacher: ITeacher) {
            try {
                const response = fetch(`${API_BASE_URL}/admin/addTeacher`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(teacher)
                })

                if(!response)
                    throw new Error("Failed to add teacher")
                
                this.teachers.push(teacher);
            } catch (error) {
                console.error("Error adding teacher: ", error);
            }
        },
        removeTeacher(email: string) {
            this.teachers = this.teachers.filter((teacher) => teacher.email !== email);
        },
        updateTeacher(email: string, updatedData: Partial<ITeacher>) {
            const teacherIndex = this.teachers.findIndex(
                (teacher) => teacher.email === email);

            if (teacherIndex !== -1) {
                this.teachers[teacherIndex] = {
                    ...this.teachers[teacherIndex],
                    ...updatedData,
                };
            }
        },
        resetPassword(email: string, password: string) {
            const teacherIndex = this.teachers.findIndex(
                (teacher) => teacher.email === email);
            if (teacherIndex !== -1) {
                this.teachers[teacherIndex].password = password;
            }
        }
    },
});