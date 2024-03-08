// stores/counter.js
import { defineStore } from 'pinia'

export const currentGrade = defineStore('usergrade', {
  state: () => {
    return { grade: -1,id:-1 }
  },
  actions: {
    changeGrade(value) {
      this.grade = value;
    },
    changeId(value) {
      this.id = value;
    }
  },
  getters: {
    getGrade: (state)=> state.grade,
    getId: (state)=> state.id
  }
})