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
        :append-inner-icon="visible ? 'mdi-eye-off' : 'mdi-eye'"
        :type="visible ? 'text' : 'password'"
        :counter="20"
        :error-messages="v$.password.$errors.map(e => e.$message)"
        label="Password"
        hint="Enter your password"
        persistent-clear
        clearable
        required
        @blur="v$.password.$touch"
        @input="v$.password.$touch"
        @click:append-inner="visible = !visible"
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

<script lang="ts" setup>
  import { reactive } from 'vue'
  import { useVuelidate } from '@vuelidate/core'
  import { email, required } from '@vuelidate/validators'
  import useUserStore from '@/stores/userStore';

const userStore = useUserStore()

const visible = ref(false);

const initialState = {
    email: '',
    password: '',
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
        yabi() 
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
    userStore.signIn(state);
  }
</script>