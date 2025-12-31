/**
 * 导航数据解析器
 * 从高德地图通知内容中解析出导航信息
 */

import { NavigationData, NavigationType } from '../model/NavigationData';
import { Constants } from '../utils/Constants';
import hilog from '@ohos.hilog';

export class NavigationParser {
  private lastParsedData: NavigationData = new NavigationData();

  /**
   * 解析通知内容，提取导航信息
   * @param title 通知标题
   * @param content 通知内容
   * @return 解析后的导航数据
   */
  parseNotification(title: string, content: string): NavigationData {
    const navData = new NavigationData();

    // 如果内容为空，返回空数据
    if (!content || content.length === 0) {
      return navData;
    }

    // 设置为正在导航状态
    navData.isNavigating = true;

    // 解析导航指令
    navData.instruction = content;

    // 解析导航类型
    navData.navType = this.parseNavigationType(content);

    // 解析距离信息
    navData.distance = this.parseDistance(content);

    // 解析道路信息
    this.parseRoadInfo(content, navData);

    // 解析剩余距离和时间
    this.parseRemainingInfo(content, navData);

    // 设置时间戳
    navData.timestamp = Date.now();

    // 保存最后解析的数据
    this.lastParsedData = navData;

    return navData;
  }

  /**
   * 解析导航类型
   */
  private parseNavigationType(content: string): NavigationType {
    if (content.includes('直行') || content.includes('继续前行')) {
      return NavigationType.STRAIGHT;
    } else if (content.includes('左转')) {
      return NavigationType.LEFT_TURN;
    } else if (content.includes('右转')) {
      return NavigationType.RIGHT_TURN;
    } else if (content.includes('掉头') || content.includes('调头')) {
      return NavigationType.U_TURN;
    } else if (content.includes('左前方')) {
      return NavigationType.LEFT_FRONT;
    } else if (content.includes('右前方')) {
      return NavigationType.RIGHT_FRONT;
    } else if (content.includes('左后方')) {
      return NavigationType.LEFT_BACK;
    } else if (content.includes('右后方')) {
      return NavigationType.RIGHT_BACK;
    } else if (content.includes('靠左')) {
      return NavigationType.MERGE_LEFT;
    } else if (content.includes('靠右')) {
      return NavigationType.MERGE_RIGHT;
    } else if (content.includes('环岛')) {
      return NavigationType.ROUNDABOUT;
    } else if (content.includes('出口') || content.includes('驶出')) {
      return NavigationType.EXIT;
    } else if (content.includes('到达') || content.includes('已到达')) {
      return NavigationType.ARRIVE;
    } else {
      return NavigationType.UNKNOWN;
    }
  }

  /**
   * 解析距离信息
   * 支持格式：500米、1.5公里、1500m、1.5km 等
   */
  private parseDistance(content: string): number {
    let distance = 0;

    // 匹配 "XXX米" 格式
    if (content.includes('米')) {
      distance = this.extractNumber(content, '米');
    }
    // 匹配 "XXX公里" 或 "XXXkm" 格式
    else if (content.includes('公里') || content.includes('km')) {
      const km = this.extractNumberWithDecimal(content, '公里');
      distance = Math.floor(km * 1000);
    }
    // 匹配 "XXXm" 格式
    else if (content.includes('m') && !content.includes('km')) {
      distance = this.extractNumber(content, 'm');
    }

    return distance;
  }

  /**
   * 解析道路信息
   */
  private parseRoadInfo(content: string, navData: NavigationData): void {
    // 尝试解析当前道路和下一条道路
    // 通常格式为："进入XX路" 或 "从XX路转入YY路"

    if (content.includes('进入')) {
      const parts = content.split('进入');
      if (parts.length > 1) {
        navData.nextRoad = this.extractRoadName(parts[1]);
      }
    }

    if (content.includes('转入')) {
      const parts = content.split('转入');
      if (parts.length > 1) {
        navData.nextRoad = this.extractRoadName(parts[1]);
      }
    }
  }

  /**
   * 解析剩余距离和时间
   * 通常在通知标题或底部显示，如："剩余15公里，约20分钟"
   */
  private parseRemainingInfo(content: string, navData: NavigationData): void {
    // 解析剩余距离
    if (content.includes('剩余')) {
      if (content.includes('公里')) {
        const km = this.extractNumberWithDecimal(content, '公里');
        navData.remainingDistance = Math.floor(km * 1000);
      } else if (content.includes('米')) {
        navData.remainingDistance = this.extractNumber(content, '米');
      }
    }

    // 解析剩余时间
    if (content.includes('分钟')) {
      const minutes = this.extractNumber(content, '分钟');
      navData.remainingTime = minutes * 60;
    }
    if (content.includes('小时')) {
      const hours = this.extractNumber(content, '小时');
      navData.remainingTime += hours * 3600;
    }
  }

  /**
   * 从文本中提取数字（整数）
   */
  private extractNumber(text: string, keyword: string): number {
    const index = text.indexOf(keyword);
    if (index > 0) {
      let numStr = '';
      let i = index - 1;

      // 向前查找数字
      while (i >= 0 && this.isDigit(text.charAt(i))) {
        numStr = text.charAt(i) + numStr;
        i--;
      }

      if (numStr.length > 0) {
        return parseInt(numStr);
      }
    }
    return 0;
  }

  /**
   * 从文本中提取数字（支持小数）
   */
  private extractNumberWithDecimal(text: string, keyword: string): number {
    const index = text.indexOf(keyword);
    if (index > 0) {
      let numStr = '';
      let i = index - 1;
      let hasDot = false;

      // 向前查找数字和小数点
      while (i >= 0 && (this.isDigit(text.charAt(i)) || text.charAt(i) === '.')) {
        if (text.charAt(i) === '.') {
          if (hasDot) break;  // 已经有小数点了
          hasDot = true;
        }
        numStr = text.charAt(i) + numStr;
        i--;
      }

      if (numStr.length > 0) {
        return parseFloat(numStr);
      }
    }
    return 0.0;
  }

  /**
   * 提取道路名称
   */
  private extractRoadName(text: string): string {
    // 简化实现：提取第一个词组
    let roadName = text.trim();

    // 移除可能的标点符号
    const stopChars = [',', '，', '。', '.', ' '];
    for (const ch of stopChars) {
      const idx = roadName.indexOf(ch);
      if (idx > 0) {
        roadName = roadName.substring(0, idx);
      }
    }

    return roadName;
  }

  /**
   * 判断字符是否为数字
   */
  private isDigit(ch: string): boolean {
    return ch >= '0' && ch <= '9';
  }

  /**
   * 获取最后解析的数据
   */
  getLastParsedData(): NavigationData {
    return this.lastParsedData;
  }

  /**
   * 判断通知是否为导航通知
   */
  isNavigationNotification(packageName: string, content: string): boolean {
    // 检查包名是否为高德地图
    let isAmapPackage = false;
    for (const pkgName of Constants.AMAP_PACKAGE_NAMES) {
      if (packageName === pkgName) {
        isAmapPackage = true;
        break;
      }
    }

    if (!isAmapPackage) {
      return false;
    }

    // 检查内容是否包含导航关键词
    for (const keyword of Constants.NAV_KEYWORDS) {
      if (content.includes(keyword)) {
        return true;
      }
    }

    return false;
  }
}
