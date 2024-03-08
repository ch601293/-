<template>
  <div class="w-2/3 h-2/3 ml-72 shadow-2xl mt-16">
    <div class="h-1/2">
      <div
        class="text-2xl ml-10 font-semibold h-24 text-center mt-10 flex justify-center items-center"
      >
        <span class="flex">数据上传流程</span>
      </div>
      <div class="h-1/2 mt-10">
        <n-steps v-model:current="current" class="h-1/2">
          <n-step title="准备文件" >
            <div>本页面仅上传.xlsx格式的文件，同时文件需要满足一定格式</div>
            <div class="flex flex-row-reverse">
              <a href="/testRecord.xlsx" download class="text-blue-600"
              >点击下载样本文件</a
            >
            </div>

          </n-step>
          <n-step title="上传文件" description="点击或者拖入文件进入下方区域" />
          <n-step
            title="审核文件"
            description="1级和2用户上传文件后需高权限用户进行审核，3级和4级用户则不用审核"
          />
          <n-step title="审核完毕" description="将数据纳入数据库" />
        </n-steps>
      </div>
    </div>
    <div class="h-1/2">
      <n-upload
        multiple
        directory-dnd
        action="https://y4705w2671.oicp.vip/api/v1/record/uploadByExcel"
        list-type="image"
        :max="1"
        :custom-request="customRequest"
        class="mt-20"
      >
        <n-upload-dragger>
          <div style="margin-bottom: 12px">
            <n-icon size="48" :depth="3">
              <svg
                t="1705805786607"
                class="icon"
                viewBox="0 0 1024 1024"
                version="1.1"
                xmlns="http://www.w3.org/2000/svg"
                p-id="2822"
                width="200"
                height="200"
              >
                <path
                  d="M565.333333 779.914667l51.445334-54.912a31.733333 31.733333 0 0 1 45.226666-1.226667 32.64 32.64 0 0 1 1.216 45.770667l-97.418666 104a37.034667 37.034667 0 0 1-52.821334 1.397333l-108.362666-104.202667a32.64 32.64 0 0 1-1.152-45.770666 31.733333 31.733333 0 0 1 45.248-1.173334L501.333333 774.421333V512.074667c0-17.877333 14.325333-32.373333 32-32.373334s32 14.506667 32 32.373334v267.84zM512 138.666667c123.018667 0 228.213333 86.709333 259.424 206.88C864.298667 347.146667 938.666667 426.090667 938.666667 522.688c0 97.6-75.914667 177.173333-170.133334 177.173333-17.674667 0-32-14.496-32-32.373333 0-17.877333 14.325333-32.373333 32-32.373333 58.357333 0 106.133333-50.08 106.133334-112.426667 0-62.336-47.776-112.416-106.133334-112.416-5.856 0-11.626667 0.501333-17.301333 1.482667-17.621333 3.050667-34.304-9.098667-37.024-26.986667C698.346667 280.693333 612.714667 203.424 512 203.424c-73.834667 0-140.928 41.536-177.376 107.861333a31.914667 31.914667 0 0 1-30.122667 16.576 140.373333 140.373333 0 0 0-9.568-0.32c-80.149333 0-145.6 68.586667-145.6 153.781334 0 85.184 65.450667 153.792 145.6 153.792 17.674667 0 32 14.496 32 32.373333 0 17.877333-14.325333 32.373333-32 32.373333C178.912 699.861333 85.333333 601.770667 85.333333 481.322667c0-118.314667 90.293333-215.061333 203.456-218.453334C338.090667 186.24 421.013333 138.666667 512 138.666667z"
                  fill="#000000"
                  p-id="2823"
                ></path>
              </svg>
            </n-icon>
          </div>
          <n-text style="font-size: 16px">
            点击或者拖动文件到该区域来上传
          </n-text>
          <n-p depth="3" style="margin: 8px 0 0 0"> 最多上传1个文件 </n-p>
        </n-upload-dragger>
      </n-upload>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import {
  NText,
  NUploadDragger,
  NUpload,
  NIcon,
  NP,
  useMessage,
  NSteps,
  NStep,
} from "naive-ui";
import axios from "axios";
const token = localStorage.getItem("token");
const message = useMessage();
const current = ref(1);
const customRequest = ({
  file,
  data,
  headers,
  withCredentials,
  action,
  onFinish,
  onError,
  onProgress,
}) => {
  const formData = new FormData();
  if (data) {
    Object.keys(data).forEach((key) => {
      formData.append(key, data[key]);
    });
  }
  formData.append("file", file.file);
  axios
    .post(action, formData, {
      headers: {
        Authorization: token,
        "Content-Type": "multipart/form-data",
      },
    })
    .then((res) => {
      message.success(JSON.stringify(res.data.data));
    })
    .catch((error) => {
      message.error("文件上传失败,请详细阅读文件要求重新上传");
    });
};
</script>
