import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { PlatformDetector, PlatformServiceFactory, IPlatformService, NavigationCallback } from '../platform/PlatformAbstraction';
import { NavigationData } from '../model/NavigationData';
import { Constants } from '../utils/Constants';

/**
 * 应用主入口 Ability
 * 负责平台检测、服务初始化和导航数据管理
 */
export default class EntryAbility extends UIAbility implements NavigationCallback {
  private platformService?: IPlatformService;
  private currentNavData: NavigationData = new NavigationData();
  private windowStage?: window.WindowStage;

  onCreate(want, launchParam) {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'Ability onCreate');

    // 检测平台并初始化服务
    const platform = PlatformDetector.detectPlatform();
    hilog.info(0x0000, Constants.LOG_TAG, 'Detected platform: %{public}s', platform.toString());

    try {
      this.platformService = PlatformServiceFactory.createService(platform);
      this.platformService.initialize(this);
      hilog.info(0x0000, Constants.LOG_TAG, 'Platform service initialized successfully');
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG, 'Failed to initialize platform service: %{public}s',
        JSON.stringify(error) ?? '');
    }

    // 将导航数据存储到全局共享对象，供 UI 访问
    globalThis.navigationData = this.currentNavData;
    globalThis.updateNavigation = (data: NavigationData) => {
      this.onNavigationUpdate(data);
    };
  }

  onDestroy() {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'Ability onDestroy');

    // 清理平台服务
    if (this.platformService) {
      this.platformService.cleanup();
      this.platformService = undefined;
    }

    // 清理全局对象
    globalThis.navigationData = undefined;
    globalThis.updateNavigation = undefined;
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'Ability onWindowStageCreate');

    this.windowStage = windowStage;

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, Constants.LOG_TAG, 'Failed to load the content. Cause: %{public}s',
          JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, Constants.LOG_TAG, 'Succeeded in loading the content. Data: %{public}s',
        JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'Ability onWindowStageDestroy');
    this.windowStage = undefined;
  }

  onForeground() {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'Ability onForeground');

    // 前台时启动服务
    if (this.platformService) {
      this.platformService.startListening();
    }
  }

  onBackground() {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'Ability onBackground');

    // 后台时可以选择继续监听或停止
    // 这里选择继续监听以保持导航更新
    // 如果需要节省资源，可以调用 stopListening()
  }

  /**
   * 导航数据更新回调
   */
  onNavigationUpdate(data: NavigationData): void {
    hilog.info(0x0000, Constants.LOG_TAG, 'Navigation update: %{public}s', data.instruction);

    // 更新当前导航数据
    this.currentNavData = data;
    globalThis.navigationData = data;

    // 通知 UI 更新（通过事件发射）
    if (this.windowStage) {
      try {
        // 触发 UI 更新
        AppStorage.SetOrCreate('navigationData', data);
      } catch (error) {
        hilog.error(0x0000, Constants.LOG_TAG, 'Failed to update UI: %{public}s',
          JSON.stringify(error) ?? '');
      }
    }
  }

  /**
   * 连接错误回调
   */
  onConnectionError(error: string): void {
    hilog.error(0x0000, Constants.LOG_TAG, 'Connection error: %{public}s', error);

    // 创建错误状态的导航数据
    const errorData = new NavigationData();
    errorData.isNavigating = false;
    errorData.instruction = '连接失败: ' + error;

    this.onNavigationUpdate(errorData);
  }

  /**
   * 导航结束回调
   */
  onNavigationEnd(): void {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'Navigation ended');

    // 创建导航结束状态的数据
    const endData = new NavigationData();
    endData.isNavigating = false;
    endData.instruction = '导航已结束';

    this.onNavigationUpdate(endData);
  }
}
