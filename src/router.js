import { createRouter, createWebHistory } from "vue-router";
import midcontent from "./view/midcontent.vue";
import login from "./view/login.vue";
import userCenter from "./view/userCenter.vue";
import usermassage from "./components/usermessage.vue";
import upload from "./components/upload.vue";
import SignIn from "./components/SignIn.vue";
import Signup from "./components/Signup.vue";
import DataLoder from "./components/DataLoder.vue";
import UserManger from "./components/UserManger.vue";
import DataReview from "./components/DataReview.vue";
export const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: "/",
      component: midcontent,
    },
    {
      path: "/login",
      component: login,
      children: [
        {
          path: "",
          component: SignIn,
        },
        {
          path: "signup",
          component: Signup,
        },
      ],
    },
    {
      path: "/center",
      component: userCenter,
      children: [
        {
          path: "",
          component: usermassage,
        },
        {
          path: "upload",
          component: upload,
        },
        {
          path: "dataloder",
          component: DataLoder,
        },
        {
          path: "usermanger",
          component: UserManger,
        },
        {
          path: "datareview",
          component: DataReview,
        },
      ],
      beforeEnter: (to, from) => {
        // reject the navigation
        const token = localStorage.getItem("token");
        if (token) {
          return true;
        } else {
          return false;
        }
      },
    },
  ],
});
