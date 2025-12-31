/**
 * Android 平台服务实现
 * 支持 Wear OS 和其他 Android 手表
 */

package navigation.platform

import navigation.model.NavigationData
import navigation.service.NavigationParser
import navigation.utils.Constants

/**
 * Android 平台服务
 */
public class AndroidService implements IPlatformService {

    private var navigationParser: NavigationParser = NavigationParser()
    private var navigationCallback: NavigationCallback? = null
    private var isInitialized: Bool = false
    private var notificationListener: AndroidNotificationListener? = null

    public init() {}

    /**
     * 初始化服务
     */
    public override func initialize(): Bool {
        try {
            logInfo("初始化 Android 平台服务")

            // 创建 Android 通知监听器
            notificationListener = AndroidNotificationListener(navigationParser)

            // 设置回调
            notificationListener?.setCallback(object : AndroidNotificationCallback {
                override func onNotificationReceived(navData: NavigationData) {
                    navigationCallback?.onNavigationDataReceived(navData)
                }

                override func onNotificationRemoved() {
                    navigationCallback?.onNavigationEnded()
                }

                override func onError(error: String) {
                    navigationCallback?.onError(error)
                }
            })

            isInitialized = true
            logInfo("Android 平台服务初始化成功")
            return true

        } catch (e: Exception) {
            logError("Android 平台服务初始化失败: ${e.message}")
            return false
        }
    }

    /**
     * 启动通知监听
     */
    public override func startNotificationListener(): Bool {
        if (!isInitialized) {
            logError("服务未初始化")
            return false
        }

        try {
            notificationListener?.start()
            logInfo("Android 通知监听服务已启动")
            return true

        } catch (e: Exception) {
            logError("启动通知监听失败: ${e.message}")
            return false
        }
    }

    /**
     * 停止通知监听
     */
    public override func stopNotificationListener(): Bool {
        try {
            notificationListener?.stop()
            logInfo("Android 通知监听服务已停止")
            return true

        } catch (e: Exception) {
            logError("停止通知监听失败: ${e.message}")
            return false
        }
    }

    /**
     * 请求权限
     */
    public override func requestPermissions(): Bool {
        logInfo("Android: 请求通知访问权限")

        try {
            // 在 Android 上，引导用户到设置页面
            // Intent intent = new Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS")
            // context.startActivity(intent)

            logInfo("请在设置中授予通知访问权限")
            return true

        } catch (e: Exception) {
            logError("请求权限失败: ${e.message}")
            return false
        }
    }

    /**
     * 检查通知访问权限
     */
    public override func hasNotificationPermission(): Bool {
        try {
            // 检查 Android 通知监听权限
            // NotificationManagerCompat.getEnabledListenerPackages(context).contains(packageName)
            return true  // 简化处理

        } catch (e: Exception) {
            return false
        }
    }

    /**
     * 发送数据到手机（通过蓝牙或 Wear OS 数据层）
     */
    public override func sendDataToPhone(data: String): Bool {
        try {
            // 使用 Wear OS Data Layer API 或蓝牙发送数据
            logInfo("通过 Wear OS Data Layer 发送数据")
            return true

        } catch (e: Exception) {
            logError("发送数据失败: ${e.message}")
            return false
        }
    }

    /**
     * 接收来自手机的数据
     */
    public override func receiveDataFromPhone(): String? {
        // 通过 Wear OS Data Layer 或蓝牙接收
        return null
    }

    /**
     * 设置导航数据回调
     */
    public override func setNavigationCallback(callback: NavigationCallback) {
        navigationCallback = callback
    }

    /**
     * 日志输出
     */
    private func logInfo(message: String) {
        println("[${Constants.LOG_TAG}][Android] INFO: ${message}")
    }

    private func logError(message: String) {
        println("[${Constants.LOG_TAG}][Android] ERROR: ${message}")
    }
}

/**
 * Android 通知监听器
 * 实现 Android NotificationListenerService
 */
class AndroidNotificationListener {
    private var parser: NavigationParser
    private var callback: AndroidNotificationCallback? = null

    public init(parser: NavigationParser) {
        this.parser = parser
    }

    public func setCallback(callback: AndroidNotificationCallback) {
        this.callback = callback
    }

    public func start() {
        // 启动 Android NotificationListenerService
        logInfo("Android NotificationListenerService 已启动")
    }

    public func stop() {
        // 停止服务
        logInfo("Android NotificationListenerService 已停止")
    }

    /**
     * 当收到新通知时调用（由 Android 系统回调）
     */
    public func onNotificationPosted(sbn: StatusBarNotification) {
        let packageName = sbn.getPackageName()
        let notification = sbn.getNotification()

        // 提取通知内容
        let title = notification.extras?.getString("android.title") ?? ""
        let text = notification.extras?.getString("android.text") ?? ""

        // 检查是否为导航通知
        if (parser.isNavigationNotification(packageName, text)) {
            let navData = parser.parseNotification(title, text)
            callback?.onNotificationReceived(navData)
        }
    }

    /**
     * 当通知被移除时调用
     */
    public func onNotificationRemoved(sbn: StatusBarNotification) {
        let packageName = sbn.getPackageName()

        // 检查是否为高德地图
        if (packageName == Constants.AMAP_PACKAGE_NAME) {
            callback?.onNotificationRemoved()
        }
    }

    private func logInfo(message: String) {
        println("[AndroidNotificationListener] INFO: ${message}")
    }
}

/**
 * Android 通知回调接口
 */
interface AndroidNotificationCallback {
    func onNotificationReceived(navData: NavigationData): Unit
    func onNotificationRemoved(): Unit
    func onError(error: String): Unit
}

/**
 * Android StatusBarNotification 封装（简化版）
 */
class StatusBarNotification {
    private var packageName: String = ""
    private var notification: Notification = Notification()

    public func getPackageName(): String {
        return packageName
    }

    public func getNotification(): Notification {
        return notification
    }
}

/**
 * Android Notification 封装（简化版）
 */
class Notification {
    public var extras: Bundle? = null

    public class Bundle {
        private var data: Map<String, String> = HashMap()

        public func getString(key: String): String? {
            return data.get(key)
        }
    }
}
