/**
 * 导航数据模型
 * 用于存储从高德地图解析出的导航信息
 */

package navigation.model

// 导航类型枚举
public enum NavigationType {
    | STRAIGHT       // 直行
    | LEFT_TURN      // 左转
    | RIGHT_TURN     // 右转
    | U_TURN         // 掉头
    | LEFT_FRONT     // 左前方
    | RIGHT_FRONT    // 右前方
    | LEFT_BACK      // 左后方
    | RIGHT_BACK     // 右后方
    | MERGE_LEFT     // 靠左
    | MERGE_RIGHT    // 靠右
    | ROUNDABOUT     // 环岛
    | EXIT           // 出口
    | ARRIVE         // 到达目的地
    | UNKNOWN        // 未知
}

// 导航数据类
public class NavigationData {
    // 当前导航指令（如"前方500米左转"）
    public var instruction: String = ""

    // 导航类型
    public var navType: NavigationType = NavigationType.UNKNOWN

    // 距离（单位：米）
    public var distance: Int64 = 0

    // 当前道路名称
    public var currentRoad: String = ""

    // 下一条道路名称
    public var nextRoad: String = ""

    // 剩余距离（单位：米）
    public var remainingDistance: Int64 = 0

    // 预计剩余时间（单位：秒）
    public var remainingTime: Int64 = 0

    // 当前速度（单位：km/h）
    public var currentSpeed: Int32 = 0

    // 是否正在导航
    public var isNavigating: Bool = false

    // 时间戳
    public var timestamp: Int64 = 0

    // 构造函数
    public init() {}

    // 带参数的构造函数
    public init(instruction: String, navType: NavigationType, distance: Int64) {
        this.instruction = instruction
        this.navType = navType
        this.distance = distance
        this.timestamp = getCurrentTimestamp()
    }

    // 获取当前时间戳（毫秒）
    private func getCurrentTimestamp(): Int64 {
        // 这里应该调用系统时间API
        return 0 // 占位符
    }

    // 格式化距离显示
    public func formatDistance(): String {
        if (distance < 1000) {
            return "${distance}米"
        } else {
            let km = distance / 1000
            let m = distance % 1000
            if (m == 0) {
                return "${km}公里"
            } else {
                return "${km}.${m / 100}公里"
            }
        }
    }

    // 格式化剩余时间显示
    public func formatRemainingTime(): String {
        if (remainingTime < 60) {
            return "${remainingTime}秒"
        } else if (remainingTime < 3600) {
            let minutes = remainingTime / 60
            return "${minutes}分钟"
        } else {
            let hours = remainingTime / 3600
            let minutes = (remainingTime % 3600) / 60
            if (minutes == 0) {
                return "${hours}小时"
            } else {
                return "${hours}小时${minutes}分钟"
            }
        }
    }

    // 获取导航类型的中文描述
    public func getNavTypeDescription(): String {
        match (navType) {
            case STRAIGHT => "直行"
            case LEFT_TURN => "左转"
            case RIGHT_TURN => "右转"
            case U_TURN => "掉头"
            case LEFT_FRONT => "左前方"
            case RIGHT_FRONT => "右前方"
            case LEFT_BACK => "左后方"
            case RIGHT_BACK => "右后方"
            case MERGE_LEFT => "靠左行驶"
            case MERGE_RIGHT => "靠右行驶"
            case ROUNDABOUT => "进入环岛"
            case EXIT => "驶出"
            case ARRIVE => "到达目的地"
            case _ => "未知"
        }
    }

    // 重置数据
    public func reset() {
        instruction = ""
        navType = NavigationType.UNKNOWN
        distance = 0
        currentRoad = ""
        nextRoad = ""
        remainingDistance = 0
        remainingTime = 0
        currentSpeed = 0
        isNavigating = false
        timestamp = 0
    }
}
