<script setup>
import Mymap from '../components/Mymap.vue';
import { NCard, NDivider, NInput, NDataTable, NIcon } from 'naive-ui';
import axios from 'axios';
import { ref } from 'vue'
const d = ref('');
const tData = ref([]);
const tableDataChange = (data)=>{
  tData.value = data;
};
axios.post('https://y4705w2671.oicp.vip/api/v1/record/getByArea', {
    province: '',
    city: ''
  }).then((res) => {
    d.value = res.data.data;
    tData.value = Object.keys(d.value)
      .map((key) => {
        return {
          area: key,
          speciesNum: d.value[key]['speciesNum'],
          recordNum: d.value[key]['recordNum']
        }
      });
  }).catch(e=>{
    console.log(e)
  });

const maxheight = ref(window.innerHeight * (45 / 100));
const areaname = ref(
  {
    title: "地区名称",
    key: "area",
    filterMultiple: false,
    filterOptionValue: null,
    filter(value, row) {
      return !!~row.area.indexOf(value.toString());
    }
  }
)
const columns = ref([
  areaname.value,
  {
    title: "鸟类种数",
    key: "speciesNum",
    sorter: (row1, row2) => row1.speciesNum - row2.speciesNum,
  },
  {
    title: "记录数量",
    key: "recordNum"
  }
]);
function search(v) {
  if (v == "") {
    areaname.value.filterOptionValue = null;
  }
  else {
    areaname.value.filterOptionValue = v;
  }
}
function handleUpdateFilter(filters, sourceColumn) {
  addressColumn.filterOptionValue = filters[sourceColumn.key];
}
</script>
<template>
    <div class="midContiner  animate-fade-down animate-once animate-duration-[2000ms]" :bordered="false" embedded >

      <n-card class="midcontent" :bordered="false" title="地区统计情况" :segmented="{
        content: true
      }">
        <template #footer>
          <n-card id="map">
            <Mymap v-if="tData.length" :data="tData" @change="tableDataChange" ></Mymap>
          </n-card>
        </template>
        <n-divider vertical />
        <n-card class="list">
          <n-input placeholder="输入地区名称搜索" @input="search">
            <template #prefix>
              <n-icon>
                <svg t="1702018162725" class="icon" viewBox="0 0 1024 1024" version="1.1"
                  xmlns="http://www.w3.org/2000/svg" p-id="995" xmlns:xlink="http://www.w3.org/1999/xlink" width="200"
                  height="200">
                  <path
                    d="M763.172571 578.304Q786.285714 519.917714 786.285714 457.142857q0-62.774857-23.113143-121.161143-25.088-63.378286-73.289142-111.579428t-111.579429-73.289143Q519.917714 128 457.142857 128q-62.774857 0-121.161143 23.113143-63.378286 25.088-111.579428 73.289143t-73.289143 111.579428Q128 394.368 128 457.142857q0 62.774857 23.113143 121.161143 25.088 63.378286 73.289143 111.579429t111.579428 73.289142Q394.368 786.285714 457.142857 786.285714q62.774857 0 121.161143-23.113143 46.226286-18.285714 84.388571-48.914285 0.896 1.042286 1.865143 2.011428l155.154286 155.154286q2.56 2.56 5.540571 4.571429 2.998857 1.974857 6.326858 3.364571 3.328 1.371429 6.857142 2.084571 3.529143 0.694857 7.131429 0.694858t7.131429-0.694858q3.547429-0.713143 6.875428-2.084571 3.328-1.389714 6.326857-3.382857 2.980571-2.011429 5.540572-4.553143 2.541714-2.541714 4.534857-5.540571 2.011429-2.980571 3.382857-6.326858 1.389714-3.309714 2.084571-6.857142 0.694857-3.529143 0.694858-7.131429t-0.694858-7.131429q-0.694857-3.529143-2.084571-6.857142-1.371429-3.328-3.382857-6.326858-2.011429-2.998857-4.534857-5.540571l-155.172572-155.154286q-0.969143-0.969143-2.011428-1.865143 30.610286-38.162286 48.914285-84.388571z m-68.004571-215.405714Q713.142857 408.32 713.142857 457.142857t-17.974857 94.226286Q675.657143 600.685714 638.171429 638.171429q-37.485714 37.485714-86.802286 56.996571Q505.965714 713.142857 457.142857 713.142857q-48.822857 0-94.226286-17.974857Q313.6 675.657143 276.114286 638.171429q-37.485714-37.485714-56.996572-86.802286Q201.142857 505.965714 201.142857 457.142857q0-48.822857 17.974857-94.226286Q238.628571 313.6 276.114286 276.114286q37.485714-37.485714 86.802285-56.996572Q408.32 201.142857 457.142857 201.142857q48.822857 0 94.226286 17.974857Q600.685714 238.628571 638.171429 276.114286q37.485714 37.485714 56.996571 86.802285z"
                    p-id="996" fill="#707070"></path>
                </svg>
              </n-icon>
            </template>
          </n-input>

          <n-data-table v-if="tData" striped :columns="columns" :data="tData" :bordered="false" :max-height="maxheight"
            @update:filters="handleUpdateFilter" />

        </n-card>
      </n-card>

    </div>
</template>
<style scoped>
.midContiner {
  display: flex;
  height: 88vh ;
}

.midcontent {
  left: 15vw;
  height: 70vh;
  width: 70vw;
}

#map {
  height: 61.5vh;
  width: 45vw;
  position: absolute;
  top: 8.5vh;
  left: 0;
}

.list {
  position: absolute;
  height: 61.5vh;
  width: 25vw;
  left: 45vw;
  top: 8.5vh
}
</style>