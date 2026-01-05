#!/bin/bash

# 华为 GT5 手表导航应用 - DevEco Studio 项目设置脚本
# 此脚本将创建一个标准的 DevEco Studio 可识别的项目结构

echo "========================================="
echo "  华为 GT5 导航应用 - 项目配置向导"
echo "========================================="
echo ""

# 当前目录
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
echo "项目目录: $PROJECT_ROOT"
echo ""

# 询问用户选择
echo "请选择配置方案："
echo "1) 创建标准 ArkTS 项目结构（推荐）"
echo "2) 配置仓颉语言混合项目（实验性）"
echo "3) 查看帮助文档"
echo ""
read -p "请输入选项 (1-3): " choice

case $choice in
  1)
    echo ""
    echo "正在创建标准 ArkTS 项目结构..."
    echo ""

    # 创建目录结构
    mkdir -p AppScope/resources/base/element
    mkdir -p AppScope/resources/base/media
    mkdir -p entry/src/main/ets/entryability
    mkdir -p entry/src/main/ets/pages
    mkdir -p entry/src/main/ets/model
    mkdir -p entry/src/main/ets/service
    mkdir -p entry/src/main/ets/platform
    mkdir -p entry/src/main/resources/base/element
    mkdir -p entry/src/main/resources/base/media
    mkdir -p entry/src/main/resources/base/profile

    # 创建 hvigorfile.ts (根目录)
    cat > hvigorfile.ts << 'EOF'
export { appTasks } from '@ohos/hvigor-ohos-plugin';
EOF

    # 创建 entry/hvigorfile.ts
    cat > entry/hvigorfile.ts << 'EOF'
export { hapTasks } from '@ohos/hvigor-ohos-plugin';
EOF

    # 创建 oh-package.json5
    cat > oh-package.json5 << 'EOF'
{
  "name": "amap-nav-watch",
  "version": "1.0.0",
  "description": "高德地图导航手表应用",
  "main": "",
  "author": "",
  "license": "MIT",
  "dependencies": {},
  "devDependencies": {
    "@ohos/hvigor-ohos-plugin": "4.0.0",
    "@ohos/hvigor": "4.0.0"
  }
}
EOF

    # 创建 AppScope/app.json5
    cat > AppScope/app.json5 << 'EOF'
{
  "app": {
    "bundleName": "com.huawei.amap.navigation.watch",
    "vendor": "Huawei",
    "versionCode": 1000000,
    "versionName": "1.0.0",
    "icon": "$media:app_icon",
    "label": "$string:app_name"
  }
}
EOF

    # 创建 AppScope 字符串资源
    cat > AppScope/resources/base/element/string.json << 'EOF'
{
  "string": [
    {
      "name": "app_name",
      "value": "高德导航"
    }
  ]
}
EOF

    # 创建 build-profile.json5
    cat > build-profile.json5 << 'EOF'
{
  "app": {
    "products": [
      {
        "name": "default",
        "signingConfig": "default",
        "compatibleSdkVersion": 9,
        "runtimeOS": "HarmonyOS"
      }
    ],
    "signingConfigs": []
  },
  "modules": [
    {
      "name": "entry",
      "srcPath": "./entry",
      "targets": [
        {
          "name": "default",
          "applyToProducts": ["default"]
        }
      ]
    }
  ]
}
EOF

    # 创建 entry/build-profile.json5
    cat > entry/build-profile.json5 << 'EOF'
{
  "apiType": "stageMode",
  "buildOption": {},
  "targets": [
    {
      "name": "default",
      "runtimeOS": "HarmonyOS"
    }
  ]
}
EOF

    # 创建 module.json5
    cat > entry/src/main/module.json5 << 'EOF'
{
  "module": {
    "name": "entry",
    "type": "entry",
    "description": "$string:module_desc",
    "mainElement": "EntryAbility",
    "deviceTypes": [
      "wearable"
    ],
    "deliveryWithInstall": true,
    "installationFree": false,
    "pages": "$profile:main_pages",
    "abilities": [
      {
        "name": "EntryAbility",
        "srcEntry": "./ets/entryability/EntryAbility.ts",
        "description": "$string:EntryAbility_desc",
        "icon": "$media:icon",
        "label": "$string:EntryAbility_label",
        "startWindowIcon": "$media:icon",
        "startWindowBackground": "$color:start_window_background",
        "exported": true,
        "skills": [
          {
            "entities": ["entity.system.home"],
            "actions": ["action.system.home"]
          }
        ]
      }
    ],
    "requestPermissions": [
      {
        "name": "ohos.permission.NOTIFICATION_CONTROLLER",
        "reason": "$string:permission_notification",
        "usedScene": {
          "abilities": ["EntryAbility"],
          "when": "always"
        }
      }
    ]
  }
}
EOF

    # 创建字符串资源
    cat > entry/src/main/resources/base/element/string.json << 'EOF'
{
  "string": [
    {
      "name": "EntryAbility_desc",
      "value": "导航显示应用"
    },
    {
      "name": "EntryAbility_label",
      "value": "高德导航"
    },
    {
      "name": "module_desc",
      "value": "高德地图导航手表端显示应用"
    },
    {
      "name": "permission_notification",
      "value": "需要监听高德地图导航通知"
    }
  ]
}
EOF

    # 创建页面配置
    cat > entry/src/main/resources/base/profile/main_pages.json << 'EOF'
{
  "src": [
    "pages/Index"
  ]
}
EOF

    # 创建入口Ability
    cat > entry/src/main/ets/entryability/EntryAbility.ts << 'EOF'
