# DevEco Studio 开发和测试指南

本指南将帮助您在 DevEco Studio 中打开项目，并在华为 GT5 手表上进行测试。

## 📋 前置准备

### 1. 系统要求

**开发电脑要求**：
- Windows 10/11 64位 或 macOS 10.14+
- 内存：8GB 以上（推荐 16GB）
- 硬盘：至少 10GB 可用空间
- 处理器：Intel Core i5 或以上

**手表要求**：
- 华为 GT5 手表
- HarmonyOS 3.0 或更高版本
- 已开启开发者模式

## 🔧 第一步：安装 DevEco Studio

### 下载安装

1. **访问华为官网**
   ```
   https://developer.harmonyos.com/cn/develop/deveco-studio
   ```

2. **下载对应版本**
   - Windows：DevEco-Studio-x.x.x.exe
   - macOS：DevEco-Studio-x.x.x.dmg

3. **安装步骤**
   - Windows：双击安装包，按提示安装
   - macOS：拖动到 Applications 文件夹

### 首次启动配置

1. **启动 DevEco Studio**

2. **配置向导**
   - 选择界面主题（推荐 Darcula）
   - 配置代理（如需要）
   - 同意用户协议

3. **下载 HarmonyOS SDK**
   ```
   设置 → SDK 管理器 → 下载以下组件：
   - HarmonyOS SDK (API 10)
   - HarmonyOS SDK Tools
   - 仓颉语言支持插件
   ```

4. **配置 Node.js**（自动下载）
   - DevEco Studio 会自动配置 Node.js
   - 也可手动配置：设置 → Node.js 路径

## 📂 第二步：打开项目

### 方式一：从本地打开（推荐）

1. **启动 DevEco Studio**

2. **打开项目**
   ```
   File → Open → 选择项目目录
   ```

3. **选择项目目录**
   ```
   导航到：watch-app/
   点击 "OK"
   ```

4. **等待索引完成**
   - DevEco Studio 会自动索引项目文件
   - 底部状态栏显示进度
   - 通常需要 1-3 分钟

### 方式二：从 Git 克隆

1. **克隆仓库**
   ```
   File → New → Project from Version Control
   ```

2. **输入 Git URL**
   ```
   URL: [您的仓库地址]
   Directory: 选择存放位置
   ```

3. **打开 watch-app 目录**
   ```
   克隆完成后，打开 watch-app 子目录
   ```

## ⚙️ 第三步：配置项目

### 1. 检查项目配置

**检查 manifest.json**
```json
{
  "app": {
    "bundleName": "com.huawei.amap.navigation.watch",
    "vendor": "Huawei",
    "version": {
      "code": 1000000,
      "name": "1.0.0"
    }
  }
}
```

**检查 build-profile.json5**
```json5
{
  "app": {
    "compileSdkVersion": 10,
    "compatibleSdkVersion": 9
  }
}
```

### 2. 配置签名（重要）

**生成签名证书**

1. **打开签名配置**
   ```
   File → Project Structure → Signing Configs
   ```

2. **自动生成签名**
   ```
   点击 "Automatically generate signature"

   填写信息：
   - App name: AmapNavWatch
   - Company name: [您的公司名]
   - Country: CN

   点击 "OK"
   ```

3. **或手动配置**（如果已有证书）
   ```
   Signing Configs → default
   - Store File: [证书文件路径]
   - Store Password: [证书密码]
   - Key Alias: [密钥别名]
   - Key Password: [密钥密码]
   ```

### 3. 同步项目

```
点击右上角 "Sync Project with Gradle Files" 图标
或
菜单：Tools → Sync Project
```

## 📱 第四步：连接手表

### 方式一：USB 连接（推荐）

1. **在手表上开启开发者模式**
   ```
   设置 → 关于 → 连续点击"软件版本"7次
   ```

2. **开启 USB 调试**
   ```
   设置 → 系统和更新 → 开发者选项
   - 开启"开发者选项"
   - 开启"USB 调试"
   - 开启"USB 调试（安全设置）"（如有）
   ```

3. **连接手表到电脑**
   - 使用 USB 数据线连接手表
   - 手表上会弹出授权提示
   - 点击"允许"或"始终允许"

4. **验证连接**

   打开终端/命令提示符：
   ```bash
   # 查看已连接设备
   hdc list targets

   # 应该看到类似输出：
   # [Empty]              # 如果没连上
   # FMR0123456789ABC     # 如果连上了（设备ID）
   ```

### 方式二：Wi-Fi 无线调试

1. **确保电脑和手表在同一 Wi-Fi 网络**

2. **获取手表 IP 地址**
   ```
   手表：设置 → WLAN → 点击已连接的网络
   查看 IP 地址（如：192.168.1.100）
   ```

3. **连接到手表**
   ```bash
   # 连接到手表
   hdc tconn 192.168.1.100:5555

   # 验证连接
   hdc list targets
   ```

### 方式三：蓝牙调试（备用）

1. **在 DevEco Studio 中**
   ```
   Tools → Device Manager → 蓝牙调试
   ```

