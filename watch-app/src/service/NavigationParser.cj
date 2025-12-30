/**
 * 导航数据解析器
 * 从高德地图通知内容中解析出导航信息
 */

package navigation.service

import navigation.model.NavigationData
import navigation.model.NavigationType
import navigation.utils.Constants
import std.collection.*

public class NavigationParser {

    private var lastParsedData: NavigationData = NavigationData()

    public init() {}

    /**
     * 解析通知内容，提取导航信息
     * @param title 通知标题
     * @param content 通知内容
     * @return 解析后的导航数据
     */
    public func parseNotification(title: String, content: String): NavigationData {
        let navData = NavigationData()

        // 如果内容为空，返回空数据
        if (content.isEmpty()) {
            return navData
        }

        // 设置为正在导航状态
        navData.isNavigating = true

        // 解析导航指令
        navData.instruction = content

        // 解析导航类型
        navData.navType = parseNavigationType(content)

        // 解析距离信息
        navData.distance = parseDistance(content)

        // 解析道路信息
        parseRoadInfo(content, navData)

        // 解析剩余距离和时间
        parseRemainingInfo(content, navData)

        // 设置时间戳
        navData.timestamp = getCurrentTimestamp()

        // 保存最后解析的数据
        lastParsedData = navData

        return navData
    }

    /**
     * 解析导航类型
     */
    private func parseNavigationType(content: String): NavigationType {
        if (content.contains("直行") || content.contains("继续前行")) {
            return NavigationType.STRAIGHT
        } else if (content.contains("左转")) {
            return NavigationType.LEFT_TURN
        } else if (content.contains("右转")) {
            return NavigationType.RIGHT_TURN
        } else if (content.contains("掉头") || content.contains("调头")) {
            return NavigationType.U_TURN
        } else if (content.contains("左前方")) {
            return NavigationType.LEFT_FRONT
        } else if (content.contains("右前方")) {
            return NavigationType.RIGHT_FRONT
        } else if (content.contains("左后方")) {
            return NavigationType.LEFT_BACK
        } else if (content.contains("右后方")) {
            return NavigationType.RIGHT_BACK
        } else if (content.contains("靠左")) {
            return NavigationType.MERGE_LEFT
        } else if (content.contains("靠右")) {
            return NavigationType.MERGE_RIGHT
        } else if (content.contains("环岛")) {
            return NavigationType.ROUNDABOUT
        } else if (content.contains("出口") || content.contains("驶出")) {
            return NavigationType.EXIT
        } else if (content.contains("到达") || content.contains("已到达")) {
            return NavigationType.ARRIVE
        } else {
            return NavigationType.UNKNOWN
        }
    }

    /**
     * 解析距离信息
     * 支持格式：500米、1.5公里、1500m、1.5km 等
     */
    private func parseDistance(content: String): Int64 {
        var distance: Int64 = 0

        // 匹配 "XXX米" 格式
        if (content.contains("米")) {
            distance = extractNumber(content, "米")
        }
        // 匹配 "XXX公里" 或 "XXXkm" 格式
        else if (content.contains("公里") || content.contains("km")) {
            let km = extractNumberWithDecimal(content, "公里")
            distance = (km * 1000.0).toInt64()
        }
        // 匹配 "XXXm" 格式
        else if (content.contains("m") && !content.contains("km")) {
            distance = extractNumber(content, "m")
        }

        return distance
    }

    /**
     * 解析道路信息
     */
    private func parseRoadInfo(content: String, navData: NavigationData) {
        // 尝试解析当前道路和下一条道路
        // 通常格式为："进入XX路" 或 "从XX路转入YY路"

        if (content.contains("进入")) {
            let parts = content.split("进入")
            if (parts.size > 1) {
                navData.nextRoad = extractRoadName(parts[1])
            }
        }

        if (content.contains("转入")) {
            let parts = content.split("转入")
            if (parts.size > 1) {
                navData.nextRoad = extractRoadName(parts[1])
            }
        }
    }

    /**
     * 解析剩余距离和时间
     * 通常在通知标题或底部显示，如："剩余15公里，约20分钟"
     */
    private func parseRemainingInfo(content: String, navData: NavigationData) {
        // 解析剩余距离
        if (content.contains("剩余")) {
            if (content.contains("公里")) {
                let km = extractNumberWithDecimal(content, "公里")
                navData.remainingDistance = (km * 1000.0).toInt64()
            } else if (content.contains("米")) {
                navData.remainingDistance = extractNumber(content, "米")
            }
        }

        // 解析剩余时间
        if (content.contains("分钟")) {
            let minutes = extractNumber(content, "分钟")
            navData.remainingTime = minutes * 60
        }
        if (content.contains("小时")) {
            let hours = extractNumber(content, "小时")
            navData.remainingTime += hours * 3600
        }
    }

    /**
     * 从文本中提取数字（整数）
     */
    private func extractNumber(text: String, keyword: String): Int64 {
        // 简化实现：查找关键词前的数字
        let index = text.indexOf(keyword)
        if (index > 0) {
            var numStr = ""
            var i = index - 1

            // 向前查找数字
            while (i >= 0 && isDigit(text[i])) {
                numStr = text[i].toString() + numStr
                i--
            }

            if (!numStr.isEmpty()) {
                return numStr.toInt64()
            }
        }
        return 0
    }

    /**
     * 从文本中提取数字（支持小数）
     */
    private func extractNumberWithDecimal(text: String, keyword: String): Float64 {
        let index = text.indexOf(keyword)
        if (index > 0) {
            var numStr = ""
            var i = index - 1
            var hasDot = false

            // 向前查找数字和小数点
            while (i >= 0 && (isDigit(text[i]) || text[i] == '.')) {
                if (text[i] == '.') {
                    if (hasDot) break  // 已经有小数点了
                    hasDot = true
                }
                numStr = text[i].toString() + numStr
                i--
            }

            if (!numStr.isEmpty()) {
                return numStr.toFloat64()
            }
        }
        return 0.0
    }

    /**
     * 提取道路名称
     */
    private func extractRoadName(text: String): String {
        // 简化实现：提取第一个词组
        var roadName = text.trim()

        // 移除可能的标点符号
        let stopChars = [',', '，', '。', '.', ' ']
        for (ch in stopChars) {
            let idx = roadName.indexOf(ch.toString())
            if (idx > 0) {
                roadName = roadName.substring(0, idx)
            }
        }

        return roadName
    }

    /**
     * 判断字符是否为数字
     */
    private func isDigit(ch: Char): Bool {
        return ch >= '0' && ch <= '9'
    }

    /**
     * 获取当前时间戳（毫秒）
     */
    private func getCurrentTimestamp(): Int64 {
        // 这里应该调用系统时间API
        // 暂时返回占位值
        return 0
    }

    /**
     * 获取最后解析的数据
     */
    public func getLastParsedData(): NavigationData {
        return lastParsedData
    }

    /**
     * 判断通知是否为导航通知
     */
    public func isNavigationNotification(packageName: String, content: String): Bool {
        // 检查包名是否为高德地图
        var isAmapPackage = false
        for (pkgName in Constants.AMAP_PACKAGE_NAMES) {
            if (packageName == pkgName) {
                isAmapPackage = true
                break
            }
        }

        if (!isAmapPackage) {
            return false
        }

        // 检查内容是否包含导航关键词
        for (keyword in Constants.NAV_KEYWORDS) {
            if (content.contains(keyword)) {
                return true
            }
        }

        return false
    }
}
