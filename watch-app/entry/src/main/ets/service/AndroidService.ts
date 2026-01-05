/**
 * Android 平台服务实现
 * 通过蓝牙从 Android 手机接收导航数据
 */

import hilog from '@ohos.hilog';
import { IPlatformService, NavigationCallback } from '../platform/PlatformAbstraction';
import { NavigationParser } from './NavigationParser';
import { BluetoothService } from './BluetoothService';
import { NavigationData } from '../model/NavigationData';
import { Constants } from '../utils/Constants';

export class AndroidService implements IPlatformService {
  private callback?: NavigationCallback;
  private parser: NavigationParser = new NavigationParser();
  private bluetoothService: BluetoothService = new BluetoothService();
  private isListening: boolean = false;

  initialize(callback: NavigationCallback): void {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'AndroidService: Initializing');
    this.callback = callback;

    // 初始化蓝牙服务
    try {
      this.bluetoothService.initialize((data: string) => {
        this.handleBluetoothData(data);
      });
      hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
        'AndroidService: Bluetooth service initialized');
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'AndroidService: Failed to initialize Bluetooth service: %{public}s',
        JSON.stringify(error) ?? '');

      if (this.callback) {
        this.callback.onConnectionError('蓝牙服务初始化失败');
      }
    }
  }

  startListening(): void {
    if (this.isListening) {
      hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s', 'AndroidService: Already listening');
      return;
    }

    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'AndroidService: Starting to listen');

    try {
      // 启动蓝牙连接
      this.bluetoothService.startConnection((success: boolean, message: string) => {
        if (success) {
          hilog.info(0x0000, Constants.LOG_TAG,
            'AndroidService: Bluetooth connected successfully');
          this.isListening = true;
        } else {
          hilog.error(0x0000, Constants.LOG_TAG,
            'AndroidService: Bluetooth connection failed: %{public}s', message);

          if (this.callback) {
            this.callback.onConnectionError('蓝牙连接失败: ' + message);
          }
        }
      });
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'AndroidService: Failed to start listening: %{public}s',
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

    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'AndroidService: Stopping listening');

    try {
      this.bluetoothService.disconnect();
      this.isListening = false;
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'AndroidService: Failed to stop listening: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  cleanup(): void {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'AndroidService: Cleaning up');

    this.stopListening();
    this.bluetoothService.cleanup();
    this.callback = undefined;
  }

  /**
   * 处理从蓝牙接收的数据
   */
  private handleBluetoothData(data: string): void {
    try {
      hilog.debug(0x0000, Constants.LOG_TAG,
        'AndroidService: Received Bluetooth data: %{public}s', data);

      // 解析 JSON 数据
      const jsonData = JSON.parse(data);

      // 检查数据类型
      if (jsonData.type === 'navigation') {
        // 提取通知内容
        const packageName = jsonData.packageName || '';
        const title = jsonData.title || '';
        const content = jsonData.content || '';

        // 检查是否为导航通知
        if (this.parser.isNavigationNotification(packageName, content)) {
          hilog.info(0x0000, Constants.LOG_TAG,
            'AndroidService: Navigation notification detected');

          // 解析导航数据
          const navData = this.parser.parseNotification(title, content);

          // 回调通知上层
          if (this.callback) {
            this.callback.onNavigationUpdate(navData);
          }
        }
      } else if (jsonData.type === 'navigation_end') {
        // 导航结束
        hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
          'AndroidService: Navigation ended');

        if (this.callback) {
          this.callback.onNavigationEnd();
        }
      }
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'AndroidService: Error handling Bluetooth data: %{public}s',
        JSON.stringify(error) ?? '');

      // 如果不是 JSON 格式，尝试作为纯文本解析
      this.handlePlainTextData(data);
    }
  }

  /**
   * 处理纯文本数据（用于简单场景）
   */
  private handlePlainTextData(data: string): void {
    try {
      // 假设数据格式为: "packageName|title|content"
      const parts = data.split('|');

      if (parts.length >= 3) {
        const packageName = parts[0];
        const title = parts[1];
        const content = parts[2];

        if (this.parser.isNavigationNotification(packageName, content)) {
          hilog.info(0x0000, Constants.LOG_TAG,
            'AndroidService: Navigation notification detected (plain text)');

          const navData = this.parser.parseNotification(title, content);

          if (this.callback) {
            this.callback.onNavigationUpdate(navData);
          }
        }
      }
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'AndroidService: Error handling plain text data: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  /**
   * 获取服务状态
   */
  isActive(): boolean {
    return this.isListening && this.bluetoothService.isConnected();
  }

  /**
   * 获取平台名称
   */
  getPlatformName(): string {
    return 'Android';
  }

  /**
   * 获取连接状态信息
   */
  getConnectionInfo(): string {
    if (this.isActive()) {
      return '已连接到 Android 设备';
    } else if (this.isListening) {
      return '正在连接...';
    } else {
      return '未连接';
    }
  }
}
