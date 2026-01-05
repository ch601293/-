# 资源文件说明

本目录包含应用所需的各种资源文件。

## 目录结构

```
resources/
├── media/              # 图片和图标资源
│   ├── icon.png       # 应用图标
│   ├── arrow_straight.png    # 直行箭头
│   ├── arrow_left.png        # 左转箭头
│   ├── arrow_right.png       # 右转箭头
│   ├── arrow_uturn.png       # 掉头箭头
│   ├── flag_finish.png       # 到达标志
│   └── navigation_waiting.png # 等待图标
└── strings/           # 字符串资源
    ├── zh_CN.json    # 简体中文
    ├── en_US.json    # 英文
    └── zh_TW.json    # 繁体中文
```

## 图标资源说明

### 应用图标 (icon.png)

- **尺寸**：256x256 像素
- **格式**：PNG（带透明通道）
- **设计要求**：
  - 简洁清晰，符合手表小屏幕显示
  - 使用高德地图配色（蓝色系）
  - 包含导航相关元素

### 导航箭头图标

所有箭头图标应满足：
- **尺寸**：120x120 像素
- **格式**：PNG（带透明通道）
- **颜色**：主色调蓝色 (#1E90FF)
- **风格**：扁平化设计，线条粗细适中

#### 箭头类型

1. **arrow_straight.png** - 直行
   - 向上的箭头

2. **arrow_left.png** - 左转
   - 向左的弯曲箭头

3. **arrow_right.png** - 右转
   - 向右的弯曲箭头

4. **arrow_uturn.png** - 掉头
   - U型转弯箭头

5. **arrow_left_front.png** - 左前方
   - 向左前方的斜箭头

6. **arrow_right_front.png** - 右前方
   - 向右前方的斜箭头

7. **arrow_merge_left.png** - 靠左
   - 两条车道合并向左的箭头

8. **arrow_merge_right.png** - 靠右
   - 两条车道合并向右的箭头

9. **arrow_roundabout.png** - 环岛
   - 环形箭头

10. **arrow_exit.png** - 出口
    - 向右上方的出口箭头

### 状态图标

1. **flag_finish.png** - 到达目的地
   - 旗帜图标
   - 颜色：绿色 (#00C853)

2. **navigation_waiting.png** - 等待导航
   - 导航指针图标
   - 颜色：灰色 (#666666)

## 字符串资源说明

字符串资源使用 JSON 格式，支持多语言。

### 字符串 ID 命名规范

- 使用小写字母和下划线
- 使用语义化的命名
- 按功能模块分组

示例：
```json
{
  "app_name": "高德导航",
  "nav_straight": "直行",
  "nav_left_turn": "左转",
  "status_waiting": "等待导航...",
  "error_no_permission": "请授予通知访问权限"
}
```

### 支持的语言

1. **zh_CN** - 简体中文（默认）
2. **en_US** - 英文
3. **zh_TW** - 繁体中文

## 颜色资源

颜色定义在 `Constants.cj` 中，使用 ARGB 格式：

```cangjie
public static let COLOR_PRIMARY: Int32 = 0xFF1E90FF      // 主色调
public static let COLOR_SUCCESS: Int32 = 0xFF00C853      // 成功
public static let COLOR_WARNING: Int32 = 0xFFFFA500      // 警告
public static let COLOR_DANGER: Int32 = 0xFFFF4444       // 危险
public static let COLOR_TEXT_PRIMARY: Int32 = 0xFF333333 // 主要文字
public static let COLOR_TEXT_SECONDARY: Int32 = 0xFF666666 // 次要文字
public static let COLOR_BACKGROUND: Int32 = 0xFFFFFFFF   // 背景
```

## 资源使用示例

### 在代码中使用图标

```cangjie
// 加载图标资源
let iconPath = "resources/media/arrow_left.png"
directionIcon?.setPixelMap(loadIconResource(iconPath))
```

### 在代码中使用字符串

```cangjie
// 加载字符串资源
let appName = getString("app_name")
statusText?.setText(appName)
```

## 添加新资源

### 添加新图标

1. 准备符合规范的 PNG 图片
2. 将图片放入 `resources/media/` 目录
3. 在代码中引用：`resources/media/your_icon.png`

### 添加新字符串

1. 在 `resources/strings/zh_CN.json` 中添加键值对
2. 在其他语言文件中添加对应的翻译
3. 在代码中使用 `getString("your_key")`

## 资源优化建议

### 图片优化

1. **压缩图片**：使用 TinyPNG 等工具压缩
2. **使用 WebP**：考虑使用 WebP 格式（体积更小）
3. **适配分辨率**：提供 @2x、@3x 等多倍图

### 字符串优化

1. **避免硬编码**：所有显示文本都应使用字符串资源
2. **统一术语**：保持翻译一致性
3. **简洁明了**：手表屏幕小，文字要简短

## 资源许可

- 应用图标：自行设计或购买商业授权
- 箭头图标：可使用开源图标库（如 Material Icons）
- 确保所有资源都有合法的使用权限

## 设计工具推荐

- **Figma** - UI 设计
- **Sketch** - 图标设计
- **Adobe Illustrator** - 矢量图形
- **GIMP** - 图片编辑（免费）

## 参考资源

- [Material Design Icons](https://materialdesignicons.com/)
- [Iconify](https://iconify.design/)
- [Unsplash](https://unsplash.com/) - 免费图片资源
- [华为设计规范](https://developer.harmonyos.com/cn/design/)

---

**注意**：请确保所有使用的资源都符合版权要求，尊重原创作者的权益。
