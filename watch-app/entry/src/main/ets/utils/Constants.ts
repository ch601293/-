/**
 * 常量定义
 */

export class Constants {
  // 高德地图包名
  static readonly AMAP_PACKAGE_NAME: string = 'com.autonavi.minimap';

  // 备用包名（高德地图可能有不同版本）
  static readonly AMAP_PACKAGE_NAMES: string[] = [
    'com.autonavi.minimap',        // 高德地图
    'com.amap.android.ams',         // 高德地图车机版
    'com.autonavi.amapauto'         // 高德地图车机版
  ];

  // 通知监听服务相关
  static readonly NOTIFICATION_LISTENER_SERVICE: string = 'NotificationListenerService';

  // 蓝牙相关常量
  static readonly BT_SERVICE_UUID: string = '00001101-0000-1000-8000-00805F9B34FB';
  static readonly BT_CHARACTERISTIC_UUID: string = '00002A00-0000-1000-8000-00805F9B34FB';

  // 数据传输协议标识
  static readonly PROTOCOL_HEADER: string = 'AMAP_NAV';
  static readonly PROTOCOL_VERSION: number = 1;

  // 导航关键词（用于从通知文本中提取导航信息）
  static readonly NAV_KEYWORDS: string[] = [
    '直行', '左转', '右转', '掉头',
    '左前方', '右前方', '靠左', '靠右',
    '环岛', '出口', '到达', '米', '公里',
    '小时', '分钟', '前方'
  ];

  // 距离关键词
  static readonly DISTANCE_KEYWORDS: string[] = [
    '米', '公里', 'km', 'm'
  ];

  // 时间关键词
  static readonly TIME_KEYWORDS: string[] = [
    '小时', '分钟', '秒', 'hour', 'min', 'sec'
  ];

  // UI相关常量
  static readonly SCREEN_WIDTH: number = 466;      // GT5 手表屏幕宽度
  static readonly SCREEN_HEIGHT: number = 466;     // GT5 手表屏幕高度
  static readonly FONT_SIZE_LARGE: number = 28;
  static readonly FONT_SIZE_MEDIUM: number = 20;
  static readonly FONT_SIZE_SMALL: number = 16;

  // 颜色定义（十六进制格式）
  static readonly COLOR_PRIMARY: string = '#1E90FF';      // 主色调（蓝色）
  static readonly COLOR_SUCCESS: string = '#00C853';      // 成功（绿色）
  static readonly COLOR_WARNING: string = '#FFA500';      // 警告（橙色）
  static readonly COLOR_DANGER: string = '#FF4444';       // 危险（红色）
  static readonly COLOR_TEXT_PRIMARY: string = '#333333'; // 主要文字
  static readonly COLOR_TEXT_SECONDARY: string = '#666666'; // 次要文字
  static readonly COLOR_BACKGROUND: string = '#FFFFFF';   // 背景色

  // 数据更新间隔（毫秒）
  static readonly UPDATE_INTERVAL: number = 1000;

  // 数据有效期（毫秒）- 超过此时间的数据认为无效
  static readonly DATA_VALID_DURATION: number = 30000;

  // 日志标签
  static readonly LOG_TAG: string = 'AmapNavWatch';

  // 偏好设置键名
  static readonly PREF_LAST_UPDATE_TIME: string = 'last_update_time';
  static readonly PREF_IS_CONNECTED: string = 'is_connected';
  static readonly PREF_AUTO_START: string = 'auto_start';
}
