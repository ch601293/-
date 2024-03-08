<script setup>
import { NCard, NConfigProvider, NMessageProvider } from "naive-ui";
import { useRouter } from "vue-router";
import mymenu from "../components/mymenu.vue";
</script>
<template>
  <div class="container" id="container">
    <mymenu class="menu"></mymenu>
    <n-message-provider>
      <div id="rightcontainer">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </div>
    </n-message-provider>
  </div>
</template>
<script>
import { defineComponent } from "vue";
import { useRouter } from "vue-router";
import { currentGrade } from "../assets/stores/store";
import axios from "axios";
export default defineComponent({
  beforeRouteEnter(to, from, next) {
    //需要处理的逻辑
    const token = localStorage.getItem("token");
    const router = useRouter();
    const Grade = currentGrade()
    if (token) {
      axios
        .get("https://y4705w2671.oicp.vip/api/v1/user/selfInfo", {
          headers: {
            Authorization: token,
          },
        })
        .then((res) => {
          if(res.data?.status===40004){
            router.push('/login');
            return ;
          }
          Grade.grade = res.data.data.grade;
          Grade.id = res.data.data.id;
          next();
        });
    }else{
      router.push('/login');
    }
  },
});
</script>
<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
.container {
  width: 100%;
  height: 88vh;
  display: flex;
  padding: 0;
  margin: 0;
}
@media (min-width: 1400px) {
  .container {
    max-width: 100vw; /* 新的max-width值 */
  }
}

#rightcontainer {
  width: 100%;
  height: 88vh;
}
</style>
