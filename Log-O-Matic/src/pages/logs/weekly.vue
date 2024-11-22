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
            <div v-if="currentDayData" v-for="(question, index) in currentDayData.questions" :key="index">
              <v-card-title class="text-left font-weight-bold">{{ question.question }}</v-card-title>
              <v-card-text class="text-left">{{ currentDayData.answers[index].answer }}</v-card-text>
              <v-divider></v-divider>
            </div>


            <!-- Timeline with Comments -->
            <v-timeline align="start" width="100%" class="px-8 mb-4">
              <v-timeline-item v-if="currentDayData" v-for="(comment, index) in currentDayData.comments" :key="index">
                <template v-slot:opposite>
                  <span>{{ index % 2 === 0 ? 'Teacher' : 'Student' }}</span>
                </template>
                <v-card class="pa-4" outlined>
                  <v-card-text>{{ comment.comment }}</v-card-text>
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

import { ref, computed, onMounted } from "vue";
import { useRoute } from "vue-router";

onMounted(() => {
  console.log("Fetching Data");
  fetchData();
})

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
  answer: string | null;
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
const apiUrl = `http://localhost:9292/api/v1/posts?${queryParams.toString()}`;
const loading = ref(false);
const error = ref<string | null>(null);

const questions = ref<Question[]>([]);
const comments = ref<string[]>([]);

// Data structure to hold the entire week's data by day
const weekData = ref<{ [key: string]: ApiResponse }>({}); // Store data by day

const fetchData = async (): Promise<void> => {
  loading.value = true;
  error.value = null;
  try {
    const token = localStorage.getItem('jwt_token');
    console.log('JWT Token:', token);

    const response = await fetch(apiUrl, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const result: ApiResponse[] = await response.json();
    console.log('Response Data:', result); // Log the raw data fetched

    // Store the data for the entire week, mapped by day
    result.forEach(post => {
      const postDate = new Date(post.date);
      const day = postDate.getDay(); // Get day of the week (0 = Sunday, 1 = Monday, etc.)
      const dayOfWeek = daysOfWeek[day === 0 ? 6 : day - 1]; // Adjust for Monday to Friday (Sunday -> Saturday)

      // Log the fetched date and the assigned day
      console.log(`Fetched date: ${postDate.toDateString()}, Assigned to: ${dayOfWeek},\nSamples; Question: ${post.questions[0].question}, Answer: ${post.answers[0].answer}`);

      // Map data to corresponding day
      weekData.value[dayOfWeek] = post;
    });

    // Initialize the current day's data
    setCurrentDayData();

  } catch (err) {
    error.value = (err as Error).message;
    console.error('Error:', error.value);
  } finally {
    loading.value = false;
  }
};


// Store the current day's data
const currentDayData = ref<ApiResponse | null>(null);

const setCurrentDayData = () => {
  const currentPost = weekData.value[daysOfWeek[currentDayIndex.value]];

  console.log(`Fetching data for: ${daysOfWeek[currentDayIndex.value]}`);

  if (currentPost) {
    console.log(`Found post for ${daysOfWeek[currentDayIndex.value]}`);

    // Update reactive variables directly
    currentDayData.value = currentPost; // Set the entire object directly to trigger reactivity
    
    // Map the data to questions and comments
    questions.value = currentPost.questions.map((q, index) => ({
      questionId: q.questionId,
      question: q.question,
      answer: currentPost.answers[index]?.answer || null,
    }));

    comments.value = currentPost.comments.map(c => c.comment);
  } else {
    console.log(`No data found for ${daysOfWeek[currentDayIndex.value]}`);
  }
};

// Replace student comments and questions with dynamic data
const student = {
  name: "John 'Jonny boy' Johnsson", // Placeholder for static name
  comments, // Use reactive comments array
};

// Days of the week
const daysOfWeek = ["Måndag", "Tisdag", "Onsdag", "Torsdag", "Fredag"];

const currentDayIndex = ref(0);

// Computed property for the current day name

const currentDay = computed(() => {
  return daysOfWeek[currentDayIndex.value];
});

// Method to change the day
const changeDay = (direction: "previous" | "next") => {
  if (direction === "previous") {
    currentDayIndex.value = (currentDayIndex.value - 1 + 5) % 5; // Handle wraparound for previous day
  } else if (direction === "next") {
    currentDayIndex.value = (currentDayIndex.value + 1) % 5; // Handle wraparound for next day
  }

  console.log(`Current day value: ${daysOfWeek[currentDayIndex.value]}`)

  // Update the current day's data after changing
  setCurrentDayData();
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
