/**
 * 导航数据模型
 * 用于存储从高德地图解析出的导航信息
 */

// 导航类型枚举
export enum NavigationType {
  STRAIGHT = 'STRAIGHT',       // 直行
  LEFT_TURN = 'LEFT_TURN',      // 左转
  RIGHT_TURN = 'RIGHT_TURN',     // 右转
  U_TURN = 'U_TURN',         // 掉头
  LEFT_FRONT = 'LEFT_FRONT',     // 左前方
  RIGHT_FRONT = 'RIGHT_FRONT',    // 右前方
  LEFT_BACK = 'LEFT_BACK',      // 左后方
  RIGHT_BACK = 'RIGHT_BACK',     // 右后方
  MERGE_LEFT = 'MERGE_LEFT',     // 靠左
  MERGE_RIGHT = 'MERGE_RIGHT',    // 靠右
  ROUNDABOUT = 'ROUNDABOUT',     // 环岛
  EXIT = 'EXIT',           // 出口
  ARRIVE = 'ARRIVE',         // 到达目的地
  UNKNOWN = 'UNKNOWN'        // 未知
}

// 导航数据类
export class NavigationData {
  // 当前导航指令（如"前方500米左转"）
  instruction: string = '';

  // 导航类型
  navType: NavigationType = NavigationType.UNKNOWN;

  // 距离（单位：米）
  distance: number = 0;

  // 当前道路名称
  currentRoad: string = '';

  // 下一条道路名称
  nextRoad: string = '';

  // 剩余距离（单位：米）
  remainingDistance: number = 0;

  // 预计剩余时间（单位：秒）
  remainingTime: number = 0;

  // 当前速度（单位：km/h）
  currentSpeed: number = 0;

  // 是否正在导航
  isNavigating: boolean = false;

  // 时间戳
  timestamp: number = 0;

  // 构造函数
  constructor(instruction?: string, navType?: NavigationType, distance?: number) {
    if (instruction) this.instruction = instruction;
    if (navType) this.navType = navType;
    if (distance) this.distance = distance;
    this.timestamp = this.getCurrentTimestamp();
  }

  // 获取当前时间戳（毫秒）
  private getCurrentTimestamp(): number {
    return Date.now();
  }

  // 格式化距离显示
  formatDistance(): string {
    if (this.distance < 1000) {
      return `${this.distance}米`;
    } else {
      const km = Math.floor(this.distance / 1000);
      const m = this.distance % 1000;
      if (m === 0) {
        return `${km}公里`;
      } else {
        return `${km}.${Math.floor(m / 100)}公里`;
      }
    }
  }

  // 格式化剩余时间显示
  formatRemainingTime(): string {
    if (this.remainingTime < 60) {
      return `${this.remainingTime}秒`;
    } else if (this.remainingTime < 3600) {
      const minutes = Math.floor(this.remainingTime / 60);
      return `${minutes}分钟`;
    } else {
      const hours = Math.floor(this.remainingTime / 3600);
      const minutes = Math.floor((this.remainingTime % 3600) / 60);
      if (minutes === 0) {
        return `${hours}小时`;
      } else {
        return `${hours}小时${minutes}分钟`;
      }
    }
  }

  // 获取导航类型的中文描述
  getNavTypeDescription(): string {
    switch (this.navType) {
      case NavigationType.STRAIGHT:
        return '直行';
      case NavigationType.LEFT_TURN:
        return '左转';
      case NavigationType.RIGHT_TURN:
        return '右转';
      case NavigationType.U_TURN:
        return '掉头';
      case NavigationType.LEFT_FRONT:
        return '左前方';
      case NavigationType.RIGHT_FRONT:
        return '右前方';
      case NavigationType.LEFT_BACK:
        return '左后方';
      case NavigationType.RIGHT_BACK:
        return '右后方';
      case NavigationType.MERGE_LEFT:
        return '靠左行驶';
      case NavigationType.MERGE_RIGHT:
        return '靠右行驶';
      case NavigationType.ROUNDABOUT:
        return '进入环岛';
      case NavigationType.EXIT:
        return '驶出';
      case NavigationType.ARRIVE:
        return '到达目的地';
      default:
        return '未知';
    }
  }

  // 重置数据
  reset(): void {
    this.instruction = '';
    this.navType = NavigationType.UNKNOWN;
    this.distance = 0;
    this.currentRoad = '';
    this.nextRoad = '';
    this.remainingDistance = 0;
    this.remainingTime = 0;
    this.currentSpeed = 0;
    this.isNavigating = false;
    this.timestamp = 0;
  }
}