import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    hilog.info(0x0000, 'AmapNavWatch', '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'AmapNavWatch', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(0x0000, 'AmapNavWatch', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'AmapNavWatch', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'AmapNavWatch', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    hilog.info(0x0000, 'AmapNavWatch', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    hilog.info(0x0000, 'AmapNavWatch', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    hilog.info(0x0000, 'AmapNavWatch', '%{public}s', 'Ability onBackground');
  }
}
EOF

    # 创建主页面
    cat > entry/src/main/ets/pages/Index.ets << 'EOF'
@Entry
@Component
struct Index {
  @State message: string = '高德导航手表应用';
  @State platformName: string = '正在检测...';

  aboutToAppear() {
    // 检测平台
    this.detectPlatform();
  }

  detectPlatform() {
    // 简单的平台检测逻辑
    this.platformName = '鸿蒙系统 (HarmonyOS)';
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      Text('平台: ' + this.platformName)
        .fontSize(16)
        .fontColor(Color.Gray)
        .margin({ bottom: 40 })

      Text('等待导航...')
        .fontSize(18)
        .fontColor(Color.Blue)

      Text('请在手机上启动高德地图导航')
        .fontSize(14)
        .fontColor(Color.Gray)
        .margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(20)
  }
}
EOF

    echo "✅ 标准 ArkTS 项目结构创建完成！"
    echo ""
    echo "📁 项目结构："
    echo "  - AppScope/          应用级配置"
    echo "  - entry/            主模块"
    echo "    - src/main/ets/   ArkTS 源代码"
    echo "    - src/main/resources/  资源文件"
    echo ""
    echo "📌 下一步操作："
    echo "  1. 用 DevEco Studio 打开项目目录"
    echo "  2. 等待项目索引完成"
    echo "  3. 配置签名: Project Structure → Signing Configs"
    echo "  4. 连接手表并运行"
    echo ""
    echo "📖 详细说明请查看: PROJECT_SETUP_GUIDE.md"
    ;;

  2)
    echo ""
    echo "⚠️  仓颉语言混合项目配置"
    echo ""
    echo "注意：仓颉语言工具链仍在开发中，建议等待官方完整支持。"
    echo "当前建议使用方案1（标准 ArkTS 项目）。"
    echo ""
    echo "📖 详细信息请查看: PROJECT_SETUP_GUIDE.md"
    ;;

  3)
    echo ""
    echo "📖 打开帮助文档..."
    if command -v xdg-open &> /dev/null; then
      xdg-open PROJECT_SETUP_GUIDE.md
    elif command -v open &> /dev/null; then
      open PROJECT_SETUP_GUIDE.md
    else
      echo "请手动打开: PROJECT_SETUP_GUIDE.md"
    fi
    ;;

  *)
    echo "无效选项"
    exit 1
    ;;
esac

echo ""
echo "========================================="
echo "  配置完成！"
echo "========================================="