2. **配对手表**
   - 搜索附近设备
   - 选择您的手表
   - 确认配对码

## 🚀 第五步：运行应用

### 1. 选择运行配置

在 DevEco Studio 顶部工具栏：

```
[配置下拉框] → entry
[设备下拉框] → [您的手表设备ID]
```

### 2. 构建并运行

**方法 A：点击运行按钮**
```
点击绿色的 "Run ▶" 按钮
```

**方法 B：使用菜单**
```
Run → Run 'entry'
或按快捷键 Shift + F10
```

**方法 C：调试模式**
```
点击绿色的 "Debug 🐛" 按钮
或按快捷键 Shift + F9
```

### 3. 等待安装

**构建过程**：
```
1. 编译仓颉代码...      [████████░░] 80%
2. 打包资源文件...      [██████████] 100%
3. 生成 HAP 包...       [██████████] 100%
4. 签名...              [██████████] 100%
5. 安装到设备...        [██████████] 100%
```

**查看日志**：
```
底部窗口 → Run 标签页
可以看到构建和安装的详细日志
```

### 4. 首次安装提示

手表上可能会提示：
```
"是否允许安装未验证的应用？"
→ 点击"允许"或"仅此一次"
```

## 🧪 第六步：测试应用

### 1. 启动应用

**方式一：自动启动**
- DevEco Studio 安装后会自动启动应用

**方式二：手动启动**
```
手表屏幕 → 应用列表 → "高德导航"
```

### 2. 授予权限

**首次运行会请求权限**：

1. **通知访问权限**（必需）
   ```
   应用提示："请在设置中授予通知访问权限"

   操作步骤：
   1. 手表：设置 → 通知 → 通知访问权限
   2. 找到"高德导航"
   3. 开启权限
   ```

2. **返回应用**
   - 从应用列表重新打开应用

### 3. 测试平台检测

**查看日志确认平台**：

在 DevEco Studio 中：
```
底部窗口 → Logcat 标签页

过滤日志：
- 输入 "AmapNavWatch" 或 "navigation"
- 查看平台检测日志

应该看到类似输出：
[AmapNavWatch] INFO: 应用启动
[AmapNavWatch] INFO: 检测到平台: HARMONYOS, 版本: 4.0.0
[AmapNavWatch] INFO: 运行在: 鸿蒙系统
[HarmonyOS] INFO: HarmonyOS 平台服务初始化成功
```

### 4. 测试导航功能

**完整测试流程**：

#### A. 准备工作
```
1. 确保手机已安装高德地图
2. 手机与手表已配对
3. 手机开启蓝牙和通知同步
```

#### B. 测试步骤

**步骤 1：配置手机通知同步**
```
华为手机（鸿蒙系统）：
1. 打开"华为运动健康" App
2. 设备 → 选择手表 → 通知提醒
3. 确保"通知提醒"开关已开启
4. 找到"高德地图"，开启通知同步

小米手机（澎湃系统）：
1. 打开"小米智慧中心" App
2. 添加华为 GT5 到设备列表
3. 授予设备互联权限

其他 Android 手机：
1. 确保蓝牙连接正常
2. 系统通知同步已开启
```

**步骤 2：启动导航**
```
1. 在手机上打开高德地图
2. 输入目的地（可以随便输入一个地点）
3. 点击"开始导航"
```

**步骤 3：查看手表**
```
手表应显示：
┌─────────────────────┐
│   正在导航...       │
├─────────────────────┤
│         ↑          │
├─────────────────────┤
│      500米          │
├─────────────────────┤
│      左转           │
└─────────────────────┘
```

**步骤 4：查看日志**
```
DevEco Studio → Logcat

应看到：
[NavigationParser] INFO: 收到通知 - 包名: com.autonavi.minimap
[NavigationParser] INFO: 导航数据已更新: 前方500米左转
[NavigationView] INFO: UI已更新
```

### 5. 测试不同平台

**测试小米智慧中心（如果是小米手机）**：

```
查看日志：
[HyperOS] INFO: 使用小米智慧中心接收导航数据
[XiaomiAIHub] INFO: 已连接到小米智慧中心
[XiaomiAIHub] INFO: 消息已发送: ...

如果智慧中心不可用：
[HyperOS] INFO: 小米智慧中心不可用，使用通知监听
```

## 🐛 第七步：调试技巧

### 1. 查看实时日志

**过滤日志**：
```
Logcat 窗口 → 过滤器
- Package: com.huawei.amap.navigation.watch
- Tag: AmapNavWatch
- Log Level: Debug
```

**查找关键日志**：
```bash
# 平台检测
检测到平台

# 通知接收
收到通知

# 数据解析
导航数据已更新

# UI 更新
UI已更新
```

### 2. 断点调试

**设置断点**：
```
在代码行号左侧点击，设置断点
重要位置：
- src/main.cj: detectAndInitPlatform()
- src/service/NotificationListener.cj: onNotificationReceived()
- src/service/NavigationParser.cj: parseNotification()
```

