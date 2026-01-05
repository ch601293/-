/**
 * 平台抽象层
 * 定义跨平台接口，支持 HarmonyOS、Android、HyperOS 等
 */

import { NavigationData } from '../model/NavigationData';
import hilog from '@ohos.hilog';
import { Constants } from '../utils/Constants';

/**
 * 平台类型枚举
 */
export enum PlatformType {
  HARMONYOS = 'HARMONYOS',        // 鸿蒙系统
  ANDROID = 'ANDROID',          // 安卓系统
  HYPEROS = 'HYPEROS',          // 澎湃系统（小米）
  UNKNOWN = 'UNKNOWN'          // 未知平台
}

/**
 * 平台检测器
 */
export class PlatformDetector {
  /**
   * 检测当前运行平台
   */
  static detectPlatform(): PlatformType {
    // 检测 HarmonyOS
    if (this.isHarmonyOS()) {
      return PlatformType.HARMONYOS;
    }

    // 检测 HyperOS（小米澎湃系统）
    if (this.isHyperOS()) {
      return PlatformType.HYPEROS;
    }

    // 检测 Android
    if (this.isAndroid()) {
      return PlatformType.ANDROID;
    }

    return PlatformType.UNKNOWN;
  }

  /**
   * 检测是否为 HarmonyOS
   */
  private static isHarmonyOS(): boolean {
    try {
      // HarmonyOS 环境下会有 ohos 模块
      // 在 HarmonyOS 中运行，默认就是 HarmonyOS
      return true;
    } catch (e) {
      return false;
    }
  }

  /**
   * 检测是否为 HyperOS（小米澎湃系统）
   */
  private static isHyperOS(): boolean {
    // 在实际应用中，需要通过系统属性判断
    // 这里简化处理
    return false;
  }

  /**
   * 检测是否为 Android
   */
  private static isAndroid(): boolean {
    // 在实际应用中，需要通过系统属性判断
    return false;
  }

  /**
   * 获取平台版本号
   */
  static getPlatformVersion(): string {
    const platform = this.detectPlatform();

    switch (platform) {
      case PlatformType.HARMONYOS:
        return 'HarmonyOS 4.0'; // 实际应该从系统获取
      case PlatformType.HYPEROS:
        return 'HyperOS 1.0';
      case PlatformType.ANDROID:
        return 'Android 12';
      default:
        return 'Unknown';
    }
  }
}

/**
 * 导航数据回调接口
 */
export interface NavigationCallback {
  /**
   * 导航数据更新回调
   */
  onNavigationUpdate(data: NavigationData): void;

  /**
   * 连接错误回调
   */
  onConnectionError(error: string): void;

  /**
   * 导航结束回调
   */
  onNavigationEnd(): void;
}

/**
 * 平台服务接口
 * 定义跨平台的通用接口
 */
export interface IPlatformService {
  /**
   * 初始化平台服务
   * @param callback 导航数据回调
   */
  initialize(callback: NavigationCallback): void;

  /**
   * 启动监听
   */
  startListening(): void;

  /**
   * 停止监听
   */
  stopListening(): void;

  /**
   * 清理资源
   */
  cleanup(): void;
}

/**
 * 平台服务工厂
 */
export class PlatformServiceFactory {
  /**
   * 创建适合当前平台的服务实例
   */
  static createService(platform?: PlatformType): IPlatformService {
    const targetPlatform = platform || PlatformDetector.detectPlatform();

    hilog.info(0x0000, Constants.LOG_TAG,
      'PlatformFactory: Creating service for platform: %{public}s', targetPlatform.toString());

    switch (targetPlatform) {
      case PlatformType.HARMONYOS:
        // 延迟导入避免循环依赖
        return this.createHarmonyOSService();

      case PlatformType.HYPEROS:
        return this.createHyperOSService();

      case PlatformType.ANDROID:
        return this.createAndroidService();

      default:
        // 默认返回 HarmonyOS 服务
        hilog.warn(0x0000, Constants.LOG_TAG,
          'PlatformFactory: Unknown platform, using HarmonyOS service as fallback');
        return this.createHarmonyOSService();
    }
  }

  /**
   * 创建 HarmonyOS 服务
   */
  private static createHarmonyOSService(): IPlatformService {
    // 使用动态导入避免循环依赖
    const { HarmonyOSService } = require('../service/HarmonyOSService');
    return new HarmonyOSService();
  }

  /**
   * 创建 Android 服务
   */
  private static createAndroidService(): IPlatformService {
    const { AndroidService } = require('../service/AndroidService');
    return new AndroidService();
  }

  /**
   * 创建 HyperOS 服务
   */
  private static createHyperOSService(): IPlatformService {
    const { HyperOSService } = require('../service/HyperOSService');
    return new HyperOSService();
  }

  /**
   * 创建指定平台的服务实例
   */
  static createServiceForPlatform(platform: PlatformType): IPlatformService {
    return this.createService(platform);
  }
}
