import { defineStore } from 'pinia'

interface IStudent {
    email: string,
    name: string,
    teacher: string,
    password: string
}

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
  