**开始调试**：
```
点击 Debug 按钮 🐛
当程序执行到断点时会暂停
可以查看变量值、单步执行等
```

### 3. 模拟通知（高级）

**使用 hdc 发送测试通知**：

```bash
# 连接手表
hdc shell

# 发送测试通知（需要 root 权限）
am broadcast -a android.intent.action.TEST_NOTIFICATION \
  --es title "导航提示" \
  --es content "前方500米左转进入中山路"
```

### 4. 性能分析

**内存监控**：
```
View → Tool Windows → Profiler
- 选择手表设备
- 点击 "Memory"
- 观察内存使用情况
```

**CPU 监控**：
```
Profiler → CPU
- 查看 CPU 使用率
- 分析性能瓶颈
```

## 📊 第八步：查看应用信息

### 1. 应用管理器

```
Tools → Device Manager

可以看到：
- 设备列表
- 已安装应用
- 应用状态
```

### 2. 文件浏览器

```
View → Tool Windows → Device File Explorer

可以查看：
- 应用数据目录
- 日志文件
- 配置文件
```

### 3. 性能监控

```
Run → Attach Profiler to Process
- 选择应用进程
- 实时监控性能
```

## ❌ 常见问题解决

### 问题 1：无法连接手表

**症状**：`hdc list targets` 返回空

**解决方案**：
```bash
# 1. 检查 USB 连接
- 尝试更换 USB 线
- 尝试更换 USB 端口

# 2. 重启 hdc 服务
hdc kill
hdc start

# 3. 检查驱动（Windows）
- 设备管理器 → 查看手表设备
- 如果有感叹号，更新驱动

# 4. 重启手表
- 长按电源键 → 重启
```

### 问题 2：编译失败

**症状**：构建时报错

**解决方案**：
```bash
# 1. 清理项目
Build → Clean Project

# 2. 重新构建
Build → Rebuild Project

# 3. 删除缓存
File → Invalidate Caches → Invalidate and Restart

# 4. 检查 SDK 版本
Settings → SDK Manager → 确保 API 10 已安装
```

### 问题 3：签名错误

**症状**：安装时提示"签名验证失败"

**解决方案**：
```
1. 检查签名配置
   Project Structure → Signing Configs

2. 重新生成签名
   点击 "Automatically generate signature"

3. 或手动指定正确的证书文件
```

### 问题 4：应用闪退

**症状**：应用启动后立即退出

**解决方案**：
```
1. 查看崩溃日志
   Logcat → 过滤 "crash" 或 "exception"

2. 检查权限
   确保已授予通知访问权限

3. 查看代码错误
   根据日志定位问题代码

4. 重新安装
   卸载后重新安装
```

### 问题 5：日志看不到输出

**症状**：Logcat 中没有日志

**解决方案**：
```
1. 检查日志级别
   Logcat → Log Level → 选择 "Debug" 或 "Verbose"

2. 检查包名过滤
   确保包名正确：com.huawei.amap.navigation.watch

3. 清除日志过滤
   点击 "Clear Logcat" 按钮

4. 重新连接设备
   hdc kill && hdc start
```

## 📝 测试检查清单

使用此清单确保完整测试：

### 功能测试
- [ ] 应用能正常启动
- [ ] 平台检测正确（查看日志）
- [ ] UI 正常显示
- [ ] 通知访问权限请求正常
- [ ] 能接收高德地图通知
- [ ] 导航数据解析正确
- [ ] 距离信息显示正确
- [ ] 导航类型识别正确
- [ ] 导航结束能正确显示

### 多平台测试（如适用）
- [ ] 鸿蒙手机测试通过
- [ ] Android 手机测试通过
- [ ] 小米手机测试通过
- [ ] 小米智慧中心连接成功（小米手机）

### 性能测试
- [ ] 内存使用正常（< 50MB）
- [ ] CPU 使用正常（< 10%）
- [ ] 无内存泄漏
- [ ] 响应延迟可接受

### 稳定性测试
- [ ] 长时间运行无崩溃
- [ ] 切换应用后能恢复
- [ ] 手表息屏后能继续工作
- [ ] 手机断开重连能自动恢复

## 🎯 下一步

测试完成后，您可以：

1. **优化性能**
   - 根据 Profiler 数据优化代码
   - 减少内存占用
   - 提高响应速度

2. **添加功能**
   - 参考 DEVELOPMENT.md 进行二次开发
   - 添加新的导航类型
   - 支持更多地图应用

3. **发布应用**
   - 生成 Release 版本
   - 提交到华为应用市场
   - 获取用户反馈

## 📚 参考资源

- [DevEco Studio 官方文档](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/tools_overview-0000001053582387)
- [HarmonyOS 开发指南](https://developer.harmonyos.com/cn/documentation)
- [仓颉语言文档](https://developer.huawei.com/consumer/cn/cangjie)
- [hdc 工具使用指南](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/hdc-0000001050166905)

---

**祝您开发顺利！** 🚀

如有问题，请查看项目 README.md 或在 GitHub Issues 中提问。
