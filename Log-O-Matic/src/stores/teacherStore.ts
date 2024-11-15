import { defineStore } from 'pinia'

interface ITeacher {
    email: string,
    name: string,
    password: string
}
  
const teacherList: ITeacher[] = [
    {
      email: "daniel.berg@ga.ntig.se",
      name: "Daniel Berg",
      password: "",
    },
    {
      email: "linus.styren@ga.ntig.se",
      name: "Linus Styren",
      password: "",
    },
    {
      email: "fredrik.kronhamn@ga.ntig.se",
      name: "Fredrik Kronhamn",
      password: "",
    },
    {
      email: "ola.lindberg@ga.ntig.se",
      name: "Ola Lindberg",
      password: "",
    },
]
  
export const useTeacherStore = defineStore("teacherStore", {
    // State
    state: () => ({ teachers: teacherList as ITeacher[]
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
    },
  
    actions: {
      addTeacher(teacher: ITeacher) {
        this.teachers.push(teacher);
      },
      removeTeacher(email: string) {
        this.teachers = this.teachers.filter((teacher) => teacher.email !== email);
      },
      updateTeacher(email: string, updatedData: Partial<ITeacher>) {
        const teacherIndex = this.teachers.findIndex(
          (teacher) => teacher.email === email
        );
        if (teacherIndex !== -1) {
          this.teachers[teacherIndex] = {
            ...this.teachers[teacherIndex],
            ...updatedData,
          };
        }
      },
    },
});