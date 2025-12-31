/**
 * 常量定义
 */

package navigation.utils

public class Constants {
    // 高德地图包名
    public static let AMAP_PACKAGE_NAME: String = "com.autonavi.minimap"

    // 备用包名（高德地图可能有不同版本）
    public static let AMAP_PACKAGE_NAMES: Array<String> = [
        "com.autonavi.minimap",        // 高德地图
        "com.amap.android.ams",         // 高德地图车机版
        "com.autonavi.amapauto"         // 高德地图车机版
    ]

    // 通知监听服务相关
    public static let NOTIFICATION_LISTENER_SERVICE: String = "NotificationListenerService"

    // 蓝牙相关常量
    public static let BT_SERVICE_UUID: String = "00001101-0000-1000-8000-00805F9B34FB"
    public static let BT_CHARACTERISTIC_UUID: String = "00002A00-0000-1000-8000-00805F9B34FB"

    // 数据传输协议标识
    public static let PROTOCOL_HEADER: String = "AMAP_NAV"
    public static let PROTOCOL_VERSION: Int32 = 1

    // 导航关键词（用于从通知文本中提取导航信息）
    public static let NAV_KEYWORDS: Array<String> = [
        "直行", "左转", "右转", "掉头",
        "左前方", "右前方", "靠左", "靠右",
        "环岛", "出口", "到达", "米", "公里",
        "小时", "分钟", "前方"
    ]

    // 距离关键词
    public static let DISTANCE_KEYWORDS: Array<String> = [
        "米", "公里", "km", "m"
    ]

    // 时间关键词
    public static let TIME_KEYWORDS: Array<String> = [
        "小时", "分钟", "秒", "hour", "min", "sec"
    ]

    // UI相关常量
    public static let SCREEN_WIDTH: Int32 = 466      // GT5 手表屏幕宽度
    public static let SCREEN_HEIGHT: Int32 = 466     // GT5 手表屏幕高度
    public static let FONT_SIZE_LARGE: Int32 = 28
    public static let FONT_SIZE_MEDIUM: Int32 = 20
    public static let FONT_SIZE_SMALL: Int32 = 16

    // 颜色定义（ARGB格式）
    public static let COLOR_PRIMARY: Int32 = 0xFF1E90FF      // 主色调（蓝色）
    public static let COLOR_SUCCESS: Int32 = 0xFF00C853      // 成功（绿色）
    public static let COLOR_WARNING: Int32 = 0xFFFFA500      // 警告（橙色）
    public static let COLOR_DANGER: Int32 = 0xFFFF4444       // 危险（红色）
    public static let COLOR_TEXT_PRIMARY: Int32 = 0xFF333333 // 主要文字
    public static let COLOR_TEXT_SECONDARY: Int32 = 0xFF666666 // 次要文字
    public static let COLOR_BACKGROUND: Int32 = 0xFFFFFFFF   // 背景色

    // 数据更新间隔（毫秒）
    public static let UPDATE_INTERVAL: Int64 = 1000

    // 数据有效期（毫秒）- 超过此时间的数据认为无效
    public static let DATA_VALID_DURATION: Int64 = 30000

    // 日志标签
    public static let LOG_TAG: String = "AmapNavWatch"

    // 偏好设置键名
    public static let PREF_LAST_UPDATE_TIME: String = "last_update_time"
    public static let PREF_IS_CONNECTED: String = "is_connected"
    public static let PREF_AUTO_START: String = "auto_start"
}
