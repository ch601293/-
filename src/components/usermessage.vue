<script setup>
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";
import * as z from "zod";
import { NSwitch } from "naive-ui";
import { useToast } from "@/components/ui/toast/use-toast";
const token = localStorage.getItem("token");
const UserInfo = ref({});
const userNumber = ref(0);
const emailActive = ref(false);
const pwActive = ref(false);
const Uemail = ref("");
const Upassword = ref("");
const router = useRouter();
const { toast } = useToast();
onMounted(() => {
  axios
    .get("https://y4705w2671.oicp.vip/api/v1/user/selfInfo", {
      headers: {
        Authorization: token,
      },
    })
    .then((res) => {
      UserInfo.value = res.data.data;
      console.log(UserInfo.value);
    });

});
function changedInfo() {
  if (emailActive.value) {
    try {
      const result = z.string().email().parse(Uemail.value);
      axios
        .post(
          "https://y4705w2671.oicp.vip/api/v1/user/updateEmail",
          { email: result },
          {
            headers: {
              Authorization: token,
            },
          }
        )
        .then((res) => {
          toast({
            title: "成功",
            description: "邮箱修改成功",
          });
        });
    } catch (error) {
      toast({
        title: "邮箱地址错误",
        description: "地址格式错误！",
      });
    }
  }
  if (pwActive.value) {
    try {
      const result = z.string()
        .min(6, { message: "密码不少于6位,请重新输入!" })
        .parse(Upassword.value);
        axios
        .post(
          "https://y4705w2671.oicp.vip/api/v1/user/changePassword",
          { password: result },
          {
            headers: {
              Authorization: token,
            },
          }
        )
        .then((res) => {
          
          toast({
            title: "密码修改成功",
            description: "即将跳转到登录页面，请重新登录",
          });
          localStorage.removeItem("token");
          setTimeout(()=>router.push('/login/signin'),3000);
        });
    } catch (error) {
      toast({
        title: "密码格式错误",
        description: "密码不少于6位,请重新输入!",
      });
    }
  }

}
</script>

<template>
  <div class="main flex flex-row items-center justify-center w-full h-full">
    <div class="w-2/3 h-full flex flex-col">
      <div class="left flex flex-row h-1/5 items-center justify-center mt-16">
        <Avatar
          class="w-32 h-32 animate-bounce animate-once animate-duration-1000 shadow-xl block"
        >
          <AvatarImage
            src="https://y4705w2671.oicp.vip/static/imgs/avatar/avatar.JPG"
            alt="@radix-vue"
          />
          <AvatarFallback>CN</AvatarFallback>
        </Avatar>

        <div class="name w-1/3 flex flex-row">
          <div class="flex flex-col flex-1">
            <h2 class="text-2xl ml-10 font-semibold">
              {{ UserInfo.user_name }}
            </h2>
            <h2 class="ml-10">欢迎您！</h2>
          </div>
        </div>
      </div>
      <div class="right font-customfont h-1/2 flex flex-col w-full mt-8">
        <div class="coords flex-1 flex items-center justify-center">
          <div class="item flex-1 items-center justify-center flex flex-col">
            <div class="font-semibold w-2/3">
              <span class="ml-4 text-lg w-2/3">用户ID:</span>
            </div>
            <Input
              :placeholder="`Number ${UserInfo.id}`"
              disabled
              class="w-2/3 placeholder:text-slate-950 disabled:bg-slate-200 mt-1"
            ></Input>
          </div>
          <div class="item flex-1 items-center justify-center flex flex-col">
            <div class="font-semibold w-2/3">
              <span class="ml-4 text-lg w-2/3">用户等级:</span>
            </div>
            <Input
              :placeholder="`Level ${UserInfo.grade}`"
              disabled
              class="w-2/3 placeholder:text-slate-950 disabled:bg-slate-200 mt-1"
            ></Input>
          </div>
        </div>
        <div class="coords flex-1 flex items-center justify-center">
          <div class="item flex-1 items-center justify-center flex flex-col">
            <div class="font-semibold w-2/3">
              <span class="ml-4 text-lg w-2/3">邮箱地址:</span>
              <n-switch class="ml-24" v-model:value="emailActive">
                <template #checked> 修改信息ing </template>
                <template #unchecked> 修改信息 </template>
              </n-switch>
            </div>
            <Input
              :placeholder="`${UserInfo.email}`"
              class="w-2/3 placeholder:text-slate-950 disabled:bg-slate-200 mt-1"
              :disabled="!emailActive"
              v-model="Uemail"
            ></Input>
          </div>
          <div class="item flex-1 items-center justify-center flex flex-col">
            <div class="font-semibold w-2/3">
              <span class="ml-4 text-lg w-2/3">密码:</span>
              <n-switch class="ml-24" v-model:value="pwActive">
                <template #checked> 修改信息ing </template>
                <template #unchecked> 修改信息 </template>
              </n-switch>
            </div>
            <Input
              class="w-2/3 placeholder:text-slate-950 disabled:bg-slate-200 mt-1"
              type="password"
              :disabled="!pwActive"
              v-model="Upassword"
            ></Input>
          </div>
        </div>
        <div class="flex-1 flex w-full items-center justify-center">
          <Button
            @click="changedInfo"
            :disabled="!pwActive && !emailActive"
            class="w-1/2"
            >提交</Button
          >
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
