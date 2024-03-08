<script setup>
import IndexHead from "./components/IndexHead.vue";
import Toaster from "@/components/ui/toast/Toaster.vue";
import { NMessageProvider} from 'naive-ui'
</script>

<template>
  <div class="Continer">
    <n-message-provider>
      <IndexHead></IndexHead>
      <div class="mid">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </div>
      <Toaster />
    </n-message-provider>

  </div>
</template>

<style scoped>
div.Continer {
  width: 100%;
  height: 100%;
}

.n-button {
  --n-font-size: 1.3em !important;
  --n-border: 0px !important;
  --n-border-hover: 1px solid rgb(193, 193, 193) !important;
  --n-border-pressed: 1px solid rgb(193, 193, 193) !important;
  --n-border-focus: 1px solid rgb(193, 193, 193) !important;
  --n-text-color-hover: rgb(184, 184, 184) !important;
  --n-text-color-pressed: rgb(184, 184, 184) !important;
  --n-text-color-focus: rgb(184, 184, 184) !important;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
