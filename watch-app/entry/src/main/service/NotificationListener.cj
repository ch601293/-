/**
 * 通知监听服务
 * 监听从手机同步到手表的高德地图导航通知
 */

package navigation.service

import navigation.model.NavigationData
import navigation.utils.Constants
import ohos.app.*
import ohos.event.notification.*
import ohos.rpc.*

/**
 * 通知监听服务
 * 注意：需要用户在手表设置中授予通知监听权限
 */
public class NotificationListenerService extends Ability {

    private var navigationParser: NavigationParser = NavigationParser()
    private var bluetoothService: BluetoothService? = null
    private var currentNavData: NavigationData? = null
    private var eventHandler: InnerEventHandler? = null

    // 数据更新回调接口
    public interface NavigationDataCallback {
        func onNavigationDataUpdate(data: NavigationData): Unit
        func onNavigationStatusChange(isNavigating: Bool): Unit
    }

    private var dataCallback: NavigationDataCallback? = null

    /**
     * 服务启动时调用
     */
    public override func onStart(intent: Intent) {
        super.onStart(intent)
        logInfo("通知监听服务启动")

        // 初始化蓝牙服务
        bluetoothService = BluetoothService()
        bluetoothService?.initialize()

        // 初始化事件处理器
        initEventHandler()

        // 订阅通知
        subscribeNotifications()
    }

    /**
     * 初始化事件处理器
     */
    private func initEventHandler() {
        eventHandler = InnerEventHandler()
    }

    /**
     * 订阅通知
     */
    private func subscribeNotifications() {
        try {
            // 创建通知订阅器
            let subscriber = NotificationSubscriber()

            // 设置通知回调
            subscriber.setOnConsumed(onNotificationReceived)
            subscriber.setOnCanceled(onNotificationRemoved)

            // 订阅所有通知
            NotificationHelper.subscribeNotification(subscriber)

            logInfo("通知订阅成功")
        } catch (e: Exception) {
            logError("通知订阅失败: ${e.message}")
        }
    }

    /**
     * 收到通知时的回调
     */
    private func onNotificationReceived(notification: Notification) {
        // 获取通知信息
        let packageName = notification.getBundleName()
        let title = notification.getTitle()
        let content = notification.getText()

        logInfo("收到通知 - 包名: ${packageName}, 标题: ${title}, 内容: ${content}")

        // 判断是否为导航通知
        if (navigationParser.isNavigationNotification(packageName, content)) {
            // 解析导航数据
            let navData = navigationParser.parseNotification(title, content)

            // 更新当前导航数据
            currentNavData = navData

            // 通知UI更新
            dataCallback?.onNavigationDataUpdate(navData)

            // 通过蓝牙发送数据（如果需要）
            sendDataViaBluetooth(navData)

            logInfo("导航数据已更新: ${navData.instruction}")
        }
    }

    /**
     * 通知被移除时的回调
     */
    private func onNotificationRemoved(notification: Notification) {
        let packageName = notification.getBundleName()

        // 如果是高德地图的通知被移除，可能导航已结束
        var isAmapNotification = false
        for (pkgName in Constants.AMAP_PACKAGE_NAMES) {
            if (packageName == pkgName) {
                isAmapNotification = true
                break
            }
        }

        if (isAmapNotification) {
            logInfo("高德地图通知已移除，导航可能已结束")

            // 重置导航状态
            currentNavData?.isNavigating = false
            dataCallback?.onNavigationStatusChange(false)
        }
    }

    /**
     * 通过蓝牙发送导航数据
     */
    private func sendDataViaBluetooth(navData: NavigationData) {
        // 将导航数据序列化为JSON或其他格式
        let dataJson = serializeNavigationData(navData)

        // 通过蓝牙发送
        bluetoothService?.sendData(dataJson)
    }

    /**
     * 序列化导航数据
     */
    private func serializeNavigationData(navData: NavigationData): String {
        // 构建简单的JSON格式字符串
        let json = """
        {
            "instruction": "${navData.instruction}",
            "navType": "${navData.navType.toString()}",
            "distance": ${navData.distance},
            "currentRoad": "${navData.currentRoad}",
            "nextRoad": "${navData.nextRoad}",
            "remainingDistance": ${navData.remainingDistance},
            "remainingTime": ${navData.remainingTime},
            "currentSpeed": ${navData.currentSpeed},
            "isNavigating": ${navData.isNavigating},
            "timestamp": ${navData.timestamp}
        }
        """

        return json
    }

    /**
     * 设置数据更新回调
     */
    public func setNavigationDataCallback(callback: NavigationDataCallback) {
        dataCallback = callback
    }

    /**
     * 获取当前导航数据
     */
    public func getCurrentNavigationData(): NavigationData? {
        return currentNavData
    }

    /**
     * 服务停止时调用
     */
    public override func onStop() {
        super.onStop()
        logInfo("通知监听服务停止")

        // 清理资源
        bluetoothService?.disconnect()
        bluetoothService = null
        currentNavData = null
    }

    /**
     * 日志输出
     */
    private func logInfo(message: String) {
        // 这里应该使用 HarmonyOS 的日志API
        println("[${Constants.LOG_TAG}] INFO: ${message}")
    }

    private func logError(message: String) {
        println("[${Constants.LOG_TAG}] ERROR: ${message}")
    }
}

/**
 * 通知订阅器
 */
class NotificationSubscriber {
    private var onConsumedCallback: ((Notification) -> Unit)? = null
    private var onCanceledCallback: ((Notification) -> Unit)? = null

    public func setOnConsumed(callback: (Notification) -> Unit) {
        onConsumedCallback = callback
    }

    public func setOnCanceled(callback: (Notification) -> Unit) {
        onCanceledCallback = callback
    }

    /**
     * 收到通知时调用
     */
    public func onConsumed(notification: Notification) {
        onConsumedCallback?(notification)
    }

    /**
     * 通知被移除时调用
     */
    public func onCanceled(notification: Notification) {
        onCanceledCallback?(notification)
    }
}

/**
 * 内部事件处理器
 */
class InnerEventHandler {
    public init() {}

    public func handleEvent(event: InnerEvent) {
        // 处理内部事件
    }
}
