<template>
  <v-card class="mx-auto px-6 py-8" max-width="344">
    <v-form 
        v-model="form"
        @submit.prevent="onSubmit"
    >


      <v-text-field
        variant="outlined"
        v-model="state.email"
        :error-messages="v$.email.$errors.map(e => e.$message)"
        label="E-mail"
        placeholder="johndoe@gmail.com"
        persistent-clear
        clearable
        required
        @blur="v$.email.$touch"
        @input="v$.email.$touch"
      ></v-text-field>

      <v-text-field
        variant="outlined"
        v-model="state.password"
        :counter="20"
        :error-messages="v$.password.$errors.map(e => e.$message)"
        label="Password"
        hint="Enter your password"
        persistent-clear
        clearable
        required
        append-icon="mdi-map-marker"
        @blur="v$.password.$touch"
        @input="v$.password.$touch"
      ></v-text-field>
      <br>
      <v-btn
            :disabled="!form"
            :loading="loading"
            color="success"
            size="large"
            type="submit"
            variant="elevated"
            block
          >
            Logga in
          </v-btn>
      <v-btn @click="clear" style="margin-top: 20px;">
        clear
      </v-btn>
    </v-form>
</v-card>
</template>
<script setup>
  import { reactive } from 'vue'
  import { useVuelidate } from '@vuelidate/core'
  import { email, required } from '@vuelidate/validators'

  const initialState = {
    password: '',
    email: '',
  }

  const state = reactive({
    ...initialState,
  })

  const rules = {
    password: { required },
    email: { required, email },
  }

  const v$ = useVuelidate(rules, state)

  const form = ref(false)
  const loading = ref(false);

  async function onSubmit() {
  const isFormValid = await v$.value.$validate()
  if (isFormValid) {
    
    try {
      setTimeout(()=> {
        yabi()
      }, 1000)
      
    } finally {
    }
  }
}

  function clear () {
    v$.value.$reset()

    for (const [key, value] of Object.entries(initialState)) {
      state[key] = value
    }
  }

  function yabi(){
    for (const [key, value] of Object.entries(state)) {
      console.log(state[key]) 
    }
  }



</script>