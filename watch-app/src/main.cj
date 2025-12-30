/**
 * 高德地图导航手表应用 - 主入口
 * 华为 GT5 手表应用
 */

package navigation

import navigation.ui.NavigationView
import navigation.service.NotificationListenerService
import navigation.model.NavigationData
import navigation.utils.Constants
import ohos.aafwk.ability.Ability
import ohos.aafwk.content.Intent
import ohos.agp.window.dialog.ToastDialog
import ohos.app.Context

/**
 * 导航手表应用主类
 */
public class NavigationWatchApp extends Ability {

    private var navigationView: NavigationView? = null
    private var notificationService: NotificationListenerService? = null
    private var context: Context? = null

    /**
     * 应用启动时调用
     */
    public override func onStart(intent: Intent) {
        super.onStart(intent)

        context = getContext()
        logInfo("应用启动")

        // 设置UI界面
        setupUI()

        // 启动通知监听服务
        startNotificationService()

        // 检查权限
        checkPermissions()

        // 显示欢迎提示
        showWelcomeToast()
    }

    /**
     * 设置UI界面
     */
    private func setupUI() {
        if (context == null) {
            logError("Context 为空，无法初始化 UI")
            return
        }

        // 创建导航视图
        navigationView = NavigationView(context!)

        // 设置为主界面
        setUIContent(navigationView)

        logInfo("UI 界面已设置")
    }

    /**
     * 启动通知监听服务
     */
    private func startNotificationService() {
        try {
            // 创建通知监听服务
            notificationService = NotificationListenerService()

            // 启动服务
            let serviceIntent = Intent()
            serviceIntent.setElementName(
                Constants.AMAP_PACKAGE_NAME,
                Constants.NOTIFICATION_LISTENER_SERVICE
            )
            startAbility(serviceIntent)

            // 将服务与 UI 关联
            if (navigationView != null && notificationService != null) {
                navigationView?.setNotificationService(notificationService!)
            }

            logInfo("通知监听服务已启动")

        } catch (e: Exception) {
            logError("启动通知监听服务失败: ${e.message}")
            showErrorToast("服务启动失败")
        }
    }

    /**
     * 检查权限
     */
    private func checkPermissions() {
        // 检查通知访问权限
        if (!hasNotificationPermission()) {
            logInfo("缺少通知访问权限")
            requestNotificationPermission()
        }

        // 检查蓝牙权限
        if (!hasBluetoothPermission()) {
            logInfo("缺少蓝牙权限")
            requestBluetoothPermission()
        }
    }

    /**
     * 检查是否有通知访问权限
     */
    private func hasNotificationPermission(): Bool {
        // 这里应该调用系统权限检查 API
        // 暂时返回 true
        return true
    }

    /**
     * 请求通知访问权限
     */
    private func requestNotificationPermission() {
        // 这里应该调用系统权限请求 API
        logInfo("请求通知访问权限")

        // 显示提示
        showToast("请在设置中授予通知访问权限")
    }

    /**
     * 检查是否有蓝牙权限
     */
    private func hasBluetoothPermission(): Bool {
        // 这里应该调用系统权限检查 API
        return true
    }

    /**
     * 请求蓝牙权限
     */
    private func requestBluetoothPermission() {
        // 这里应该调用系统权限请求 API
        logInfo("请求蓝牙权限")
    }

    /**
     * 显示欢迎提示
     */
    private func showWelcomeToast() {
        showToast("高德导航手表助手已启动")
    }

    /**
     * 显示提示消息
     */
    private func showToast(message: String) {
        if (context != null) {
            ToastDialog(context!)
                .setText(message)
                .setDuration(2000)
                .show()
        }
    }

    /**
     * 显示错误提示
     */
    private func showErrorToast(message: String) {
        if (context != null) {
            ToastDialog(context!)
                .setText("错误: ${message}")
                .setDuration(3000)
                .show()
        }
    }

    /**
     * 应用进入前台时调用
     */
    public override func onActive() {
        super.onActive()
        logInfo("应用进入前台")

        // 刷新导航数据
        refreshNavigationData()
    }

    /**
     * 应用进入后台时调用
     */
    public override func onInactive() {
        super.onInactive()
        logInfo("应用进入后台")
    }

    /**
     * 应用停止时调用
     */
    public override func onStop() {
        super.onStop()
        logInfo("应用停止")

        // 清理资源
        cleanup()
    }

    /**
     * 刷新导航数据
     */
    private func refreshNavigationData() {
        if (notificationService != null) {
            let navData = notificationService?.getCurrentNavigationData()
            if (navData != null && navigationView != null) {
                navigationView?.updateNavigationData(navData!)
            }
        }
    }

    /**
     * 清理资源
     */
    private func cleanup() {
        // 停止服务
        if (notificationService != null) {
            notificationService?.onStop()
            notificationService = null
        }

        // 清理 UI
        navigationView = null
        context = null

        logInfo("资源清理完成")
    }

    /**
     * 日志输出
     */
    private func logInfo(message: String) {
        println("[${Constants.LOG_TAG}] INFO: ${message}")
    }

    private func logError(message: String) {
        println("[${Constants.LOG_TAG}] ERROR: ${message}")
    }

    /**
     * 处理用户输入
     */
    public override func onKeyDown(keyCode: Int32, keyEvent: KeyEvent): Bool {
        // 处理返回键
        if (keyCode == KeyEvent.CODE_BACK) {
            // 询问用户是否退出
            return handleBackKey()
        }

        return super.onKeyDown(keyCode, keyEvent)
    }

    /**
     * 处理返回键
     */
    private func handleBackKey(): Bool {
        // 可以实现退出确认对话框
        // 暂时直接返回 false，允许系统处理
        return false
    }
}

/**
 * 应用入口点
 */
@main
func main() {
    // 这里可以进行一些全局初始化
    println("高德导航手表应用初始化")
}
