<template>
  <div
    class="h-full overflow-y-auto w-[85vw] overflow-x-scroll ml-4"
    v-if="!resultShow"
  >
    <div class="flex flex-row-reverse">
      <div class="h-[50px] mt-4 w-1/3 flex justify-end flex-row pr-7">
        <n-badge :value="num">
          <Button @click="changeModel" class="rounded-full w-32">提交</Button>
        </n-badge>
      </div>
    </div>

    <n-data-table
      :columns="columns"
      :data="data"
      :max-height="530"
      class="w-[200vw]"
      :row-key="rowKey"
      @update:checked-row-keys="handleCheck"
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
    <n-modal
      v-model:show="showModal"
      :mask-closable="false"
      preset="dialog"
      title="请再次确认审核通过的数据对应ID"
      @positive-click="onPositiveClick"
      @negative-click="onNegativeClick"
    >
      <div class="flex w-full flex-row">
        <div class="flex-1 mr-4 flex-row justify-center items-center flex-wrap">
          <n-tag
            type="success"
            v-for="id in checkedRowKeys"
            :key="id"
            size="large"
            round
            class="mx-3"
            >{{ id }}
          </n-tag>
        </div>
      </div>
      <template #action>
        <div>
          <Button variant="secondary" class="mr-3" @click="onNegativeClick"
            >取消</Button
          >
          <Button variant="secondary" @click="onPositiveClick">提交</Button>
        </div>
      </template>
    </n-modal>
  </div>
  <div v-else class="h-full w-full flex justify-center items-center ">
    <n-result
      status="404"
      title="暂无审核数据"
      description="快去上传吧"
      class="h-1/2 w-full"
      size="huge"
    >
    </n-result>
  </div>
</template>
<script setup>
import axios from "axios";
import { ref, onMounted, watch, computed } from "vue";
import {
  NDataTable,
  NPagination,
  NInput,
  NIcon,
  NModal,
  NBadge,
  NTag,
  NResult,
} from "naive-ui";
import { Button } from "./ui/button";
import { useToast } from "@/components/ui/toast/use-toast";
const token = localStorage.getItem("token");
const checkedRowKeys = ref([]);
const data = ref([]);
const columns = ref([]);
const rowKey = (row) => row.ID;
const page = ref(1);
const pageSize = ref(10);
const recordNum = ref(0);
const showModal = ref(false);
const { toast } = useToast();
function handleCheck(rowKeys) {
  checkedRowKeys.value = rowKeys;
}
const resultShow = ref(false);
const changeModel = () => {
  showModal.value = !showModal.value;
};
const num = computed(() => {
  return checkedRowKeys.value?.length;
});
const pageLength = computed(() => {
  return Math.ceil(recordNum.value / pageSize.value);
});
const onNegativeClick = () => {
  showModal.value = false;
};
const onPositiveClick = () => {
  axios
    .post(
      "https://y4705w2671.oicp.vip/api/v1/record/review",
      { reviewedRecords: checkedRowKeys.value.join(",") },
      {
        headers: {
          Authorization: token,
        },
      }
    )
    .then((res) => {
      console.log(res);
      if (res.data.status === 200) {
        toast({
          title: "成功",
          description: "审核提交成功",
        });
        showModal.value = !showModal.value;
      } else throw Error;
    })
    .catch((error) => {
      toast({
        title: "错误",
        description: "审核提交失败！",
      });
    });
};
onMounted(() => {
  axios
    .get("https://y4705w2671.oicp.vip/api/v1/record/getURecordCount", {
      headers: {
        Authorization: token,
      },
    })
    .then((res) => {
      recordNum.value = res.data.data;
    });
});
watch(page, async (newPage) => {
  console.log(newPage);
  const res = await axios.get(
    "https://y4705w2671.oicp.vip/api/v1/record/getURecord",
    {
      headers: {
        Authorization: token,
      },
    }
  );
  console.log(res)
  data.value = res.data.data;
});
axios
  .get("https://y4705w2671.oicp.vip/api/v1/record/getURecord", {
    headers: {
      Authorization: token,
    },
    data: JSON.stringify({
      page: page.value,
      size: pageSize.value,
    }),
  })
  .then((res) => {
    if (res.data.data.length == 0) {
      resultShow.value = true;
      return;
    }
    data.value = res.data.data;
    const obj = res.data.data[0];
    if (res.data.data)
      columns.value.push({
        type: "selection",
      });
    for (let i of Object.getOwnPropertyNames(obj)) {
      columns.value.push({
        title: i,
        key: i,
      });
    }
  });
</script>
<style scoped></style>
