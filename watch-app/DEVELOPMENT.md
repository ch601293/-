# 开发文档

本文档面向希望了解项目技术细节或进行二次开发的开发者。

## 技术栈

- **编程语言**：仓颉语言 (Cangjie)
- **开发平台**：HarmonyOS
- **开发工具**：DevEco Studio 4.0+
- **目标设备**：华为 GT5 手表（HarmonyOS 3.0+）

## 核心架构

### 架构图

```
┌─────────────────────────────────────────┐
│           手机端（高德地图）               │
│  - 导航功能                               │
│  - 生成导航通知                           │
└──────────────┬──────────────────────────┘
               │ 通知同步
               │ (HarmonyOS)
               ↓
┌─────────────────────────────────────────┐
│           手表端应用                      │
│  ┌─────────────────────────────────┐    │
│  │  NotificationListener.cj        │    │
│  │  - 监听系统通知                  │    │
│  │  - 筛选高德地图通知              │    │
│  └───────────┬─────────────────────┘    │
│              │                            │
│              ↓                            │
│  ┌─────────────────────────────────┐    │
│  │  NavigationParser.cj            │    │
│  │  - 解析通知内容                  │    │
│  │  - 提取导航数据                  │    │
│  └───────────┬─────────────────────┘    │
│              │                            │
│              ↓                            │
│  ┌─────────────────────────────────┐    │
│  │  NavigationData.cj              │    │
│  │  - 数据模型                      │    │
│  └───────────┬─────────────────────┘    │
│              │                            │
│              ↓                            │
│  ┌─────────────────────────────────┐    │
│  │  NavigationView.cj              │    │
│  │  - UI 渲染                       │    │
│  │  - 显示导航信息                  │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

### 模块说明

#### 1. Model 层（数据模型）

**NavigationData.cj**
- 定义导航数据结构
- 提供数据格式化方法
- 管理导航状态

```cangjie
public class NavigationData {
    public var instruction: String      // 导航指令
    public var navType: NavigationType  // 导航类型
    public var distance: Int64          // 距离
    public var isNavigating: Bool       // 导航状态
    // ...
}
```

#### 2. Service 层（业务逻辑）

**NotificationListener.cj**
- 继承自 HarmonyOS 的 Ability
- 实现通知监听功能
- 管理服务生命周期
- 提供数据回调接口

核心方法：
```cangjie
func onNotificationReceived(notification: Notification)
func onNotificationRemoved(notification: Notification)
```

**NavigationParser.cj**
- 解析通知文本
- 提取导航信息
- 支持多种格式

核心方法：
```cangjie
func parseNotification(title: String, content: String): NavigationData
func isNavigationNotification(packageName: String, content: String): Bool
```

**BluetoothService.cj**（可选）
- 蓝牙连接管理
- 数据传输
- 连接状态监控

#### 3. UI 层（用户界面）

**NavigationView.cj**
- 继承自 ComponentContainer
- 管理 UI 组件
- 响应数据更新

核心方法：
```cangjie
func updateNavigationData(navData: NavigationData)
func showWaitingState()
func showNavigationEndedState()
```

## 数据流

1. **通知接收**
   ```
   高德地图发送通知 → HarmonyOS 同步到手表
   → NotificationListener 接收
   ```

2. **数据解析**
   ```
   通知内容 → NavigationParser 解析
   → NavigationData 对象
   ```

3. **UI 更新**
   ```
   NavigationData → 回调通知 → NavigationView
   → 更新界面显示
   ```

## 核心算法

### 导航类型识别

使用关键词匹配算法：

```cangjie
private func parseNavigationType(content: String): NavigationType {
    if (content.contains("直行")) {
        return NavigationType.STRAIGHT
    } else if (content.contains("左转")) {
        return NavigationType.LEFT_TURN
    }
    // ... 更多匹配规则
}
```

**优化建议**：
- 可以使用正则表达式提高匹配准确性
- 支持模糊匹配，增强容错性
- 使用机器学习模型进行语义理解

### 距离解析

支持多种距离格式：

```cangjie
private func parseDistance(content: String): Int64 {
    // 支持：500米、1.5公里、1500m、1.5km 等
    if (content.contains("公里")) {
        let km = extractNumberWithDecimal(content, "公里")
        return (km * 1000.0).toInt64()
    }
    // ...
}
```

## 权限管理

### 必需权限

1. **通知访问权限** (`ohos.permission.NOTIFICATION_CONTROLLER`)
   - 用途：监听系统通知
   - 级别：系统权限
   - 申请方式：引导用户在设置中手动开启

2. **蓝牙权限** (`ohos.permission.USE_BLUETOOTH`)
   - 用途：蓝牙通信（可选功能）
   - 级别：普通权限
   - 申请方式：运行时请求

### 权限申请流程

```cangjie
// 1. 在 manifest.json 中声明权限
"requestPermissions": [
    {
        "name": "ohos.permission.NOTIFICATION_CONTROLLER",
        "reason": "需要监听高德地图导航通知"
    }
]

// 2. 在代码中检查权限
private func checkPermissions() {
    if (!hasNotificationPermission()) {
        requestNotificationPermission()
    }
}

