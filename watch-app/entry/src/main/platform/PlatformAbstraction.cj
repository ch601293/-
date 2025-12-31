/**
 * 平台抽象层
 * 定义跨平台接口，支持 HarmonyOS、Android、HyperOS 等
 */

package navigation.platform

import navigation.model.NavigationData

/**
 * 平台类型枚举
 */
public enum PlatformType {
    | HARMONYOS        // 鸿蒙系统
    | ANDROID          // 安卓系统
    | HYPEROS          // 澎湃系统（小米）
    | UNKNOWN          // 未知平台
}

/**
 * 平台检测器
 */
public class PlatformDetector {

    /**
     * 检测当前运行平台
     */
    public static func detectPlatform(): PlatformType {
        // 检测 HarmonyOS
        if (isHarmonyOS()) {
            return PlatformType.HARMONYOS
        }

        // 检测 HyperOS（小米澎湃系统）
        if (isHyperOS()) {
            return PlatformType.HYPEROS
        }

        // 检测 Android
        if (isAndroid()) {
            return PlatformType.ANDROID
        }

        return PlatformType.UNKNOWN
    }

    /**
     * 检测是否为 HarmonyOS
     */
    private static func isHarmonyOS(): Bool {
        // 检查系统属性
        try {
            let osName = System.getProperty("os.name")
            if (osName != null && osName.contains("HarmonyOS")) {
                return true
            }

            // 检查是否存在 HarmonyOS 特有的类
            // Class.forName("ohos.app.Context")
            return true  // 简化判断
        } catch (e: Exception) {
            return false
        }
    }

    /**
     * 检测是否为 HyperOS（小米澎湃系统）
     */
    private static func isHyperOS(): Bool {
        try {
            // 检查小米系统属性
            let miuiVersion = System.getProperty("ro.miui.ui.version.name")
            if (miuiVersion != null) {
                // HyperOS 是基于 MIUI 的
                let buildVersion = System.getProperty("ro.mi.os.version.name")
                if (buildVersion != null && buildVersion.contains("OS")) {
                    return true
                }
            }
        } catch (e: Exception) {
            return false
        }
        return false
    }

    /**
     * 检测是否为 Android
     */
    private static func isAndroid(): Bool {
        try {
            let osName = System.getProperty("java.vendor")
            if (osName != null && osName.contains("Android")) {
                return true
            }
        } catch (e: Exception) {
            return false
        }
        return false
    }

    /**
     * 获取平台版本号
     */
    public static func getPlatformVersion(): String {
        let platform = detectPlatform()

        match (platform) {
            case HARMONYOS => {
                return System.getProperty("ohos.version.name") ?? "Unknown"
            }
            case HYPEROS => {
                return System.getProperty("ro.mi.os.version.name") ?? "Unknown"
            }
            case ANDROID => {
                return System.getProperty("ro.build.version.release") ?? "Unknown"
            }
            case _ => {
                return "Unknown"
            }
        }
    }
}

/**
 * 平台服务接口
 * 定义跨平台的通用接口
 */
public interface IPlatformService {

    /**
     * 初始化平台服务
     */
    func initialize(): Bool

    /**
     * 启动通知监听
     */
    func startNotificationListener(): Bool

    /**
     * 停止通知监听
     */
    func stopNotificationListener(): Bool

    /**
     * 请求必要权限
     */
    func requestPermissions(): Bool

    /**
     * 检查是否有通知访问权限
     */
    func hasNotificationPermission(): Bool

    /**
     * 发送数据到手机端（如果需要）
     */
    func sendDataToPhone(data: String): Bool

    /**
     * 从手机端接收数据
     */
    func receiveDataFromPhone(): String?

    /**
     * 设置导航数据回调
     */
    func setNavigationCallback(callback: NavigationCallback): Unit
}

/**
 * 导航数据回调接口
 */
public interface NavigationCallback {
    func onNavigationDataReceived(data: NavigationData): Unit
    func onNavigationEnded(): Unit
    func onError(error: String): Unit
}

/**
 * 平台服务工厂
 */
public class PlatformServiceFactory {

    /**
     * 创建适合当前平台的服务实例
     */
    public static func createService(): IPlatformService {
        let platform = PlatformDetector.detectPlatform()

        match (platform) {
            case HARMONYOS => {
                return HarmonyOSService()
            }
            case HYPEROS => {
                return HyperOSService()
            }
            case ANDROID => {
                return AndroidService()
            }
            case _ => {
                // 默认返回 HarmonyOS 服务
                return HarmonyOSService()
            }
        }
    }

    /**
     * 创建指定平台的服务实例
     */
    public static func createService(platform: PlatformType): IPlatformService {
        match (platform) {
            case HARMONYOS => {
                return HarmonyOSService()
            }
            case HYPEROS => {
                return HyperOSService()
            }
            case ANDROID => {
                return AndroidService()
            }
            case _ => {
                return HarmonyOSService()
            }
        }
    }
}
