/**
 * 主页面 - 导航显示界面
 * 针对圆形手表屏幕优化的导航界面
 */

import { NavigationData, NavigationType } from '../model/NavigationData';
import { PlatformDetector } from '../platform/PlatformAbstraction';
import { Constants } from '../utils/Constants';

@Entry
@Component
struct Index {
  @StorageLink('navigationData') navigationData: NavigationData = new NavigationData();
  @State platformName: string = '正在检测...';
  @State isNavigating: boolean = false;
  @State currentTime: string = '';

  // 定时器更新时间
  private timeUpdateTimer?: number;

  aboutToAppear() {
    // 检测平台
    const platform = PlatformDetector.detectPlatform();
    this.platformName = this.getPlatformDisplayName(platform.toString());

    // 从全局获取导航数据
    if (globalThis.navigationData) {
      this.navigationData = globalThis.navigationData;
      this.isNavigating = this.navigationData.isNavigating;
    }

    // 启动时间更新定时器
    this.updateTime();
    this.timeUpdateTimer = setInterval(() => {
      this.updateTime();
    }, 1000);
  }

  aboutToDisappear() {
    // 清理定时器
    if (this.timeUpdateTimer) {
      clearInterval(this.timeUpdateTimer);
    }
  }

  /**
   * 更新当前时间
   */
  updateTime() {
    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    this.currentTime = `${hours}:${minutes}`;
  }

  /**
   * 获取平台显示名称
   */
  getPlatformDisplayName(platform: string): string {
    switch (platform) {
      case 'HARMONYOS':
        return '鸿蒙系统';
      case 'ANDROID':
        return 'Android';
      case 'HYPEROS':
        return '小米澎湃';
      default:
        return '未知平台';
    }
  }

  /**
   * 获取导航图标（使用文字表示）
   */
  getNavigationIcon(navType: NavigationType): string {
    switch (navType) {
      case NavigationType.STRAIGHT:
        return '↑';
      case NavigationType.LEFT_TURN:
        return '←';
      case NavigationType.RIGHT_TURN:
        return '→';
      case NavigationType.U_TURN:
        return '↶';
      case NavigationType.LEFT_FRONT:
        return '↖';
      case NavigationType.RIGHT_FRONT:
        return '↗';
      case NavigationType.LEFT_BACK:
        return '↙';
      case NavigationType.RIGHT_BACK:
        return '↘';
      case NavigationType.MERGE_LEFT:
        return '⇐';
      case NavigationType.MERGE_RIGHT:
        return '⇒';
      case NavigationType.ROUNDABOUT:
        return '⟳';
      case NavigationType.EXIT:
        return '⤴';
      case NavigationType.ARRIVE:
        return '✓';
      default:
        return '•';
    }
  }

  build() {
    Stack() {
      if (this.navigationData.isNavigating) {
        // 导航中界面
        this.NavigatingView();
      } else {
        // 等待导航界面
        this.WaitingView();
      }

      // 顶部时间栏
      Row() {
        Text(this.currentTime)
          .fontSize(14)
          .fontColor(Color.White)
          .opacity(0.8)
      }
      .width('100%')
      .height(30)
      .justifyContent(FlexAlign.Center)
      .position({ x: 0, y: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }

  /**
   * 导航中视图
   */
  @Builder NavigatingView() {
    Column() {
      // 导航图标和指令
      Column() {
        // 导航图标
        Text(this.getNavigationIcon(this.navigationData.navType))
          .fontSize(80)
          .fontColor(Constants.COLOR_PRIMARY)
          .margin({ bottom: 10 })

        // 距离信息
        Text(this.navigationData.formatDistance())
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .margin({ bottom: 15 })

        // 导航指令
        Text(this.navigationData.instruction)
          .fontSize(18)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .padding({ left: 20, right: 20 })
          .margin({ bottom: 20 })
      }
      .justifyContent(FlexAlign.Center)
      .margin({ top: 40 })

      // 道路信息
      if (this.navigationData.nextRoad && this.navigationData.nextRoad.length > 0) {
        Row() {
          Text('进入 ')
            .fontSize(14)
            .fontColor(Color.Gray)
          Text(this.navigationData.nextRoad)
            .fontSize(14)
            .fontColor(Color.White)
        }
        .margin({ bottom: 30 })
      }

      // 剩余信息
      if (this.navigationData.remainingDistance > 0 || this.navigationData.remainingTime > 0) {
        Column() {
          Row() {
            if (this.navigationData.remainingDistance > 0) {
              Text('剩余 ')
                .fontSize(14)
                .fontColor(Color.Gray)
              Text(this.navigationData.formatRemainingDistance())
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor(Constants.COLOR_PRIMARY)
            }
          }
          .margin({ bottom: 5 })

          Row() {
            if (this.navigationData.remainingTime > 0) {
              Text('约 ')
                .fontSize(14)
                .fontColor(Color.Gray)
              Text(this.navigationData.formatRemainingTime())
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor(Constants.COLOR_PRIMARY)
            }
          }
        }
        .margin({ bottom: 20 })
      }

      // 平台信息
      Text(this.platformName)
        .fontSize(12)
        .fontColor(Color.Gray)
        .opacity(0.6)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(15)
  }

  /**
   * 等待导航视图
   */
  @Builder WaitingView() {
    Column() {
      // 应用图标/名称
      Text('高德导航')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .margin({ bottom: 15 })

      // 平台信息
      Text(this.platformName)
        .fontSize(16)
        .fontColor(Color.Gray)
        .margin({ bottom: 50 })

      // 等待图标
      Text('⊙')
        .fontSize(60)
        .fontColor(Constants.COLOR_PRIMARY)
        .opacity(0.6)
        .margin({ bottom: 20 })

      // 等待提示
      Text('等待导航...')
        .fontSize(20)
        .fontColor(Color.White)
        .margin({ bottom: 15 })

      // 使用说明
      Column() {
        Text('请在手机上启动')
          .fontSize(14)
          .fontColor(Color.Gray)
          .margin({ bottom: 5 })

        Text('高德地图导航')
          .fontSize(14)
          .fontColor(Color.Gray)
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(20)
  }
}
