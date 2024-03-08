<template>
  <n-space class="m">
    <div ref="map" class="map"></div>
  </n-space>
</template>

<style scoped>
.map {
  height: 60vh;
  width: 40vw;
}

.n-card.n-card--bordered {
  border: 0px !important;
}
</style>

<script setup>
import { NSpace } from "naive-ui";
import { onMounted, ref, watch } from "vue";
import axios from "axios";
import * as d3 from "d3";
import * as echarts from "echarts";
const props = defineProps({
  data: Array,
});
const emit = defineEmits(['change'])
const map = ref(null);
let mapstack = [];
let level = ref(1);
const change = (data)=>{
  emit("change",data);
}
async function initializeMap(mapInstance, data, tableData) {
  const chinaMapData = await d3.json(
    "https://geo.datav.aliyun.com/areas_v3/bound/100000_full.json"
  );
  mapstack.push({ name: "中国", mapdata: chinaMapData, data: data ,tableData: tableData});
  renderMap(mapInstance, "中国", data, chinaMapData);
}
function renderMap(mapInstance, title, data, geoJSON) {
  echarts.registerMap(title, geoJSON);
  mapInstance.off("click");
  let option;
  const maxValue = Math.max(
    ...data.map(({ name, value }) => {
      return value;
    })
  );
  mapInstance.setOption(
    (option = {
      borderColor: "#000",
      tooltip: {
        trigger: "item",
        formatter: "{b}<br /> 鸟种数量：{c}",
      },
      title: {
        text: "中国鸟类观测报告",
        subtext: title,
        left: "center",
      },
      toolbox: {
        show: true,
        left: "left",
        top: "top",
        feature: {
          dataview: { readonly: false },
          saveAsImage: {},
          myback: {
            show: true,
            title: "back",
            icon: "image://../public/back_ui.png",
            onclick: function () {
              if (level.value == 1) {
                change(periormap.tableData);
                return;
              }
              level.value--;
              mapstack.pop();
              const periormap = mapstack[mapstack.length - 1];
              change(periormap.tableData);
              renderMap(
                mapInstance,
                periormap.name,
                periormap.data,
                periormap.mapdata
              );
            },
          },
        },
      },
      visualMap: {
        min: 0,
        max: maxValue,
        text: ["High", "Low"],
        realtime: false,
        calculable: true,
        inRange: {
          color: ["lightskyblue", "yellow"],
        },
      },
      series: [
        {
          name: "中国鸟类观测报告",
          type: "map",
          map: title,
          label: {
            show: false,
          },
          itemStyle: {
            borderColor: "#27374D",
            borderWidth: 0.7,
          },
          data: data,
          emphasis: {
            label: {
              show: true,
              fontSize: 8,
              fontWeight: 50,
            },
            itemStyle: {
              areaColor: "#eee",
            },
          },
        },
      ],
    })
  );
  if (level.value < 3) {
    setupClickEvent(mapInstance);
  } else {
    mapInstance.off("click"); // 如果是最深层级，则移除点击事件
  }
}
// 设置地图点击事件
function setupClickEvent(mapInstance) {
  mapInstance.on("click", async (event) => {
    if (level.value >= 3) return; // 防止超过最深层级
    const targetFeature = mapstack[mapstack.length - 1].mapdata.features.find(
      (f) => f.properties.name === event.name
    );
    if (!targetFeature) return;

    const adcode = targetFeature.properties.adcode;
    if (adcode) {
      const nextMapData = await d3.json(
        `https://geo.datav.aliyun.com/areas_v3/bound/${adcode}_full.json`
      );
      level.value++;
      let name;
      if (level.value == 2) {
        if (
          ["北京市", "天津市", "重庆市", "上海市"].includes(event.data.name)
        ) {
          name = {
            province: event.data.name,
            city: event.data.name,
          };
        } else {
          name = {
            province: event.data.name,
            city: "",
          };
        }
      }
      if (level.value == 3) {
        name = {
          province: mapstack[mapstack.length - 1].name,
          city: event.data.name,
        };
      }
      const res = await axios.post(
        "https://y4705w2671.oicp.vip/api/v1/record/getByArea",
        name
      );
      const middata = res.data.data;
      const data = Object.keys(middata).map((key) => {
        return {
          area: key,
          speciesNum: middata[key]["speciesNum"],
          recordNum: middata[key]["recordNum"],
        };
      });
      change(data);
      const convertedData = convertData(data);
      mapstack.push({
        name: event.name,
        mapdata: nextMapData,
        data: convertedData,
        tableData:data
      });
      renderMap(mapInstance, event.name, convertedData, nextMapData); // 渲染下一级地图
    }
  });
}

function convertData(rawData) {
  return rawData.map((x) => {
    return { name: x["area"], value: x["speciesNum"] };
  });
}
onMounted(async () => {
  watch(level, (newValue, oldValue) => {
    if (oldValue === 3 && newValue === 2) {
      setupClickEvent(mapInstance); // 重新绑定点击事件
    }
  });
  const mapInstance = echarts.init(map.value);
  const convertedData = convertData(props.data);
  await initializeMap(mapInstance, convertedData,props.data);
});
</script>
