# DevEco Studio 快速参考

> 快速查找常用命令和操作

## 🚀 最常用命令

### hdc 工具命令

```bash
# 查看已连接设备
hdc list targets

# 安装应用
hdc install entry-default-signed.hap

# 卸载应用
hdc uninstall com.huawei.amap.navigation.watch

# 启动应用
hdc shell aa start -a NavigationWatchApp -b com.huawei.amap.navigation.watch

# 停止应用
hdc shell aa force-stop com.huawei.amap.navigation.watch

# 查看实时日志
hdc hilog | grep AmapNavWatch

# 清空日志
hdc shell hilog -r

# 截屏
hdc shell screenshot /data/local/tmp/screenshot.png
hdc file recv /data/local/tmp/screenshot.png ./

# 重启 hdc 服务
hdc kill
hdc start

# Wi-Fi 连接
hdc tconn 192.168.1.100:5555

# 断开 Wi-Fi 连接
hdc tdisconn 192.168.1.100:5555
```

## ⚡ DevEco Studio 快捷键

### Windows/Linux

| 功能 | 快捷键 |
|------|--------|
| 运行 | `Shift + F10` |
| 调试 | `Shift + F9` |
| 停止 | `Ctrl + F2` |
| 构建项目 | `Ctrl + F9` |
| 清理项目 | - |
| 查找 | `Ctrl + F` |
| 全局查找 | `Ctrl + Shift + F` |
| 替换 | `Ctrl + R` |
| 转到定义 | `Ctrl + B` |
| 查找用法 | `Alt + F7` |
| 重命名 | `Shift + F6` |
| 代码格式化 | `Ctrl + Alt + L` |
| 优化导入 | `Ctrl + Alt + O` |
| 注释/取消注释 | `Ctrl + /` |
| 显示参数信息 | `Ctrl + P` |
| 快速修复 | `Alt + Enter` |

### macOS

| 功能 | 快捷键 |
|------|--------|
| 运行 | `Ctrl + R` |
| 调试 | `Ctrl + D` |
| 停止 | `Cmd + F2` |
| 构建项目 | `Cmd + F9` |
| 查找 | `Cmd + F` |
| 全局查找 | `Cmd + Shift + F` |
| 转到定义 | `Cmd + B` |
| 代码格式化 | `Cmd + Option + L` |

## 📱 手表操作

### 开启开发者模式

```
设置 → 关于 → 连续点击"软件版本"7次
```

### 开启 USB 调试

```
设置 → 系统和更新 → 开发者选项
→ 开启"USB 调试"
```

### 查看应用信息

```
设置 → 应用和服务 → 应用管理
→ 找到"高德导航"
```

### 清除应用数据

```
设置 → 应用和服务 → 应用管理
→ 高德导航 → 存储 → 清除数据
```

### 授予通知权限

```
设置 → 通知 → 通知访问权限
→ 找到"高德导航" → 开启
```

## 🔍 日志过滤

### Logcat 常用过滤

```bash
# 只看本应用日志
Package: com.huawei.amap.navigation.watch

# 按标签过滤
Tag: AmapNavWatch

# 按级别过滤
Level: Debug

# 正则表达式
Regex: navigation|platform|error
```

### 关键日志关键词

```bash
# 平台检测
"检测到平台"
"运行在"

# 服务启动
"初始化成功"
"已启动"

# 通知接收
"收到通知"
"导航数据已更新"

# 错误
"失败"
"error"
"exception"
```

## 🐛 调试技巧

### 设置断点位置

```javascript
// 平台检测
src/main.cj:61 → detectAndInitPlatform()

// 通知接收
src/service/NotificationListener.cj → onNotificationReceived()

// 数据解析
src/service/NavigationParser.cj:32 → parseNotification()

// UI 更新
src/ui/NavigationView.cj → updateNavigationData()
```

### 条件断点

```
右键断点 → More → Condition
输入条件，如：navData.distance > 500
```

## 📦 构建命令

### Gradle 命令

```bash
# 清理项目
./hvigorw clean

# 构建 Debug 版本
./hvigorw assembleHap --mode debug

# 构建 Release 版本
./hvigorw assembleHap --mode release

# 查看构建任务
./hvigorw tasks
```

## 🔧 常见问题快速解决

### 问题：无法连接手表
```bash
# 解决方案
1. hdc kill && hdc start
2. 重新插拔 USB
3. 检查手表是否开启 USB 调试
```

### 问题：编译失败
```bash
# 解决方案
1. Build → Clean Project
2. Build → Rebuild Project
3. 重启 DevEco Studio
```

### 问题：签名错误
```bash
# 解决方案
File → Project Structure → Signing Configs
→ Automatically generate signature
```

### 问题：应用闪退
```bash
# 解决方案
1. 查看 Logcat 日志
2. 检查权限是否授予
3. 卸载后重新安装
```

### 问题：日志不显示
```bash
# 解决方案
1. 清除过滤条件
2. 选择正确的包名
3. Log Level 改为 Debug
4. hdc kill && hdc start
```

## 📊 性能分析

### 内存分析

```
View → Tool Windows → Profiler
→ Memory → Record
```

### CPU 分析

```
Profiler → CPU → Record
```

### 网络分析

```
Profiler → Network
```

## 🎯 测试场景

### 基本功能测试

```
1. 启动应用 → 检查 UI
2. 查看日志 → 确认平台检测
3. 手机启动高德导航
4. 手表显示导航信息
5. 结束导航 → 手表显示结束状态
```

### 多平台测试

```
华为手机：
- 检查日志：HARMONYOS
- 确认通知同步工作

小米手机：
- 检查日志：HYPEROS
- 确认智慧中心连接
- 或降级到通知监听

其他 Android：
- 检查日志：ANDROID
- 确认通知监听工作
```

### 压力测试

```
1. 长时间运行（30分钟+）
2. 频繁切换应用
3. 多次息屏/亮屏
4. 断开/重连手机
```

## 📂 重要文件路径

### 项目文件

```
watch-app/
├── manifest.json           # 应用配置
├── config/build-profile.json5  # 构建配置
├── src/main.cj            # 主入口
└── src/platform/          # 平台适配层
```

### 生成文件

```
watch-app/build/
├── default/
│   └── outputs/
│       └── entry-default-signed.hap  # 签名后的安装包
└── intermediates/         # 中间文件
```

### 日志文件（手表上）

```
/data/log/hilog/           # 系统日志
/data/app/[package]/       # 应用数据
```

## 🌐 有用的链接

- [DevEco Studio 文档](https://developer.harmonyos.com/cn/develop/deveco-studio)
- [HarmonyOS API 参考](https://developer.harmonyos.com/cn/docs/documentation/doc-references/js-apis-overview-0000001281201030)
- [仓颉语言指南](https://developer.huawei.com/consumer/cn/cangjie)
- [hdc 工具文档](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/hdc-0000001050166905)

## 📞 获取帮助

- 项目 README: `watch-app/README.md`
- 详细测试指南: `watch-app/DEVECO_TESTING_GUIDE.md`
- 多平台支持: `watch-app/MULTI_PLATFORM_SUPPORT.md`
- 开发文档: `watch-app/DEVELOPMENT.md`

---

**快速查找，快速解决！** ⚡