// 3. 引导用户开启权限
private func requestNotificationPermission() {
    showToast("请在设置中授予通知访问权限")
    // 可以打开设置页面
}
```

## 性能优化

### 1. 内存优化

- 使用对象池复用 NavigationData 对象
- 及时释放不再使用的资源
- 避免内存泄漏

```cangjie
// 在服务停止时清理资源
public override func onStop() {
    bluetoothService?.disconnect()
    bluetoothService = null
    currentNavData = null
}
```

### 2. 功耗优化

- 基于通知机制，避免轮询
- 不需要持续的蓝牙连接
- 合理使用屏幕唤醒

### 3. UI 优化

- 使用硬件加速
- 避免频繁的 UI 更新
- 图片资源压缩

## 调试技巧

### 1. 日志输出

使用统一的日志工具：

```cangjie
private func logInfo(message: String) {
    println("[${Constants.LOG_TAG}] INFO: ${message}")
}

private func logError(message: String) {
    println("[${Constants.LOG_TAG}] ERROR: ${message}")
}
```

### 2. 模拟通知测试

创建测试通知：

```bash
# 使用 hdc 发送测试通知
hdc shell "am broadcast -a com.test.notification \
  --es title '导航提示' \
  --es content '前方500米左转进入中山路'"
```

### 3. 性能监控

使用 DevEco Studio 的性能分析工具：
- CPU 使用率监控
- 内存使用分析
- 帧率检测

## 扩展开发

### 添加新的导航类型

1. 在 `NavigationData.cj` 中添加枚举：
```cangjie
public enum NavigationType {
    | EXISTING_TYPES
    | NEW_TYPE  // 新类型
}
```

2. 在 `NavigationParser.cj` 中添加识别逻辑：
```cangjie
else if (content.contains("新关键词")) {
    return NavigationType.NEW_TYPE
}
```

3. 在 `NavigationView.cj` 中添加显示逻辑：
```cangjie
case NEW_TYPE => {
    // 设置对应的图标和文本
}
```

### 支持其他地图应用

1. 修改 `Constants.cj` 添加包名：
```cangjie
public static let AMAP_PACKAGE_NAMES: Array<String> = [
    "com.autonavi.minimap",
    "com.new.map.app"  // 新地图应用
]
```

2. 分析新应用的通知格式
3. 调整 `NavigationParser.cj` 的解析逻辑

### 自定义 UI 主题

创建主题配置类：

```cangjie
public class Theme {
    public var primaryColor: Int32
    public var backgroundColor: Int32
    public var textColor: Int32

    public static func getDarkTheme(): Theme { ... }
    public static func getLightTheme(): Theme { ... }
}
```

## 测试

### 单元测试

为核心功能编写单元测试：

```cangjie
@Test
func testParseDistance() {
    let parser = NavigationParser()
    let result = parser.parseDistance("前方500米左转")
    assert(result == 500)
}
```

### 集成测试

测试通知监听和解析的完整流程：

```cangjie
@Test
func testNotificationFlow() {
    let service = NotificationListenerService()
    let notification = createMockNotification()
    service.onNotificationReceived(notification)
    // 验证数据是否正确解析
}
```

### UI 测试

使用 DevEco Studio 的 UI 测试框架：

```cangjie
@UITest
func testNavigationViewUpdate() {
    let view = NavigationView(context)
    let navData = createTestNavigationData()
    view.updateNavigationData(navData)
    // 验证 UI 更新是否正确
}
```

## 构建与发布

### 开发构建

```bash
# 调试构建
hvigorw assembleHap --mode debug

# 生成 APK
hvigorw assembleHap --mode release
```

### 签名配置

1. 生成密钥对
2. 在 `build-profile.json5` 中配置签名信息
3. 使用签名构建

### 发布流程

1. 版本号管理（遵循语义化版本）
2. 生成发布构建
3. 测试验证
4. 提交到华为应用市场

## 常见问题

### Q: 仓颉语言与 TypeScript/Kotlin 的区别？

仓颉语言是华为开发的现代编程语言，具有：
- 强类型系统（类似 TypeScript）
- 内存安全（类似 Rust）
- 高性能（类似 C++）
- 与 HarmonyOS 深度集成

### Q: 如何调试通知监听服务？

1. 使用日志输出
2. 使用 hdc logcat 查看日志
3. 使用 DevEco Studio 的调试器

### Q: 性能瓶颈在哪里？

主要性能开销：
1. 通知解析（文本处理）
2. UI 更新（界面渲染）
3. 蓝牙通信（如果启用）

优化重点：
- 缓存解析结果
- 减少 UI 刷新频率
- 异步处理数据

## 贡献代码

### 代码规范

1. 使用有意义的变量名
2. 添加必要的注释
3. 遵循仓颉语言的命名约定
4. 保持代码简洁清晰

### 提交规范

```
类型(范围): 简短描述

详细描述

相关 Issue: #123
```

类型：
- feat: 新功能
- fix: 修复 bug
- docs: 文档更新
- style: 代码格式
- refactor: 重构
- test: 测试
- chore: 构建/工具

## 资源链接

- [HarmonyOS 官方文档](https://developer.harmonyos.com/)
- [仓颉语言文档](https://developer.huawei.com/consumer/cn/cangjie)
- [DevEco Studio 下载](https://developer.harmonyos.com/cn/develop/deveco-studio)
- [高德地图开放平台](https://lbs.amap.com/)

## 联系方式

- 技术讨论：[GitHub Discussions]
- 问题反馈：[GitHub Issues]
- 邮件联系：[Email]

---

**Happy Coding!** 👨‍💻
