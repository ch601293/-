# 项目配置指南

## 问题说明

DevEco Studio 无法识别项目是因为当前的项目结构是为仓颉语言设计的，而 DevEco Studio 默认期望的是标准的 ArkTS/TS 项目结构。

## 解决方案

由于仓颉语言目前仍在开发中，我们有两个选择：

### 方案一：使用 ArkTS 重写（推荐用于实际开发）

创建一个标准的 HarmonyOS 项目，使用 ArkTS 实现相同的功能。

**步骤**：

1. **创建新项目**
   ```
   DevEco Studio → File → New → Create Project
   选择：Wearable → Empty Ability
   ```

2. **配置项目**
   - Application name: AmapNavWatch
   - Bundle name: com.huawei.amap.navigation.watch
   - Device type: Wearable
   - Language: ArkTS
   - API version: 10

3. **复制代码逻辑**
   - 将 `.cj` 文件中的逻辑转换为 `.ets` (ArkTS)
   - ArkTS 语法与 TypeScript 类似，转换相对容易

### 方案二：配置仓颉语言支持（实验性）

如果您确实需要使用仓颉语言，需要以下额外配置：

#### 1. 安装仓颉语言插件

```
DevEco Studio → Settings → Plugins
搜索 "Cangjie Language Support"
安装并重启
```

#### 2. 创建标准项目结构

运行以下脚本重新组织项目：

```bash
cd /home/user/-/watch-app

# 创建标准目录结构
mkdir -p entry/src/main/ets/entryability
mkdir -p entry/src/main/ets/pages
mkdir -p AppScope/resources/base/element
mkdir -p AppScope/resources/base/media

# 创建入口文件
cat > entry/src/main/ets/entryability/EntryAbility.ts << 'EOF'
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    console.info('EntryAbility onCreate');
  }

  onDestroy() {
    console.info('EntryAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        console.error('Failed to load the content. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in loading the content. Data: ' + JSON.stringify(data));
    });
  }
}
EOF

# 创建主页面
cat > entry/src/main/ets/pages/Index.ets << 'EOF'
@Entry
@Component
struct Index {
  @State message: string = '高德导航手表应用';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}
EOF
```

#### 3. 创建配置文件

**hvigorfile.ts** (根目录)
```typescript
export { appTasks } from '@ohos/hvigor-ohos-plugin';
```

**entry/hvigorfile.ts**
```typescript
export { hapTasks } from '@ohos/hvigor-ohos-plugin';
```

**oh-package.json5** (根目录)
```json5
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
```

#### 4. 创建字符串资源

**AppScope/resources/base/element/string.json**
```json
{
  "string": [
    {
      "name": "app_name",
      "value": "高德导航"
    }
  ]
}
```

**entry/src/main/resources/base/element/string.json**
```json
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
```

#### 5. 创建页面配置

**entry/src/main/resources/base/profile/main_pages.json**
```json
{
  "src": [
    "pages/Index"
  ]
}
```

## 推荐方案：从零开始创建 ArkTS 项目

由于仓颉语言的工具链还不够完善，**强烈建议使用 ArkTS** 重新实现项目。

### 快速开始步骤

#### 1. 创建新项目

```
DevEco Studio → File → New → Create Project
→ Wearable → Empty Ability
→ 填写项目信息 → Finish
```

#### 2. 配置 module.json5

参考当前项目的权限配置：

```json5
{
  "module": {
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
```

#### 3. 实现核心功能

**平台检测** (PlatformDetector.ets)
```typescript
export enum PlatformType {
  HARMONYOS,
  ANDROID,
  HYPEROS,
  UNKNOWN
}

export class PlatformDetector {
  static detectPlatform(): PlatformType {
    // 检测逻辑
    return PlatformType.HARMONYOS;
  }
}
```

**导航数据模型** (NavigationData.ets)
```typescript
export class NavigationData {
  instruction: string = '';
  distance: number = 0;
  isNavigating: boolean = false;

  formatDistance(): string {
    if (this.distance < 1000) {
      return `${this.distance}米`;
    }
    return `${(this.distance / 1000).toFixed(1)}公里`;
  }
}
```

**通知监听** (NotificationListener.ets)
```typescript
import notificationManager from '@ohos.notificationManager';

export class NotificationListener {
  async startListening() {
    // 请求通知权限
    // 监听通知
  }
}
```

## ArkTS vs 仓颉语言对照

| 功能 | 仓颉语言 | ArkTS |
|------|---------|-------|
| 类定义 | `public class Foo {}` | `export class Foo {}` |
| 函数定义 | `func foo(): String` | `foo(): string` |
| 变量声明 | `let name: String` | `let name: string` |
| 空值处理 | `var? name: String?` | `name?: string` |
| 模式匹配 | `match (x) { case A => }` | `switch(x) { case A: }` |

## 后续步骤

### 如果选择 ArkTS 方案

1. 在 DevEco Studio 创建新的 Wearable 项目
2. 参考当前仓颉代码的逻辑
3. 使用 ArkTS 重新实现
4. 测试和调试

### 如果坚持使用仓颉语言

1. 等待华为官方发布完整的仓颉语言工具链
2. 或使用命令行工具手动编译
3. 当前可以作为学习和原型项目

## 帮助资源

- [HarmonyOS 开发文档](https://developer.harmonyos.com/)
- [ArkTS 语言指南](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/arkts-get-started-0000001504769321)
- [DevEco Studio 使用指南](https://developer.harmonyos.com/cn/develop/deveco-studio)

## 需要帮助？

如果需要我帮您：
1. ✅ 创建一个标准的 ArkTS 项目结构
2. ✅ 转换仓颉代码为 ArkTS
3. ✅ 提供详细的迁移指南

请告诉我您的选择！
