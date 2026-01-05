/**
 * HyperOS/小米澎湃 平台服务实现
 * 支持通过小米智慧中心和蓝牙两种方式接收导航数据
 */

import hilog from '@ohos.hilog';
import { IPlatformService, NavigationCallback } from '../platform/PlatformAbstraction';
import { NavigationParser } from './NavigationParser';
import { BluetoothService } from './BluetoothService';
import { NavigationData } from '../model/NavigationData';
import { Constants } from '../utils/Constants';

/**
 * 小米智慧中心客户端（简化版）
 * 用于与小米生态设备进行低延迟数据交换
 */
class XiaomiSmartCenterClient {
  private callback?: (data: string) => void;
  private isConnected: boolean = false;

  initialize(callback: (data: string) => void): void {
    this.callback = callback;
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
      'XiaomiSmartCenterClient: Initialized');
  }

  /**
   * 连接到小米智慧中心
   */
  connect(): Promise<boolean> {
    return new Promise((resolve, reject) => {
      // TODO: 实现小米智慧中心 SDK 集成
      // 这里需要集成小米提供的 SDK
      // 当前为占位实现

      hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s',
        'XiaomiSmartCenterClient: SDK not implemented yet, falling back to Bluetooth');

      // 暂时返回失败，让系统回退到蓝牙模式
      this.isConnected = false;
      resolve(false);
    });
  }

  /**
   * 断开连接
   */
  disconnect(): void {
    if (this.isConnected) {
      // TODO: 实现断开逻辑
      this.isConnected = false;
      hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
        'XiaomiSmartCenterClient: Disconnected');
    }
  }

  /**
   * 发送数据
   */
  sendData(data: string): boolean {
    if (!this.isConnected) {
      return false;
    }

    // TODO: 实现数据发送
    return true;
  }

  /**
   * 获取连接状态
   */
  isActive(): boolean {
    return this.isConnected;
  }
}

export class HyperOSService implements IPlatformService {
  private callback?: NavigationCallback;
  private parser: NavigationParser = new NavigationParser();
  private xiaomiClient: XiaomiSmartCenterClient = new XiaomiSmartCenterClient();
  private bluetoothService: BluetoothService = new BluetoothService();
  private isListening: boolean = false;
  private useSmartCenter: boolean = false;

  initialize(callback: NavigationCallback): void {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'HyperOSService: Initializing');
    this.callback = callback;

