/**
 * 导航显示界面
 * 在手表屏幕上显示导航信息
 */

package navigation.ui

import navigation.model.NavigationData
import navigation.model.NavigationType
import navigation.service.NotificationListenerService
import navigation.utils.Constants
import ohos.agp.components.*
import ohos.agp.utils.*
import ohos.app.Context

/**
 * 导航视图组件
 */
public class NavigationView extends ComponentContainer {

    // UI 组件
    private var rootLayout: DirectionalLayout? = null
    private var directionIcon: Image? = null
    private var instructionText: Text? = null
    private var distanceText: Text? = null
    private var roadInfoText: Text? = null
    private var remainingInfoText: Text? = null
    private var statusText: Text? = null

    // 当前导航数据
    private var currentNavData: NavigationData? = null

    // 通知监听服务
    private var notificationService: NotificationListenerService? = null

    public init(context: Context) {
        super(context)
        initializeUI(context)
    }

    /**
     * 初始化 UI
     */
    private func initializeUI(context: Context) {
        // 创建根布局
        rootLayout = DirectionalLayout(context)
        rootLayout?.setOrientation(Component.VERTICAL)
        rootLayout?.setWidth(ComponentContainer.LayoutConfig.MATCH_PARENT)
        rootLayout?.setHeight(ComponentContainer.LayoutConfig.MATCH_PARENT)
        rootLayout?.setBackground(createBackgroundElement())
        rootLayout?.setPadding(20, 20, 20, 20)

        // 创建状态文本（顶部）
        statusText = createStatusText(context)
        rootLayout?.addComponent(statusText)

        // 创建方向图标（中上部）
        directionIcon = createDirectionIcon(context)
        rootLayout?.addComponent(directionIcon)

        // 创建距离文本（中部，大字体）
        distanceText = createDistanceText(context)
        rootLayout?.addComponent(distanceText)

        // 创建导航指令文本（中下部）
        instructionText = createInstructionText(context)
        rootLayout?.addComponent(instructionText)

        // 创建道路信息文本
        roadInfoText = createRoadInfoText(context)
        rootLayout?.addComponent(roadInfoText)

        // 创建剩余信息文本（底部）
        remainingInfoText = createRemainingInfoText(context)
        rootLayout?.addComponent(remainingInfoText)

        // 添加根布局到视图
        addComponent(rootLayout)

        // 显示初始状态
        showWaitingState()
    }

    /**
     * 创建背景元素
     */
    private func createBackgroundElement(): Element {
        let shapeElement = ShapeElement()
        shapeElement.setRgbColor(RgbColor(255, 255, 255)) // 白色背景
        return shapeElement
    }

    /**
     * 创建状态文本
     */
    private func createStatusText(context: Context): Text {
        let text = Text(context)
        text.setTextSize(Constants.FONT_SIZE_SMALL)
        text.setTextColor(Color(Constants.COLOR_TEXT_SECONDARY))
        text.setTextAlignment(TextAlignment.CENTER)
        text.setWidth(ComponentContainer.LayoutConfig.MATCH_PARENT)
        text.setHeight(ComponentContainer.LayoutConfig.MATCH_CONTENT)
        text.setMarginTop(10)
        text.setMarginBottom(20)
        return text
    }

    /**
     * 创建方向图标
     */
    private func createDirectionIcon(context: Context): Image {
        let image = Image(context)
        image.setWidth(120)
        image.setHeight(120)
        image.setMarginTop(20)
        image.setMarginBottom(20)
        image.setLayoutAlignment(LayoutAlignment.HORIZONTAL_CENTER)
        return image
    }

    /**
     * 创建距离文本
     */
    private func createDistanceText(context: Context): Text {
        let text = Text(context)
        text.setTextSize(Constants.FONT_SIZE_LARGE * 2) // 特大字体
        text.setTextColor(Color(Constants.COLOR_PRIMARY))
        text.setTextAlignment(TextAlignment.CENTER)
        text.setWidth(ComponentContainer.LayoutConfig.MATCH_PARENT)
        text.setHeight(ComponentContainer.LayoutConfig.MATCH_CONTENT)
        text.setWeight(1.0f)
        text.setMarginTop(10)
        text.setMarginBottom(10)
        return text
    }

    /**
     * 创建导航指令文本
     */
    private func createInstructionText(context: Context): Text {
        let text = Text(context)
        text.setTextSize(Constants.FONT_SIZE_MEDIUM)
        text.setTextColor(Color(Constants.COLOR_TEXT_PRIMARY))
        text.setTextAlignment(TextAlignment.CENTER)
        text.setWidth(ComponentContainer.LayoutConfig.MATCH_PARENT)
        text.setHeight(ComponentContainer.LayoutConfig.MATCH_CONTENT)
        text.setMarginTop(10)
        text.setMarginBottom(10)
        text.setMaxLines(2)
        return text
    }

    /**
     * 创建道路信息文本
     */
    private func createRoadInfoText(context: Context): Text {
        let text = Text(context)
        text.setTextSize(Constants.FONT_SIZE_SMALL)
        text.setTextColor(Color(Constants.COLOR_TEXT_SECONDARY))
        text.setTextAlignment(TextAlignment.CENTER)
        text.setWidth(ComponentContainer.LayoutConfig.MATCH_PARENT)
        text.setHeight(ComponentContainer.LayoutConfig.MATCH_CONTENT)
        text.setMarginTop(5)
        text.setMarginBottom(5)
        return text
    }

