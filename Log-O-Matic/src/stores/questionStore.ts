import { defineStore } from 'pinia'
import { API_BASE_URL } from '../../config';

interface IQuestion {
    questionId: number,
    question: string,
}

export const useQuestionStore = defineStore("questionStore", {
    // State
    state: () => ({
        questions:[] as IQuestion[],
        isDataFetched: false,
    }),
  
    // Getters
    getters: {
        getAll: (state) => {
            return state.questions;
        },
    },
  
    actions: {
        async ensureQuestionsLoaded() {
            if (!this.isDataFetched) {
                await this.fetchQuestions();
            }
        },

        async fetchQuestions() {
            try {
                const response = await fetch(`${API_BASE_URL}/admin/questions`, {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })

                if (!response.ok)
                    throw new Error("Failed to get questions")

                this.questions.splice(0, this.questions.length);

                const data = await response.json();

                data.forEach(element => {
                    this.questions.push({
                        questionId: element.questionId,
                        question: element.question
                    })

                });

                this.isDataFetched = true;
            } catch (error) {
                console.error("Error fetching questions: ", error);
            }
        },

        async addQuestion(question: string) {
            if(question === "") {
                throw new Error("A field is empty");
            }

            try {
                const response = await fetch(`${API_BASE_URL}/admin/question/add`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(question)
                })

                if(!response)
                    throw new Error("Failed to add question")

                return this.fetchQuestions();
            } catch (error) {
                console.error("Error adding question: ", error);
            }

        },

        updateQuestion(questionData: IQuestion) {
            try {
                const response = fetch(`${API_BASE_URL}/admin/question/update`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(questionData)
                })

                if(!response)
                    throw new Error("Failed to update question")
                
                const questionIndex = this.questions.findIndex(
                    (question) => question.questionId === questionData.questionId);

                if(questionIndex !== -1) {
                    this.questions[questionIndex].question = questionData.question;
                }
            } catch (error) {
                console.error("Error updating question: ", error);
            }
        },

        removeQuestion(questionId: number) {
            try {
                const response = fetch(`${API_BASE_URL}/admin/question/remove`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(questionId)
                })

                if(!response)
                    throw new Error("Failed to update question")
                
                const questionIndex = this.questions.findIndex(
                    (question) => question.questionId === questionId);

                this.questions.splice(questionIndex, 1)

            } catch (error) {
                console.error("Error updating question: ", error);
            }
        }
    },
});
  