/**
 * 高德地图导航手表应用 - 主入口
 * 支持多平台：HarmonyOS、Android、HyperOS
 * 支持小米智慧中心接入
 */

package navigation

import navigation.ui.NavigationView
import navigation.service.NotificationListenerService
import navigation.model.NavigationData
import navigation.utils.Constants
import navigation.platform.*
import ohos.aafwk.ability.Ability
import ohos.aafwk.content.Intent
import ohos.agp.window.dialog.ToastDialog
import ohos.app.Context

/**
 * 导航手表应用主类
 * 支持多平台自动适配
 */
public class NavigationWatchApp extends Ability {

    private var navigationView: NavigationView? = null
    private var notificationService: NotificationListenerService? = null
    private var platformService: IPlatformService? = null
    private var context: Context? = null
    private var currentPlatform: PlatformType = PlatformType.UNKNOWN

    /**
     * 应用启动时调用
     */
    public override func onStart(intent: Intent) {
        super.onStart(intent)

        context = getContext()
        logInfo("应用启动")

        // 检测平台
        detectAndInitPlatform()

        // 设置UI界面
        setupUI()

        // 启动平台服务
        startPlatformService()

        // 检查权限
        checkPermissions()

        // 显示欢迎提示
        showWelcomeToast()
    }

    /**
     * 检测并初始化平台
     */
    private func detectAndInitPlatform() {
        // 检测当前运行平台
        currentPlatform = PlatformDetector.detectPlatform()
        let platformVersion = PlatformDetector.getPlatformVersion()

        logInfo("检测到平台: ${currentPlatform.toString()}, 版本: ${platformVersion}")

        // 创建对应平台的服务
        platformService = PlatformServiceFactory.createService()

        // 初始化平台服务
        if (!platformService?.initialize() == true) {
            logError("平台服务初始化失败")
            showErrorToast("平台初始化失败")
        }

        // 显示平台信息
        showPlatformInfo()
    }

    /**
     * 显示平台信息
     */
    private func showPlatformInfo() {
        let platformName = match (currentPlatform) {
            case HARMONYOS => "鸿蒙系统"
            case ANDROID => "安卓系统"
            case HYPEROS => "小米澎湃系统"
            case _ => "未知系统"
        }

        logInfo("运行在: ${platformName}")

        // 如果是小米系统，检查智慧中心
        if (currentPlatform == PlatformType.HYPEROS) {
            logInfo("支持小米智慧中心接入")
        }
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
     * 启动平台服务
     */
    private func startPlatformService() {
        try {
            // 设置回调
            platformService?.setNavigationCallback(object : NavigationCallback {
                override func onNavigationDataReceived(data: NavigationData) {
                    // 更新 UI
                    navigationView?.updateNavigationData(data)
                }

                override func onNavigationEnded() {
                    // 显示导航结束状态
                    navigationView?.showNavigationEndedState()
                }

                override func onError(error: String) {
                    // 显示错误
                    navigationView?.showErrorState(error)
                    logError("平台服务错误: ${error}")
                }
            })

            // 启动服务
            if (!platformService?.startNotificationListener() == true) {
                logError("启动平台服务失败")
                showErrorToast("服务启动失败")
                return
            }

            logInfo("平台服务已启动")

            // 显示特定平台的提示
            showPlatformSpecificTip()

        } catch (e: Exception) {
            logError("启动平台服务失败: ${e.message}")
            showErrorToast("服务启动失败")
        }
    }

    /**
     * 显示平台特定提示
     */
    private func showPlatformSpecificTip() {
        let tip = match (currentPlatform) {
            case HARMONYOS => "使用鸿蒙通知同步功能"
            case ANDROID => "使用 Android 通知监听服务"
            case HYPEROS => "支持小米智慧中心，获得更好体验"
            case _ => "通用模式"
        }

        logInfo(tip)
    }

    /**
     * 检查权限
     */
    private func checkPermissions() {
        // 使用平台服务检查权限
        if (!platformService?.hasNotificationPermission() == true) {
            logInfo("缺少通知访问权限")

            // 请求权限
            platformService?.requestPermissions()

            // 显示特定平台的权限提示
            showPermissionTip()
        } else {
            logInfo("已具有必要权限")
        }
    }

    /**
     * 显示权限提示
     */
    private func showPermissionTip() {
        let tip = match (currentPlatform) {
            case HARMONYOS => "请在鸿蒙设置中授予通知访问权限"
            case ANDROID => "请在 Android 设置中授予通知访问权限"
            case HYPEROS => "请在小米设置中授予通知访问权限和智慧中心权限"
            case _ => "请在设置中授予通知访问权限"
        }

        showToast(tip)
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
        // 停止平台服务
        if (platformService != null) {
            platformService?.stopNotificationListener()
            platformService = null
        }

        // 停止通知服务（兼容旧版本）
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
