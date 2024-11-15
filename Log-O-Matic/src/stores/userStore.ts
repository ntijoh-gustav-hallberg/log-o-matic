// Utilities
import { defineStore } from 'pinia'
import router from '@/router'

const users = [{
    email: 'philip@agbilverkstad.se',
    password: '123',
    teacher: false
}, {
    email: '1@1.se',
    password: '123',
    teacher: true
}
]


const useUserStore = defineStore('userstore', {
  state: () => ({
    token: "",
    teacher: false,
  }),
  getters: {
  },
  actions: {
    login(token: string){
        console.log(token + ' is set')
        this.token = token;
    },
    signIn(credentials: {email: string, password: string}){

        const user = users.find((user) => user.email === credentials.email);
        if (user) {
            if (user.password === credentials.password) {
                console.log("Sign-in successful!");
                if (user.teacher){
                    this.teacher = user.teacher
                }else{
                    this.teacher = false
                }
                this.login('verified')
                router.push('/')
            } else {
                console.error("Incorrect password.");
            }
        } else {
            console.error("User not found.");
        }
          
    }
  }
})


export default useUserStore;