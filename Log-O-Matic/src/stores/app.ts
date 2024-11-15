// Utilities
import { defineStore } from 'pinia'

export const useAppStore = defineStore('app', {
  state: () => ({
    //
  }),
})

interface ITeacher {
  email: string,
  name: string,
  password: string
}

interface IStudent {
  email: string,
  name: string,
  teacher: string,
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

const studentList: IStudent[] = [
  {
      email: "emma.svensson@ga.elev.ntig.se",
      name: "Emma Svensson",
      teacher: "Linus Styren",
      password: "",
  },
  {
      email: "alex.johansson@ga.elev.ntig.se",
      name: "Alex Johansson",
      teacher: "Linus Styren",
      password: "",
  },
  {
      email: "maria.karlsson@ga.elev.ntig.se",
      name: "Maria Karlsson",
      teacher: "Daniel Berg",
      password: "",
  },
  {
      email: "erik.nilsson@ga.elev.ntig.se",
      name: "Erik Nilsson",
      teacher: "Fredrik Kronhamn",
      password: "",
  },
  {
      email: "sara.andersson@ga.elev.ntig.se",
      name: "Sara Andersson",
      teacher: "Ola Lindberg",
      password: "",
  },
  {
      email: "lisa.persson@ga.elev.ntig.se",
      name: "Lisa Persson",
      teacher: "Ola Lindberg",
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

export const useStudentStore = defineStore("studentStore", {
  // State
  state: () => ({ students: studentList as IStudent[]
  }),

  // Getters
  getters: {
    getAll: (state) => {
      return state.students;
    },
    getStudentByEmail: (state) => (email: string) => {
      return state.students.find((student) => student.email === email);
    },
    getTeacher: (state) => {
      return state.students
    },
  },

  actions: {
    addStudent(student: IStudent) {
      this.students.push(student);
    },
    removeStudent(email: string) {
      this.students = this.students.filter((student) => student.email !== email);
    },
    updateStudent(email: string, updatedData: Partial<IStudent>) {
      const studentIndex = this.students.findIndex(
        (student) => student.email === email
      );
      if (studentIndex !== -1) {
        this.students[studentIndex] = {
          ...this.students[studentIndex],
          ...updatedData,
        };
      }
    },
  },
});
