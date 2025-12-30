# 华为 GT5 手表 - 高德地图导航应用

> 使用仓颉语言开发的智能手表导航应用

## 📱 项目简介

这是一个使用**仓颉语言**为**华为 GT5 手表**开发的应用，可以实时显示手机上**高德地图的导航内容**。通过 HarmonyOS 的通知同步机制，无需在手机端进行额外开发，即可在手表上查看导航信息。

## ✨ 核心特性

- ✅ **实时导航显示** - 显示导航指令、距离、道路信息
- ✅ **智能通知监听** - 自动监听并解析高德地图通知
- ✅ **无需手机开发** - 利用 HarmonyOS 通知同步，零配置
- ✅ **低功耗设计** - 基于事件驱动，不需持续连接
- ✅ **多语言支持** - 支持简体中文、繁体中文、英文
- ✅ **优化界面** - 专为手表圆形屏幕设计

## 🚀 快速开始

### 安装要求

- 华为 GT5 手表（或其他支持 HarmonyOS 的智能手表）
- HarmonyOS 3.0+ 系统
- 已安装高德地图的手机
- DevEco Studio 4.0+（用于开发）

### 5分钟上手

1. **安装应用** - 将应用安装到手表
2. **授予权限** - 在设置中开启通知访问权限
3. **启动导航** - 在手机上使用高德地图导航
4. **查看手表** - 在手表上实时查看导航信息

详细步骤请查看 [快速开始指南](watch-app/QUICK_START.md)

## 📂 项目结构

```
watch-app/
├── src/
│   ├── main.cj                      # 主入口
│   ├── model/
│   │   └── NavigationData.cj       # 导航数据模型
│   ├── service/
│   │   ├── NotificationListener.cj # 通知监听服务 ⭐
│   │   ├── NavigationParser.cj     # 数据解析器 ⭐
│   │   └── BluetoothService.cj     # 蓝牙服务
│   ├── ui/
│   │   └── NavigationView.cj       # UI界面 ⭐
│   └── utils/
│       └── Constants.cj            # 常量定义
├── resources/                       # 资源文件
├── config/                         # 配置文件
└── docs/                           # 文档
    ├── README.md                   # 项目说明
    ├── QUICK_START.md             # 快速开始
    └── DEVELOPMENT.md             # 开发文档
```

## 🎯 工作原理

```
┌──────────────────┐
│  手机 - 高德地图  │
│   开始导航        │
└────────┬─────────┘
         │ 生成通知
         │
         ↓
┌──────────────────┐
│  HarmonyOS       │
│  通知同步到手表   │
└────────┬─────────┘
         │
         ↓
┌──────────────────┐
│  手表 - 本应用    │
│  ① 监听通知       │
│  ② 解析数据       │
│  ③ 显示导航       │
└──────────────────┘
```

## 🔧 核心技术

### 1. 通知监听服务 (NotificationListener.cj)

监听手机同步到手表的高德地图通知，自动识别导航内容。

```cangjie
func onNotificationReceived(notification: Notification) {
    if (isAmapNavigation(notification)) {
        let navData = parseNavigation(notification)
        updateUI(navData)
    }
}
```

### 2. 智能数据解析 (NavigationParser.cj)

从通知文本中提取导航信息：
- 导航类型（左转、右转、直行等）
- 距离信息（500米、1.5公里等）
- 道路名称
- 剩余时间

### 3. 手表UI界面 (NavigationView.cj)

专为手表优化的显示界面：
- 大字体显示距离
- 清晰的导航图标
- 多状态显示（导航中、等待、结束）

## 📱 界面预览

```
┌─────────────────────┐
│   正在导航...       │
├─────────────────────┤
│         ↑          │  ← 导航箭头
├─────────────────────┤
│      500米          │  ← 距离（大字）
├─────────────────────┤
│      左转           │  ← 导航指令
├─────────────────────┤
│   → 中山路          │  ← 下条道路
├─────────────────────┤
│ 剩余 3.5km·15分钟   │  ← 剩余信息
└─────────────────────┘
```

## 📚 文档导航

| 文档 | 说明 |
|------|------|
| [README.md](watch-app/README.md) | 完整的项目说明文档 |
| [QUICK_START.md](watch-app/QUICK_START.md) | 快速开始指南 |
| [DEVELOPMENT.md](watch-app/DEVELOPMENT.md) | 开发者文档 |
| [PROJECT_SUMMARY.md](watch-app/PROJECT_SUMMARY.md) | 项目总结 |

## 🛠 开发与构建

### 环境配置

```bash
# 1. 安装 DevEco Studio
# 2. 配置 HarmonyOS SDK
# 3. 安装仓颉语言插件
```

### 构建应用

```bash
# 进入项目目录
cd watch-app

# 构建 HAP 包
hvigorw assembleHap

# 安装到手表
hdc install entry-default-signed.hap
```

详细开发指南请查看 [DEVELOPMENT.md](watch-app/DEVELOPMENT.md)

## 🎨 技术亮点

### 使用仓颉语言的优势

- ⚡ **高性能** - 编译为原生代码，运行效率高
- 🛡️ **类型安全** - 强类型系统，减少运行时错误
- 🔒 **内存安全** - 自动内存管理，避免内存泄漏
- 🔄 **并发支持** - 原生支持并发编程
- 🤝 **深度集成** - 与 HarmonyOS SDK 无缝集成

### 架构设计

- **分层架构** - Model-Service-UI 清晰分层
- **低耦合** - 模块职责明确，易于维护
- **事件驱动** - 基于通知和回调的事件模型
- **资源优化** - 针对手表设备的低功耗优化

## 📊 项目统计

- **代码文件**：8 个 (.cj)
- **代码行数**：约 1,400 行
- **文档文件**：6 个
- **支持语言**：3 种（中文简繁体、英文）
- **许可协议**：MIT License

## 🔮 未来计划

### v1.1 (短期)
- [ ] 添加导航图标资源
- [ ] 实现设置页面
- [ ] 支持主题切换

### v1.2 (中期)
- [ ] 支持百度地图、腾讯地图
- [ ] 添加语音提示
- [ ] 导航历史记录

### v2.0 (长期)
- [ ] 开发配套手机端应用
- [ ] 地图显示功能
- [ ] 路径规划功能

## 🤝 贡献指南

欢迎贡献代码、报告问题或提出建议！

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](watch-app/LICENSE) 文件了解详情

## 📞 联系方式

- 项目主页：[GitHub Repository]
- 问题反馈：[GitHub Issues]
- 讨论交流：[GitHub Discussions]

## 🙏 致谢

感谢以下技术和平台的支持：

- **华为 HarmonyOS** - 优秀的智能设备操作系统
- **仓颉语言** - 高效的现代编程语言
- **高德地图** - 专业的地图导航服务
- **开源社区** - 提供的灵感和参考

## ⭐ Star History

如果这个项目对你有帮助，请给它一个 Star ⭐

---

**开发者寄语**：希望这个应用能让手表导航体验更加便捷！🚗📍⌚

**版本**：v1.0.0
**最后更新**：2024-12-30
