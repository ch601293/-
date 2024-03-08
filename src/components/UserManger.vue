<template>
  <div class="h-full overflow-y-auto w-[85vw]  ml-4">
    <div class="flex flex-row-reverse">
      <div class="h-[50px] mt-4 w-1/3">
        <n-input
          round
          placeholder="搜索"
          @keydown="searchUser"
          v-model:value="searchedUserName"
        >
          <template #suffix>
            <n-icon>
              <svg
                t="1707389938220"
                class="icon"
                viewBox="0 0 1024 1024"
                version="1.1"
                xmlns="http://www.w3.org/2000/svg"
                p-id="7474"
                width="200"
                height="200"
              >
                <path
                  d="M666.428952 121.904762a48.761905 48.761905 0 0 1 45.007238 67.535238l-79.652571 190.902857h130.364952a48.761905 48.761905 0 0 1 37.936762 79.408762L450.096762 893.415619a48.761905 48.761905 0 0 1-85.74781-40.252952l46.567619-231.277715h-156.696381a48.761905 48.761905 0 0 1-45.104761-67.291428l165.180952-402.432A48.761905 48.761905 0 0 1 419.401143 121.904762h247.027809z m-230.66819 73.142857l-145.188572 353.694476h209.700572l-44.568381 221.232762 255.439238-316.464762H521.99619L629.833143 195.047619h-194.072381z"
                  p-id="7475"
                ></path>
              </svg>
            </n-icon>
          </template>
        </n-input>
      </div>
    </div>

    <n-data-table :columns="columns" :data="data" :max-height="530" />
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
      title="调整用户权限等级"
      @positive-click="onPositiveClick"
      @negative-click="onNegativeClick"
    >
      <div class="flex w-full flex-row">
        <div class="flex-1 mr-4">
          <Label for="email">当前权限等级：</Label>
          <Input id="email" type="text" :placeholder="gardeValue" disabled />
        </div>
        <div class="flex-1">
          <div class="mb-1">选择权限等级：</div>
          <n-select v-model:value="currentLevel" :options="options" />
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
</template>
<script setup>
import axios from "axios";
import { ref, onMounted, watch, h ,computed} from "vue";
import { Label } from "./ui/label";
import { Input } from "./ui/input";
import {
  NDataTable,
  NPagination,
  NInput,
  NIcon,
  NButton,
  NModal,
  NSelect,
} from "naive-ui";
import { Avatar, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { useMutation } from "@tanstack/vue-query";
import { useMessage } from "naive-ui";
import { currentGrade } from "../assets/stores/store";
const grade = currentGrade();
const message = useMessage();
const token = localStorage.getItem("token");
const data = ref([]);
const columns = ref([]);
const gardeValue = ref(0);
const page = ref(1);
const pageSize = ref(10);
const showModal = ref(false);
const currentLevel = ref(1);
const currentUser = ref({});
const searchedUserName = ref("");
const userNumber = ref(0);
const pageLength = computed(() => {
  return Math.ceil(userNumber.value/pageSize.value);
})
onMounted(() => {
  axios
    .get("https://y4705w2671.oicp.vip/api/v1/user/getUserCount", {
      headers: {
        Authorization: token,
      },
    })
    .then((res) => {
      userNumber.value = res.data.data;
    });
})
const searchUser = (e) => {
  if (e.code === "Enter") {
    axios
      .post(
        "https://y4705w2671.oicp.vip/api/v1/user/findUsers",
        {
          username: searchedUserName.value,
        },
        {
          headers: {
            Authorization: token,
          },
        }
      )
      .then((res) => {
        console.log(res);
        data.value = [res.data.data];
      })
      .catch((e) => {
        message.error("获取用户信息错误");
      });
  }
};
const getUser = () => {
  axios
    .post(
      "https://y4705w2671.oicp.vip/api/v1/user/findUsers",
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
      const midData = res.data.data;
      data.value = midData.filter((data) => {
        return data.id == grade.id ? false : true;
      });
    })
    .catch((e) => {
      message.error("获取用户信息错误");
    });
};

const { isPending: gradeLoding, mutateAsync: changeGrade } = useMutation({
  mutationFn: () =>
    axios.post(
      "https://y4705w2671.oicp.vip/api/v1/user/updateUserGrade",
      { id: currentUser.value.id, grade: currentLevel.value },
      {
        headers: {
          Authorization: token,
        },
      }
    ),
  retryDelay: 5000,
});
const { isPending: deleteLoding, mutateAsync: deleteUser } = useMutation({
  mutationFn: () =>
    axios.post(
      "https://y4705w2671.oicp.vip/api/v1/user/deleteUser",
      { id: currentUser.value.id },
      {
        headers: {
          Authorization: token,
        },
      }
    ),
  onSuccess: (data) => {
    message.success("删除成功！");
  },
  retryDelay: 5000,
});
watch(gradeLoding, (newValue, oldValue) => {
  if (newValue === true && oldValue === false) {
    message.loading("正在修改中！", { duration: 1000 });
  }
});
watch(deleteLoding, (newValue, oldValue) => {
  if (newValue === true && oldValue === false) {
    message.loading("正在删除中！", { duration: 1000 });
  }
});
const options = ref([
  {
    label: "level 1",
    value: 1,
  },
  {
    label: "level 2",
    value: 2,
  },
  {
    label: "level 3",
    value: 3,
  },
  {
    label: "level 4",
    value: 4,
  },
]);
const onNegativeClick = () => {
  showModal.value = false;
};
const onPositiveClick = () => {
  changeGrade()
    .then((res) => {
      if (res.data.msg == "ok") {
        message.success("修改成功！");
        getUser();
      }
    })
    .catch((error) => {
      message.error("修改错误！");
    });
  showModal.value = false;
};
watch(page, async (newPage) => {
  getUser();
});
axios
  .post(
    "https://y4705w2671.oicp.vip/api/v1/user/findUsers",
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
    const midData = res.data.data;
    data.value = midData.filter((data) => {
      return data.id == grade.id ? false : true;
    });
    const obj = res.data.data[0];
    for (let i of Object.getOwnPropertyNames(obj)) {
      columns.value.push({
        title: i,
        key: i,
      });
    }
    columns.value.unshift({
      title: "Avater",
      key: "Avater",
      render(row) {
        return h(
          Avatar,
          {
            class:
              "w-16 h-16 hover:animate-bounce hover:animate-once hover:animate-duration-1000 shadow-xl block",
          },
          () => [
            h(AvatarImage, {
              src: "https://github.com/radix-vue.png",
              alt: "@radix-vue",
            }),
          ]
        );
      },
    });
    columns.value.push({
      title: "编辑",
      key: "编辑",
      render(row) {
        return h(
          Button,
          {
            variant: "secondary",
            onClick: () => {
              showModal.value = true;
              gardeValue.value = row.grade;
              currentUser.value = row;
            },
          },
          { default: () => "编辑" }
        );
      },
    });
    columns.value.push({
      title: "删除",
      key: "删除",
      render(row) {
        return h(
          Button,
          {
            class: "text-red-500",
            variant: "secondary",
            onClick: () => {
              currentUser.value = row;
              deleteUser().then((res) => {
                console.log(res, 111);
                if (res.data.msg === "ok") {
                }
                getUser();
              });
            },
          },
          { default: () => "删除" }
        );
      },
    });
  });
</script>
<style scoped>
.n-button {
  --n-text-color: #000 !important;
}
</style>
