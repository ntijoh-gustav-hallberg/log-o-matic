// Utilities
import { defineStore } from 'pinia'
import router from '@/router'
import { API_BASE_URL } from '../config';

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
    async signIn(credentials: {email: string, password: string}){

        try{
            const response = await fetch(`${API_BASE_URL}/api/v1/users/signin`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(credentials)
            });
    
            if (!response.ok) {
                throw new Error("Failed to log in: " + response);
            }
    
            const data = await response.json();
    
            console.log("API response data:", data);

            if (data.token){
                this.token = data.token
                console.log("JWT Token set in store:", this.token);
                if (data.isTeacher){
                    this.teacher = true
                }else{
                    this.teacher = false
                }
                router.push('/')
            }
            
        }catch (error) {
            console.error("Login failed:", error);
        } 
    }
  }
})


export default useUserStore;