    // 初始化小米智慧中心客户端
    try {
      this.xiaomiClient.initialize((data: string) => {
        this.handleSmartCenterData(data);
      });
      hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
        'HyperOSService: Xiaomi Smart Center client initialized');
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HyperOSService: Failed to initialize Smart Center client: %{public}s',
        JSON.stringify(error) ?? '');
    }

    // 初始化蓝牙服务作为备用
    try {
      this.bluetoothService.initialize((data: string) => {
        this.handleBluetoothData(data);
      });
      hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
        'HyperOSService: Bluetooth service initialized');
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HyperOSService: Failed to initialize Bluetooth service: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  startListening(): void {
    if (this.isListening) {
      hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s', 'HyperOSService: Already listening');
      return;
    }

    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'HyperOSService: Starting to listen');

    // 优先尝试使用小米智慧中心
    this.xiaomiClient.connect().then((success) => {
      if (success) {
        hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
          'HyperOSService: Connected via Xiaomi Smart Center');
        this.useSmartCenter = true;
        this.isListening = true;
      } else {
        // 回退到蓝牙模式
        hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
          'HyperOSService: Falling back to Bluetooth mode');
        this.startBluetoothConnection();
      }
    }).catch((error) => {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HyperOSService: Smart Center connection failed: %{public}s',
        JSON.stringify(error) ?? '');

      // 回退到蓝牙模式
      this.startBluetoothConnection();
    });
  }

  /**
   * 启动蓝牙连接
   */
  private startBluetoothConnection(): void {
    try {
      this.bluetoothService.startConnection((success: boolean, message: string) => {
        if (success) {
          hilog.info(0x0000, Constants.LOG_TAG,
            'HyperOSService: Bluetooth connected successfully');
          this.useSmartCenter = false;
          this.isListening = true;
        } else {
          hilog.error(0x0000, Constants.LOG_TAG,
            'HyperOSService: Bluetooth connection failed: %{public}s', message);

          if (this.callback) {
            this.callback.onConnectionError('连接失败: ' + message);
          }
        }
      });
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HyperOSService: Failed to start Bluetooth: %{public}s',
        JSON.stringify(error) ?? '');

      if (this.callback) {
        this.callback.onConnectionError('蓝牙启动失败');
      }
    }
  }

  stopListening(): void {
    if (!this.isListening) {
      return;
    }

    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'HyperOSService: Stopping listening');

    try {
      if (this.useSmartCenter) {
        this.xiaomiClient.disconnect();
      } else {
        this.bluetoothService.disconnect();
      }

      this.isListening = false;
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HyperOSService: Failed to stop listening: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  cleanup(): void {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'HyperOSService: Cleaning up');

    this.stopListening();
    this.xiaomiClient.disconnect();
    this.bluetoothService.cleanup();
    this.callback = undefined;
  }

  /**
   * 处理从小米智慧中心接收的数据
   */
  private handleSmartCenterData(data: string): void {
    try {
      hilog.debug(0x0000, Constants.LOG_TAG,
        'HyperOSService: Received Smart Center data: %{public}s', data);

      // 解析数据（与蓝牙数据格式相同）
      this.parseNavigationData(data);
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HyperOSService: Error handling Smart Center data: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  /**
   * 处理从蓝牙接收的数据
   */
  private handleBluetoothData(data: string): void {
    try {
      hilog.debug(0x0000, Constants.LOG_TAG,
        'HyperOSService: Received Bluetooth data: %{public}s', data);

      this.parseNavigationData(data);
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HyperOSService: Error handling Bluetooth data: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  /**
   * 解析导航数据（统一处理）
   */
  private parseNavigationData(data: string): void {
    try {
      // 尝试解析 JSON
      const jsonData = JSON.parse(data);

      if (jsonData.type === 'navigation') {
        const packageName = jsonData.packageName || '';
        const title = jsonData.title || '';
        const content = jsonData.content || '';

        if (this.parser.isNavigationNotification(packageName, content)) {
          hilog.info(0x0000, Constants.LOG_TAG,
            'HyperOSService: Navigation notification detected');

          const navData = this.parser.parseNotification(title, content);

          if (this.callback) {
            this.callback.onNavigationUpdate(navData);
          }
        }
      } else if (jsonData.type === 'navigation_end') {
        hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
          'HyperOSService: Navigation ended');

        if (this.callback) {
          this.callback.onNavigationEnd();
        }
      }
    } catch (error) {
      // 如果不是 JSON，尝试作为纯文本解析
      this.parsePlainTextData(data);
    }
  }

  /**
   * 解析纯文本数据
   */
  private parsePlainTextData(data: string): void {
    try {
      const parts = data.split('|');

      if (parts.length >= 3) {
        const packageName = parts[0];
        const title = parts[1];
        const content = parts[2];

        if (this.parser.isNavigationNotification(packageName, content)) {
          hilog.info(0x0000, Constants.LOG_TAG,
            'HyperOSService: Navigation notification detected (plain text)');

          const navData = this.parser.parseNotification(title, content);

          if (this.callback) {
            this.callback.onNavigationUpdate(navData);
          }
        }
      }
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'HyperOSService: Error parsing plain text data: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  /**
   * 获取服务状态
   */
  isActive(): boolean {
    if (this.useSmartCenter) {
      return this.isListening && this.xiaomiClient.isActive();
    } else {
      return this.isListening && this.bluetoothService.isConnected();
    }
  }

  /**
   * 获取平台名称
   */
  getPlatformName(): string {
    return 'HyperOS / 小米澎湃';
  }

  /**
   * 获取连接方式
   */
  getConnectionMethod(): string {
    if (this.useSmartCenter) {
      return '小米智慧中心';
    } else {
      return '蓝牙';
    }
  }

  /**
   * 获取连接状态信息
   */
  getConnectionInfo(): string {
    const method = this.getConnectionMethod();

    if (this.isActive()) {
      return `已通过${method}连接`;
    } else if (this.isListening) {
      return `正在通过${method}连接...`;
    } else {
      return '未连接';
    }
  }
}
