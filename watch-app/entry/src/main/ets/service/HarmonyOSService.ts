/**
 * HarmonyOS 平台服务实现
 * 通过系统通知同步机制获取导航数据
 */

import notificationManager from '@ohos.notificationManager';
import hilog from '@ohos.hilog';
import { IPlatformService, NavigationCallback } from '../platform/PlatformAbstraction';
import { NavigationParser } from './NavigationParser';
import { Constants } from '../utils/Constants';

export class HarmonyOSService implements IPlatformService {
  private callback?: NavigationCallback;
  private parser: NavigationParser = new NavigationParser();
  private isListening: boolean = false;
  private notificationSubscriber?: any;

  initialize(callback: NavigationCallback): void {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'HarmonyOSService: Initializing');
    this.callback = callback;

    // 请求通知监听权限
    this.requestNotificationPermission();
  }

  /**
   * 请求通知监听权限
   */
  private requestNotificationPermission(): void {
    try {
      // 检查是否已授权通知监听权限
      notificationManager.isNotificationEnabled().then((enabled) => {
        if (!enabled) {
          hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s',
            'HarmonyOSService: Notification permission not granted');

          // 请求用户授权
          notificationManager.requestEnableNotification().then(() => {
            hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
              'HarmonyOSService: Notification permission granted');
          }).catch((err) => {
            hilog.error(0x0000, Constants.LOG_TAG,
              'HarmonyOSService: Failed to request notification permission: %{public}s',
              JSON.stringify(err) ?? '');

            if (this.callback) {
              this.callback.onConnectionError('未授予通知权限');
            }
          });
        } else {
          hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
            'HarmonyOSService: Notification permission already granted');
        }
      });
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HarmonyOSService: Error checking notification permission: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  startListening(): void {
    if (this.isListening) {
      hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s',
        'HarmonyOSService: Already listening');
      return;
    }

    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'HarmonyOSService: Starting to listen');

    try {
      // 订阅通知
      this.subscribeNotifications();
      this.isListening = true;
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HarmonyOSService: Failed to start listening: %{public}s',
        JSON.stringify(error) ?? '');

      if (this.callback) {
        this.callback.onConnectionError('启动监听失败');
      }
    }
  }

  stopListening(): void {
    if (!this.isListening) {
      return;
    }

    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'HarmonyOSService: Stopping listening');

    try {
      // 取消订阅通知
      if (this.notificationSubscriber) {
        notificationManager.unsubscribe(this.notificationSubscriber);
        this.notificationSubscriber = undefined;
      }

      this.isListening = false;
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HarmonyOSService: Failed to stop listening: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  cleanup(): void {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'HarmonyOSService: Cleaning up');

    this.stopListening();
    this.callback = undefined;
  }

  /**
   * 订阅系统通知
   */
  private subscribeNotifications(): void {
    try {
      // 创建通知订阅者
      const subscriber = {
        onConsume: (data) => {
          this.handleNotification(data);
        },
        onCancel: (data) => {
          hilog.debug(0x0000, Constants.LOG_TAG, 'HarmonyOSService: Notification cancelled');
        },
        onUpdate: (data) => {
          hilog.debug(0x0000, Constants.LOG_TAG, 'HarmonyOSService: Notification updated');
        },
        onConnect: () => {
          hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
            'HarmonyOSService: Notification subscriber connected');
        },
        onDisconnect: () => {
          hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s',
            'HarmonyOSService: Notification subscriber disconnected');
        }
      };

      // 订阅通知
      notificationManager.subscribe(subscriber, (err) => {
        if (err) {
          hilog.error(0x0000, Constants.LOG_TAG,
            'HarmonyOSService: Failed to subscribe notifications: %{public}s',
            JSON.stringify(err) ?? '');

          if (this.callback) {
            this.callback.onConnectionError('订阅通知失败');
          }
        } else {
          hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
            'HarmonyOSService: Successfully subscribed to notifications');
          this.notificationSubscriber = subscriber;
        }
      });
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HarmonyOSService: Error subscribing to notifications: %{public}s',
        JSON.stringify(error) ?? '');

      if (this.callback) {
        this.callback.onConnectionError('订阅通知异常');
      }
    }
  }

  /**
   * 处理接收到的通知
   */
  private handleNotification(data: any): void {
    try {
      // 获取通知内容
      const request = data?.request;
      if (!request) {
        return;
      }

      const bundleName = request.creatorBundleName || '';
      const content = request.content?.normal?.text || '';
      const title = request.content?.normal?.title || '';

      hilog.debug(0x0000, Constants.LOG_TAG,
        'HarmonyOSService: Received notification from %{public}s', bundleName);

      // 检查是否为高德地图导航通知
      if (!this.parser.isNavigationNotification(bundleName, content)) {
        return;
      }

      hilog.info(0x0000, Constants.LOG_TAG,
        'HarmonyOSService: Navigation notification detected');

      // 解析导航数据
      const navData = this.parser.parseNotification(title, content);

      // 回调通知上层
      if (this.callback) {
        this.callback.onNavigationUpdate(navData);
      }
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HarmonyOSService: Error handling notification: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  /**
   * 获取服务状态
   */
  isActive(): boolean {
    return this.isListening;
  }

  /**
   * 获取平台名称
   */
  getPlatformName(): string {
    return 'HarmonyOS';
  }
}