    /**
     * 创建剩余信息文本
     */
    private func createRemainingInfoText(context: Context): Text {
        let text = Text(context)
        text.setTextSize(Constants.FONT_SIZE_SMALL)
        text.setTextColor(Color(Constants.COLOR_TEXT_SECONDARY))
        text.setTextAlignment(TextAlignment.CENTER)
        text.setWidth(ComponentContainer.LayoutConfig.MATCH_PARENT)
        text.setHeight(ComponentContainer.LayoutConfig.MATCH_CONTENT)
        text.setMarginTop(10)
        text.setMarginBottom(10)
        return text
    }

    /**
     * 更新导航数据显示
     */
    public func updateNavigationData(navData: NavigationData) {
        currentNavData = navData

        if (navData.isNavigating) {
            // 更新状态
            statusText?.setText("正在导航")
            statusText?.setTextColor(Color(Constants.COLOR_SUCCESS))

            // 更新距离
            distanceText?.setText(navData.formatDistance())

            // 更新导航指令
            let instruction = navData.getNavTypeDescription()
            instructionText?.setText(instruction)

            // 更新方向图标
            updateDirectionIcon(navData.navType)

            // 更新道路信息
            if (!navData.nextRoad.isEmpty()) {
                roadInfoText?.setText("→ ${navData.nextRoad}")
                roadInfoText?.setVisibility(Component.VISIBLE)
            } else {
                roadInfoText?.setVisibility(Component.HIDE)
            }

            // 更新剩余信息
            if (navData.remainingDistance > 0) {
                let remainingInfo = "剩余 ${formatDistance(navData.remainingDistance)}"
                if (navData.remainingTime > 0) {
                    remainingInfo += " · ${navData.formatRemainingTime()}"
                }
                remainingInfoText?.setText(remainingInfo)
                remainingInfoText?.setVisibility(Component.VISIBLE)
            } else {
                remainingInfoText?.setVisibility(Component.HIDE)
            }

        } else {
            showWaitingState()
        }
    }

    /**
     * 更新方向图标
     */
    private func updateDirectionIcon(navType: NavigationType) {
        // 根据导航类型设置对应的图标
        // 这里应该加载对应的图标资源
        // 示例代码：
        match (navType) {
            case STRAIGHT => {
                // directionIcon?.setPixelMap(loadIconResource("arrow_straight"))
            }
            case LEFT_TURN => {
                // directionIcon?.setPixelMap(loadIconResource("arrow_left"))
            }
            case RIGHT_TURN => {
                // directionIcon?.setPixelMap(loadIconResource("arrow_right"))
            }
            case U_TURN => {
                // directionIcon?.setPixelMap(loadIconResource("arrow_uturn"))
            }
            case ARRIVE => {
                // directionIcon?.setPixelMap(loadIconResource("flag_finish"))
            }
            case _ => {
                // directionIcon?.setPixelMap(loadIconResource("arrow_straight"))
            }
        }
    }

    /**
     * 显示等待状态
     */
    private func showWaitingState() {
        statusText?.setText("等待导航...")
        statusText?.setTextColor(Color(Constants.COLOR_TEXT_SECONDARY))

        distanceText?.setText("--")
        instructionText?.setText("请在手机上启动高德地图导航")
        roadInfoText?.setVisibility(Component.HIDE)
        remainingInfoText?.setVisibility(Component.HIDE)

        // 设置默认图标
        // directionIcon?.setPixelMap(loadIconResource("navigation_waiting"))
    }

    /**
     * 显示导航结束状态
     */
    public func showNavigationEndedState() {
        statusText?.setText("导航已结束")
        statusText?.setTextColor(Color(Constants.COLOR_SUCCESS))

        distanceText?.setText("✓")
        instructionText?.setText("已到达目的地")
        roadInfoText?.setVisibility(Component.HIDE)
        remainingInfoText?.setVisibility(Component.HIDE)
    }

    /**
     * 显示错误状态
     */
    public func showErrorState(errorMessage: String) {
        statusText?.setText("错误")
        statusText?.setTextColor(Color(Constants.COLOR_DANGER))

        distanceText?.setText("!")
        instructionText?.setText(errorMessage)
        roadInfoText?.setVisibility(Component.HIDE)
        remainingInfoText?.setVisibility(Component.HIDE)
    }

    /**
     * 格式化距离
     */
    private func formatDistance(meters: Int64): String {
        if (meters < 1000) {
            return "${meters}米"
        } else {
            let km = meters / 1000
            let m = meters % 1000
            if (m == 0) {
                return "${km}公里"
            } else {
                return "${km}.${m / 100}公里"
            }
        }
    }

    /**
     * 设置通知监听服务
     */
    public func setNotificationService(service: NotificationListenerService) {
        notificationService = service

        // 设置数据更新回调
        service.setNavigationDataCallback(object : NotificationListenerService.NavigationDataCallback {
            override func onNavigationDataUpdate(data: NavigationData) {
                // 在UI线程更新界面
                updateNavigationData(data)
            }

            override func onNavigationStatusChange(isNavigating: Bool) {
                if (!isNavigating) {
                    showNavigationEndedState()
                }
            }
        })
    }

    /**
     * 获取当前导航数据
     */
    public func getCurrentNavigationData(): NavigationData? {
        return currentNavData
    }
}
