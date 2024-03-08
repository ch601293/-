<template>
  <div class="con w-[15%] flex flex-col border-r-4 divide-y divide-dashed">
    <div class="font-medium text-3xl h-36 flex items-center">
      <img src="../assets//logo/logo.svg" alt="" class="rounded-full">
    </div>
    <div
      class="flex-row group griditem flex-1 flex w-full items-center focus:bg-slate-500"
      tabindex="0"
      @click="toUserMessage"
    >
      <n-icon size="40" class="ml-5 group-hover:animate-jump group-hover:animate-once group-hover:animate-duration-1000">
        <svg
          t="1705324266342"
          class="icon"
          viewBox="0 0 1024 1024"
          version="1.1"
          xmlns="http://www.w3.org/2000/svg"
          p-id="1013"
          width="200"
          height="200"
        >
          <path
            d="M667.955 74H175.55C121.67 74 78 117.69 78 171.575v697.85C78 923.312 121.671 967 175.55 967h553.955c19.883 0 36-16.118 36-36V171.575c0-53.886-43.67-97.575-97.55-97.575z m0.422 72c13.914 0.23 25.128 11.588 25.128 25.575V895H175.551C161.442 895 150 883.553 150 869.425v-697.85C150 157.447 161.443 146 175.55 146h492.827z"
            p-id="1014"
            fill="#000"
          ></path>
          <path
            d="M852.802 442.912h-82.198c-42.58 0-77.099 34.518-77.099 77.099V931c0 19.882 16.118 36 36 36h102.748c53.93 0 97.648-43.718 97.648-97.648V520.01c0-42.581-34.518-77.1-77.099-77.1z m0 72a5.098 5.098 0 0 1 5.1 5.099v349.34l-0.004 0.425c-0.227 13.97-11.62 25.224-25.645 25.224h-66.748V520.01a5.098 5.098 0 0 1 5.1-5.098h82.197z"
            p-id="1015"
            fill="#000"
          ></path>
          <path
            d="M407 296.5c19.882 0 36 16.118 36 36s-16.118 36-36 36H239c-19.882 0-36-16.118-36-36s16.118-36 36-36h168zM490 442.5c19.882 0 36 16.118 36 36s-16.118 36-36 36H239c-19.882 0-36-16.118-36-36s16.118-36 36-36h251z"
            p-id="1016"
            fill="#ED6D0F"
          ></path>
        </svg>
      </n-icon>
      <div
        class="content text-slate-500 group-hover:text-teal-500 flex-1 text-center text-xl group-focus:text-teal-500"
      >
        用户信息
      </div>
      <div
        class="overflow-hidden h-full line w-0 rounded-l-lg group-hover:w-3 bg-rose-400 group-focus:w-3"
      ></div>
    </div>

    <div
      class="flex-row group griditem flex-1 flex w-full items-center focus:bg-slate-500"
      tabindex="0"
      @click="toUpload"
    >
      <n-icon size="40" class="ml-5 group-hover:animate-jump group-hover:animate-once group-hover:animate-duration-1000">
        <svg
          t="1705325045119"
          class="icon"
          viewBox="0 0 1024 1024"
          version="1.1"
          xmlns="http://www.w3.org/2000/svg"
          p-id="1161"
          width="200"
          height="200"
        >
          <path
            d="M774 130H258c-86.156 0-156 69.844-156 156v485c0 86.156 69.844 156 156 156h516c86.156 0 156-69.844 156-156V286c0-86.156-69.844-156-156-156z m0 72c46.392 0 84 37.608 84 84v485c0 46.392-37.608 84-84 84H258c-46.392 0-84-37.608-84-84V286c0-46.392 37.608-84 84-84h516z"
            p-id="1162"
            fill="#000"
          ></path>
          <path
            d="M340.515 91.514c19.882 0 36 16.118 36 36v114c0 19.882-16.118 36-36 36s-36-16.118-36-36v-114c0-19.882 16.118-36 36-36zM682.515 91.514c19.882 0 36 16.118 36 36v114c0 19.882-16.118 36-36 36s-36-16.118-36-36v-114c0-19.882 16.118-36 36-36zM894 320.655c19.882 0 36 16.118 36 36 0 19.883-16.118 36-36 36H138c-19.882 0-36-16.117-36-36 0-19.882 16.118-36 36-36h756z"
            p-id="1163"
            fill="#000"
          ></path>
          <path
            d="M651.311 475.544c14.06-14.059 36.853-14.059 50.912 0 14.059 14.059 14.059 36.853 0 50.912L509.817 718.862c-14.059 14.059-36.853 14.059-50.912 0L342.545 602.5c-14.06-14.06-14.06-36.853 0-50.912 14.058-14.06 36.852-14.06 50.91 0l90.906 90.905 166.95-166.95z"
            fill="#ED6D0F"
            p-id="1164"
          ></path>
        </svg>
      </n-icon>
      <div
        class="content text-slate-500 group-hover:text-teal-500 flex-1 text-center text-xl group-focus:text-teal-500"
      >
        上传数据
      </div>
      <div
        class="overflow-hidden h-full rounded-l-lg line w-0 group-hover:w-3 bg-rose-400 group-focus:w-3"
      ></div>
    </div>
    <div
      class="flex-row group griditem flex-1 flex w-full items-center focus:bg-slate-500"
      tabindex="0"
      @click="toDataLoder"
    >
      <n-icon size="40" class="ml-5 group-hover:animate-jump group-hover:animate-once group-hover:animate-duration-1000">
        <svg
          t="1705327028468"
          class="icon"
          viewBox="0 0 1024 1024"
          version="1.1"
          xmlns="http://www.w3.org/2000/svg"
          p-id="1311"
          width="200"
          height="200"
        >
          <path
            d="M705 96c86.156 0 156 69.844 156 156v164.614c0 19.882-16.118 36-36 36s-36-16.118-36-36V252c0-46.392-37.608-84-84-84H320c-46.392 0-84 37.608-84 84v520c0 46.392 37.608 84 84 84h128.727c19.882 0 36 16.118 36 36s-16.118 36-36 36H320c-86.156 0-156-69.844-156-156V252c0-86.156 69.844-156 156-156h385z"
            p-id="1312"
            fill="#000"
          ></path>
          <path
            d="M683 315.5c19.882 0 36 16.118 36 36s-16.118 36-36 36H341c-19.882 0-36-16.118-36-36s16.118-36 36-36h342zM341.122 545.5l141.74 0.479c19.883 0.067 35.946 16.239 35.879 36.121-0.067 19.882-16.24 35.946-36.122 35.879l-141.74-0.48c-19.883-0.066-35.946-16.238-35.879-36.12 0.067-19.883 16.24-35.946 36.122-35.879z"
            p-id="1313"
            fill="#000"
          ></path>
          <path
            d="M938.623 526.987c-47.84-47.84-125.402-47.84-173.241 0L547.04 745.327a36 36 0 0 0-10.543 25.831l1.26 121.07c0.203 19.59 16.034 35.42 35.623 35.624l121.07 1.26a36 36 0 0 0 25.83-10.543l218.342-218.341c47.84-47.84 47.84-125.402 0-173.241z m-50.912 50.911l0.586 0.596c19.134 19.764 18.938 51.298-0.586 70.822l-207.64 207.64-70.684-0.735-0.735-70.681 207.641-207.642c19.722-19.721 51.697-19.721 71.418 0z"
            fill="#ED6D0F"
            p-id="1314"
          ></path>
        </svg>
      </n-icon>
      <div
        class="content text-slate-500 group-hover:text-teal-500 flex-1 text-center text-xl group-focus:text-teal-500"
      >
        查询数据
      </div>
      <div
        class="overflow-hidden h-full line w-0 rounded-l-lg group-hover:w-3 bg-rose-400 group-focus:w-3"
      ></div>
    </div>
    <div
      class="flex-row focus:bg-slate-500 group griditem flex-1 flex w-full items-center"
      tabindex="0"
      v-show="visableUserManger"
      @click="toUserManger"
    >
      <n-icon size="40" class="ml-5 group-hover:animate-jump group-hover:animate-once group-hover:animate-duration-1000">
        <svg
          t="1705324266342"
          class="icon"
          viewBox="0 0 1024 1024"
          version="1.1"
          xmlns="http://www.w3.org/2000/svg"
          p-id="1013"
          width="200"
          height="200"
        >
          <path
            d="M667.955 74H175.55C121.67 74 78 117.69 78 171.575v697.85C78 923.312 121.671 967 175.55 967h553.955c19.883 0 36-16.118 36-36V171.575c0-53.886-43.67-97.575-97.55-97.575z m0.422 72c13.914 0.23 25.128 11.588 25.128 25.575V895H175.551C161.442 895 150 883.553 150 869.425v-697.85C150 157.447 161.443 146 175.55 146h492.827z"
            p-id="1014"
            fill="#000"
          ></path>
          <path
            d="M852.802 442.912h-82.198c-42.58 0-77.099 34.518-77.099 77.099V931c0 19.882 16.118 36 36 36h102.748c53.93 0 97.648-43.718 97.648-97.648V520.01c0-42.581-34.518-77.1-77.099-77.1z m0 72a5.098 5.098 0 0 1 5.1 5.099v349.34l-0.004 0.425c-0.227 13.97-11.62 25.224-25.645 25.224h-66.748V520.01a5.098 5.098 0 0 1 5.1-5.098h82.197z"
            p-id="1015"
            fill="#000"
          ></path>
          <path
            d="M407 296.5c19.882 0 36 16.118 36 36s-16.118 36-36 36H239c-19.882 0-36-16.118-36-36s16.118-36 36-36h168zM490 442.5c19.882 0 36 16.118 36 36s-16.118 36-36 36H239c-19.882 0-36-16.118-36-36s16.118-36 36-36h251z"
            p-id="1016"
            fill="#ED6D0F"
          ></path>
        </svg>
      </n-icon>
      <div
        class="content text-slate-500 group-hover:text-teal-500 flex-1 text-center text-xl group-focus:text-teal-500"
        tabindex="0"
      >
        用户管理
      </div>
      <div
        class="overflow-hidden h-full line w-0 rounded-l-lg group-hover:w-3 bg-rose-400 group-focus:w-3 "
      ></div>
    </div>
    <div
      class="flex-row group griditem flex-1 flex w-full items-center focus:bg-slate-500"
      tabindex="0"
      @click="toDataReview"
      v-show="visableDataReview "
    >
      <n-icon size="40" class="ml-5 group-hover:animate-jump group-hover:animate-once group-hover:animate-duration-1000">
        <svg
          t="1705324266342"
          class="icon"
          viewBox="0 0 1024 1024"
          version="1.1"
          xmlns="http://www.w3.org/2000/svg"
          p-id="1013"
          width="200"
          height="200"
        >
          <path
            d="M667.955 74H175.55C121.67 74 78 117.69 78 171.575v697.85C78 923.312 121.671 967 175.55 967h553.955c19.883 0 36-16.118 36-36V171.575c0-53.886-43.67-97.575-97.55-97.575z m0.422 72c13.914 0.23 25.128 11.588 25.128 25.575V895H175.551C161.442 895 150 883.553 150 869.425v-697.85C150 157.447 161.443 146 175.55 146h492.827z"
            p-id="1014"
            fill="#000"
          ></path>
          <path
            d="M852.802 442.912h-82.198c-42.58 0-77.099 34.518-77.099 77.099V931c0 19.882 16.118 36 36 36h102.748c53.93 0 97.648-43.718 97.648-97.648V520.01c0-42.581-34.518-77.1-77.099-77.1z m0 72a5.098 5.098 0 0 1 5.1 5.099v349.34l-0.004 0.425c-0.227 13.97-11.62 25.224-25.645 25.224h-66.748V520.01a5.098 5.098 0 0 1 5.1-5.098h82.197z"
            p-id="1015"
            fill="#000"
          ></path>
          <path
            d="M407 296.5c19.882 0 36 16.118 36 36s-16.118 36-36 36H239c-19.882 0-36-16.118-36-36s16.118-36 36-36h168zM490 442.5c19.882 0 36 16.118 36 36s-16.118 36-36 36H239c-19.882 0-36-16.118-36-36s16.118-36 36-36h251z"
            p-id="1016"
            fill="#ED6D0F"
          ></path>
        </svg>
      </n-icon>
      <div
        class="content text-slate-500 group-hover:text-teal-500 flex-1 text-center text-xl group-focus:text-teal-500"
      >
        数据审核
      </div>
      <div
        class="overflow-hidden h-full line w-0 rounded-l-lg group-hover:w-3 bg-rose-400 group-focus:w-3"
      ></div>
    </div>
  </div>
</template>
<script setup>
import { NIcon } from "naive-ui";
import { useRouter } from "vue-router";
import { currentGrade } from '../assets/stores/store';
import { computed } from 'vue';
const router = useRouter();
const grade = currentGrade();
function toUserMessage() {
  router.push("/center");
}
function toUpload() {
  router.push("/center/upload");
}
function toDataLoder() {
  router.push("/center/dataloder");
}
function toUserManger() {
  router.push("/center/usermanger");
}
function toDataReview(){
  router.push("/center/datareview");
}
const visableUserManger = computed(()=>{
  return  grade.grade >= 4 ? true: false;
});
const visableDataReview = computed(()=>{
  return  grade.grade >= 3 ? true: false;
});
</script>

