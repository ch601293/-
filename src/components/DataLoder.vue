<template>
  <div class="h-full">
    <div class="h-full  overflow-x-scroll ml-4">
      <h2 class="w-full text-center font-customfont h-[80px] font-bold text-3xl leading-[70px]">数据总览</h2>
      <div class="flex flex-row bg-slate-300">
        
        <div class="h-[50px] mt-4 w-1/3">
          <h2>条件筛选</h2>
        </div>
      </div>
      <div class="overflow-y-auto w-[85vw]">
        <n-data-table
        :columns="columns"
        :data="data"
        :max-height="530"
        class="w-[200vw]"
      />
      <n-pagination
        v-model:page="page"
        v-model:page-size="pageSize"
        :page-count="pageLength"
        size="large"
        show-quick-jumper
        show-size-picker
        class="absolute bottom-0 right-0 mb-5"
      />
      </div>

    </div>
  </div>
</template>
<script setup>
import axios from "axios";
import { ref, onMounted, watch, computed } from "vue";
import { NDataTable, NPagination, NInput, NIcon } from "naive-ui";
import PostForm  from './PostForm.vue'
const token = localStorage.getItem("token");
const data = ref([]);
const columns = ref([]);

const page = ref(1);
const pageSize = ref(10);
const recordNum = ref(0);
const pageLength = computed(() => {
  return Math.ceil(recordNum.value / pageSize.value);
});
onMounted(() => {
  axios
    .post(
      "https://y4705w2671.oicp.vip/api/v1/record/getRecordCount",
      {},
      {
        headers: {
          Authorization: token,
        },
      }
    )
    .then((res) => {
      recordNum.value = res.data.data;
    });
});
watch(page, async (newPage) => {
  console.log(newPage);
  const res = await axios.post(
    "https://y4705w2671.oicp.vip/api/v1/record/getRecord",
    {
      page: newPage,
      size: 10,
    },
    {
      headers: {
        Authorization: token,
      },
    }
  );
  data.value = res.data.data;
});
axios
  .post(
    "https://y4705w2671.oicp.vip/api/v1/record/getRecord",
    {
      page: page.value,
      size: pageSize.value,
    },
    {
      headers: {
        Authorization: token,
      },
    }
  )
  .then((res) => {
    data.value = res.data.data;
    const obj = res.data.data[0];
    for (let i of Object.getOwnPropertyNames(obj)) {
      columns.value.push({
        title: i,
        key: i,
      });
    }
  });
</script>
<style scoped></style>
