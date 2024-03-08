<script setup>
import { useForm } from "vee-validate";
import { toTypedSchema } from "@vee-validate/zod";
import * as z from "zod";
import { useToast } from "@/components/ui/toast/use-toast";
import { Button } from "@/components/ui/button";
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import {  useMutation } from '@tanstack/vue-query';
import axios from "axios";
import { useRouter } from "vue-router";
import { ToastAction } from '@/components/ui/toast'
const router = useRouter();
const formSchema = toTypedSchema(
  z.object({
    username: z
      .string()
      .min(2, { message: "姓名不小于2位,请重新输入!" })
      .max(10),
    password: z.string().min(6, { message: "密码不少于6位,请重新输入!" }),
  })
);
const { toast } = useToast();
const form = useForm({
  validationSchema: formSchema,
});
const { isLoading, isError, error, isSuccess, mutateAsync  } = useMutation({
  mutationFn: (newUser) =>
    axios.post("https://y4705w2671.oicp.vip/api/v1/user/login", newUser)
});
const onSubmit = form.handleSubmit((values) => {
  mutateAsync(values).then((res)=>{
    if(res.data.status==200){
        localStorage.setItem('token',res.data.data.token);
        toast({
          title: "登录成功",
          description: "即将跳转到用户中心页面！",
        });
        setTimeout(() => {
          router.push("/center");
        }, 3000);
    }
    
  });

});
</script>

<template>
  <div
    class="flex-1 flex backdrop-blur-sm bg-white/30 h-full shadow-inner justify-center items-center animate-fade-left animate-once animate-duration-[2000ms]"
  >
    <form @submit="onSubmit" class="w-1/2">
      <FormField v-slot="{ componentField }" name="username" class="mb-5">
        <FormItem>
          <FormLabel class="text-lg font-bold">用户名</FormLabel>
          <FormControl>
            <Input type="text" v-bind="componentField" />
          </FormControl>
          <FormMessage />
        </FormItem>
      </FormField>
      <FormField v-slot="{ componentField }" name="password">
        <FormItem>
          <FormLabel class="text-lg font-bold">密码</FormLabel>
          <FormControl>
            <Input type="password" v-bind="componentField" />
          </FormControl>
          <FormMessage />
        </FormItem>
      </FormField>
      <Button type="submit" class="shad-button_primary mt-9 w-full">
        <div v-if="isLoading">
          <img src="../assets/logo/loader.svg" />
          Loding...
        </div>
        <div v-else>登录</div>
      </Button>
      <p className="text-small-regular text-light-2 mt-2 text-right">
        还没有帐户?
        <router-link
          to="login/signup"
          className="text-primary-500 text-small-semibold ml-3"
          >注册</router-link
        >
      </p>
    </form>
  </div>
  </template>