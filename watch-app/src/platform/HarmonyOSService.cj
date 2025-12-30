/**
 * HarmonyOS 平台服务实现
 */

package navigation.platform

import navigation.model.NavigationData
import navigation.service.NotificationListenerService
import navigation.service.NavigationParser
import navigation.utils.Constants

/**
 * HarmonyOS 平台服务
 */
public class HarmonyOSService implements IPlatformService {

    private var notificationService: NotificationListenerService? = null
    private var navigationParser: NavigationParser = NavigationParser()
    private var navigationCallback: NavigationCallback? = null
    private var isInitialized: Bool = false

    public init() {}

    /**
     * 初始化服务
     */
    public override func initialize(): Bool {
        try {
            logInfo("初始化 HarmonyOS 平台服务")

            // 创建通知监听服务
            notificationService = NotificationListenerService()

            // 设置回调
            setupCallbacks()

            isInitialized = true
            logInfo("HarmonyOS 平台服务初始化成功")
            return true

        } catch (e: Exception) {
            logError("HarmonyOS 平台服务初始化失败: ${e.message}")
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
            // 启动 HarmonyOS 通知监听服务
            notificationService?.onStart(null)
            logInfo("通知监听服务已启动")
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
            notificationService?.onStop()
            logInfo("通知监听服务已停止")
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
        logInfo("HarmonyOS: 请引导用户在设置中授予通知访问权限")

        // HarmonyOS 的通知访问权限需要用户在设置中手动授予
        // 这里返回 true 表示已发起请求
        return true
    }

    /**
     * 检查通知访问权限
     */
    public override func hasNotificationPermission(): Bool {
        // 调用 HarmonyOS API 检查权限
        // 这里简化处理
        return true
    }

    /**
     * 发送数据到手机（HarmonyOS 主要通过通知同步，此方法可选）
     */
    public override func sendDataToPhone(data: String): Bool {
        logInfo("HarmonyOS: 通过通知同步机制，无需主动发送")
        return true
    }

    /**
     * 接收来自手机的数据
     */
    public override func receiveDataFromPhone(): String? {
        // HarmonyOS 通过通知自动接收
        return null
    }

    /**
     * 设置导航数据回调
     */
    public override func setNavigationCallback(callback: NavigationCallback) {
        navigationCallback = callback
    }

    /**
     * 设置回调
     */
    private func setupCallbacks() {
        notificationService?.setNavigationDataCallback(
            object : NotificationListenerService.NavigationDataCallback {
                override func onNavigationDataUpdate(data: NavigationData) {
                    navigationCallback?.onNavigationDataReceived(data)
                }

                override func onNavigationStatusChange(isNavigating: Bool) {
                    if (!isNavigating) {
                        navigationCallback?.onNavigationEnded()
                    }
                }
            }
        )
    }

    /**
     * 日志输出
     */
    private func logInfo(message: String) {
        println("[${Constants.LOG_TAG}][HarmonyOS] INFO: ${message}")
    }

    private func logError(message: String) {
        println("[${Constants.LOG_TAG}][HarmonyOS] ERROR: ${message}")
    }
}
