<template>
  <v-app>
    <v-container class="pa-4">
      <v-row align="center" justify="center">
        <v-col cols="12" sm="6" md="4">
          <!-- Card with centered text -->
          <v-card>
            <v-card-title class="text-center">Week: {{ week }}</v-card-title>
            <v-card-title class="text-center">{{ student.name }}</v-card-title>

            <!-- Day Change Buttons -->
            <v-card-actions class="justify-center">
              <v-btn @click="changeDay('previous')" icon>
                <v-icon>mdi-chevron-left</v-icon>
              </v-btn>
              <v-card-text class="text-center">{{ currentDay }}</v-card-text>
              <v-btn @click="changeDay('next')" icon>
                <v-icon>mdi-chevron-right</v-icon>
              </v-btn>
            </v-card-actions>

          </v-card>
        </v-col>
      </v-row>

      <!-- Display Questions and Answers below the week info -->
      <v-row align="center" justify="center">
        <!-- Outer Column to Center the Card -->
        <v-col cols="12" md="6">
          <v-card class="pa-14" outlined>

            <!-- Questions and Answers Stuff -->
            <div v-for="(question, index) in questions" :key="index">
              <v-card-title class="text-left font-weight-bold">{{ question.answer }}</v-card-title>
              <v-card-text class="text-left">{{ question.response }}</v-card-text>
              <v-divider></v-divider>
            </div>


            <!-- Timeline med Comments -->
            <v-timeline align="start" width="100%" class="px-8 mb-4">
              <v-timeline-item v-for="(comment, index) in student.comments" :key="index">
                <template v-slot:opposite>
                  <span>{{ index % 2 === 0 ? 'Teacher' : 'Student' }}</span>
                </template>
                <v-card class="pa-4" outlined>
                  <v-card-text>{{ comment }}</v-card-text>
                </v-card>
              </v-timeline-item>
            </v-timeline>
          </v-card>

          <!-- Comment Input Card -->
          <v-card>
            <v-card-title>Submit a Comment</v-card-title>
            <v-card-text>
              <v-textarea label="Your Comment" v-model="newComment" rows="4" outlined></v-textarea>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="primary" @click="submitComment" :disabled="!newComment.trim()">
                Submit
              </v-btn>
            </v-card-actions>
          </v-card>

          <v-divider class="my-4"></v-divider>

        </v-col>
      </v-row>

    </v-container>
  </v-app>
</template>

<script lang="ts" setup>

import { ref, computed } from "vue";
import { useRoute } from "vue-router";

// Set initial constants and get routes from the link
const route = useRoute();
const week = route.query.week || "45";
const studentId = typeof route.query.student === 'number' ? ref(route.query.student) : ref(0);

interface Answer {
  answerId: number;
  questionId: number | null;
  answer: string;
}

interface Question {
  questionId: number;
  question: string | null;
}

interface Comment {
  commentId: number;
  userId: number;
  comment: string;
}

interface ApiResponse {
  postId: number;
  userId: number;
  date: string;
  questions: Question[];
  answers: Answer[];
  comments: Comment[];
}

const queryParams = new URLSearchParams({
  studentId: studentId.value.toString(),
  week: week.toString(),
});
const apiUrl = `/api/v1/posts?${queryParams.toString()}`;
const data = ref<ApiResponse[] | null>(null);
const loading = ref(false);
const error = ref<string | null>(null);

const fetchData = async (): Promise<void> => {
  loading.value = true;
  error.value = null;
  try {
    const response = await fetch(apiUrl);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const result: ApiResponse[] = await response.json();
    data.value = result;
  } catch (err) {
    error.value = (err as Error).message;
  } finally {
    loading.value = false;
  }
};

const siteInformation = fetchData();

// Day conversion (Swedish: english)
const tableHeaders = [
  { text: "Name", value: "name" },
  { text: "Måndag", value: "monday" },
  { text: "Tisdag", value: "tuesday" },
  { text: "Onsdag", value: "wednesday" },
  { text: "Torsdag", value: "thursday" },
  { text: "Fredag", value: "friday" },
];

// Placeholder Student


const questions = ref([
  {
    answer: "What is your favorite color?",
    response: "My favorite color is blue because it represents tranquility, calmness, and the serenity of the sky. It's a color that gives me a sense of peace and relaxation, and I feel it connects with my personality as someone who enjoys quiet moments and reflection."
  },
  {
    answer: "What is your hobby?",
    response: "I love reading books in my spare time. It allows me to escape into different worlds and perspectives, expanding my knowledge and understanding of the world. I particularly enjoy fantasy and historical fiction, but I am also drawn to self-improvement books that challenge my mindset and offer new insights."
  },
  {
    answer: "What is your favorite food?",
    response: "Pizza is my all-time favorite food. There's something so comforting about the combination of a crispy crust, savory tomato sauce, melted cheese, and endless topping possibilities. Whether it's a classic Margherita or a more adventurous combination, pizza always feels like a treat, and I love sharing it with friends and family."
  },
  {
    answer: "What motivates you?",
    response: "I am motivated by personal growth and the desire to continually improve myself. Whether it’s learning a new skill, tackling a challenging project, or overcoming an obstacle, the sense of achievement and progress is incredibly rewarding. I am also driven by helping others and contributing to causes that matter to me."
  },
  {
    answer: "Where do you see yourself in 5 years?",
    response: "In five years, I hope to have made significant progress in my career, having grown both professionally and personally. I envision myself in a leadership position, making an impact through my work and continuing to develop my skills. I also hope to have traveled more and explored new cultures, enriching my understanding of the world."
  },
]);

// Days of the week
const daysOfWeek = ["Måndag", "Tisdag", "Onsdag", "Torsdag", "Fredag"];

const currentDayIndex = ref(0);

const student = {
  name: "John 'Jonny boy' Johnsson", // Best placeholder name ever
  comments: [
    "Your answers are concise, but try to add more detail next time.",
    "Very thorough responses, but I think you could use a few more examples to back up your ideas.",
    "Nice effort, but I feel like you could dive deeper into each question.",
  ]
};

// Computed property for the current day name

const currentDay = computed(() => {
  return daysOfWeek[currentDayIndex.value];
});

// Method to change the day
const changeDay = (direction: "previous" | "next") => {
  if (direction === "previous") {
    currentDayIndex.value = (currentDayIndex.value - 1 + 5) % 5;
  } else if (direction === "next") {
    currentDayIndex.value = (currentDayIndex.value + 1) % 5;
  }
};

const newComment = ref<string>('');

const submitComment = (): void => {
  if (newComment.value.trim()) {
    console.log('Submitted Comment:', newComment.value.trim());
    newComment.value = ''; // Clear input after submission
  }
};

</script>

<style scoped></style>
