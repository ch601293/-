<script >
import { defineComponent } from 'vue';
import { useRouter } from "vue-router";
export default defineComponent({
  beforeRouteEnter(to, from, next) {
    //需要处理的逻辑
    const token = localStorage.getItem('token');
    const router = useRouter();
    if(token){
      router.push('/center');
    }else{
      next();
    }
    
  }
});
</script>

<template>
  <div class="login flex h-[88vh] flex-row ">
      <section class="flex-1">
        <router-view></router-view>
      </section>
      
      <div class="flex-1">
      </div>
  </div>
</template>


<style scoped>
.login{
  background-image: url("../assets//logo/login.jpg");
  background-repeat: no-repeat ;
  height: 88vh;
}
</style>