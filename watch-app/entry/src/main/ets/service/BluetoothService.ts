/**
 * 蓝牙服务
 * 处理与手机的蓝牙通信
 */

import bluetooth from '@ohos.bluetooth';
import hilog from '@ohos.hilog';
import { Constants } from '../utils/Constants';

export type BluetoothDataCallback = (data: string) => void;
export type BluetoothConnectionCallback = (success: boolean, message: string) => void;

export class BluetoothService {
  private dataCallback?: BluetoothDataCallback;
  private isConnected: boolean = false;
  private serverSocket?: any;
  private clientSocket?: any;
  private receivedDataBuffer: string = '';

  // 蓝牙服务 UUID（用于导航数据传输）
  private readonly SERVICE_UUID: string = '00001101-0000-1000-8000-00805F9B34FB';

  initialize(callback: BluetoothDataCallback): void {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s', 'BluetoothService: Initializing');
    this.dataCallback = callback;

    // 检查蓝牙状态
    this.checkBluetoothState();
  }

  /**
   * 检查蓝牙状态
   */
  private checkBluetoothState(): void {
    try {
      const state = bluetooth.getState();

      switch (state) {
        case bluetooth.BluetoothState.STATE_ON:
          hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
            'BluetoothService: Bluetooth is ON');
          break;

        case bluetooth.BluetoothState.STATE_OFF:
          hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s',
            'BluetoothService: Bluetooth is OFF');
          // 请求打开蓝牙
          this.requestEnableBluetooth();
          break;

        case bluetooth.BluetoothState.STATE_TURNING_ON:
          hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
            'BluetoothService: Bluetooth is turning ON');
          break;

        case bluetooth.BluetoothState.STATE_TURNING_OFF:
          hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s',
            'BluetoothService: Bluetooth is turning OFF');
          break;

        default:
          hilog.warn(0x0000, Constants.LOG_TAG,
            'BluetoothService: Unknown Bluetooth state: %{public}d', state);
      }
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'BluetoothService: Error checking Bluetooth state: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  /**
   * 请求打开蓝牙
   */
  private requestEnableBluetooth(): void {
    try {
      bluetooth.enableBluetooth();
      hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
        'BluetoothService: Bluetooth enable requested');
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'BluetoothService: Failed to enable Bluetooth: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  /**
   * 启动蓝牙连接
   */
  startConnection(callback: BluetoothConnectionCallback): void {
    if (this.isConnected) {
      hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s',
        'BluetoothService: Already connected');
      callback(true, 'Already connected');
      return;
    }

    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
      'BluetoothService: Starting connection');

    try {
      // 获取配对设备列表
      const pairedDevices = bluetooth.getPairedDevices();

      if (pairedDevices.length === 0) {
        hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s',
          'BluetoothService: No paired devices found');
        callback(false, '未找到配对设备');
        return;
      }

      hilog.info(0x0000, Constants.LOG_TAG,
        'BluetoothService: Found %{public}d paired device(s)', pairedDevices.length);

      // 尝试连接第一个配对的设备（实际应用中可以让用户选择）
      this.connectToDevice(pairedDevices[0], callback);
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'BluetoothService: Error starting connection: %{public}s',
        JSON.stringify(error) ?? '');
      callback(false, '启动连接失败');
    }
  }

  /**
   * 连接到指定设备
   */
  private connectToDevice(device: any, callback: BluetoothConnectionCallback): void {
    try {
      hilog.info(0x0000, Constants.LOG_TAG,
        'BluetoothService: Connecting to device: %{public}s', device.deviceName || 'Unknown');

      // 创建客户端 Socket
      bluetooth.sppConnect(device.deviceId, {
        uuid: this.SERVICE_UUID,
        secure: true,
        type: bluetooth.SppType.SPP_RFCOMM
      }, (code, socket) => {
        if (code.code === 0 && socket) {
          hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
            'BluetoothService: Connected successfully');

          this.clientSocket = socket;
          this.isConnected = true;

          // 开始接收数据
          this.startReceivingData();

          callback(true, '连接成功');
        } else {
          hilog.error(0x0000, Constants.LOG_TAG,
            'BluetoothService: Connection failed with code: %{public}d', code.code);
          callback(false, '连接失败');
        }
      });
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'BluetoothService: Error connecting to device: %{public}s',
        JSON.stringify(error) ?? '');
      callback(false, '连接异常');
    }
  }

  /**
   * 开始接收数据
   */
  private startReceivingData(): void {
    if (!this.clientSocket) {
      return;
    }

    try {
      // 监听数据接收事件
      this.clientSocket.on('readData', (dataBuffer: ArrayBuffer) => {
        this.handleReceivedData(dataBuffer);
      });

      hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
        'BluetoothService: Started receiving data');
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'BluetoothService: Error starting data reception: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  /**
   * 处理接收到的数据
   */
  private handleReceivedData(dataBuffer: ArrayBuffer): void {
    try {
      // 将 ArrayBuffer 转换为字符串
      const uint8Array = new Uint8Array(dataBuffer);
      let dataStr = '';

      for (let i = 0; i < uint8Array.length; i++) {
        dataStr += String.fromCharCode(uint8Array[i]);
      }

      hilog.debug(0x0000, Constants.LOG_TAG,
        'BluetoothService: Received data: %{public}s', dataStr);

      // 添加到缓冲区
      this.receivedDataBuffer += dataStr;

      // 检查是否有完整的消息（假设以换行符分隔）
      const messages = this.receivedDataBuffer.split('\n');

      // 处理完整的消息
      for (let i = 0; i < messages.length - 1; i++) {
        const message = messages[i].trim();

        if (message.length > 0 && this.dataCallback) {
          this.dataCallback(message);
        }
      }

      // 保留最后一个不完整的消息
      this.receivedDataBuffer = messages[messages.length - 1];
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'BluetoothService: Error handling received data: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  /**
   * 发送数据
   */
  sendData(data: string): boolean {
    if (!this.isConnected || !this.clientSocket) {
      hilog.warn(0x0000, Constants.LOG_TAG, '%{public}s',
        'BluetoothService: Not connected, cannot send data');
      return false;
    }

    try {
      // 转换字符串为 ArrayBuffer
      const encoder = new TextEncoder();
      const uint8Array = encoder.encode(data + '\n');
      const arrayBuffer = uint8Array.buffer;

      // 发送数据
      this.clientSocket.write(arrayBuffer);

      hilog.debug(0x0000, Constants.LOG_TAG,
        'BluetoothService: Sent data: %{public}s', data);

      return true;
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'BluetoothService: Error sending data: %{public}s',
        JSON.stringify(error) ?? '');
      return false;
    }
  }

  /**
   * 断开连接
   */
  disconnect(): void {
    if (!this.isConnected) {
      return;
    }

    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
      'BluetoothService: Disconnecting');

    try {
      if (this.clientSocket) {
        this.clientSocket.off('readData');
        bluetooth.sppCloseClientSocket(this.clientSocket.id);
        this.clientSocket = undefined;
      }

      if (this.serverSocket) {
        bluetooth.sppCloseServerSocket(this.serverSocket.id);
        this.serverSocket = undefined;
      }

      this.isConnected = false;
      this.receivedDataBuffer = '';

      hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
        'BluetoothService: Disconnected');
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'BluetoothService: Error disconnecting: %{public}s',
        JSON.stringify(error) ?? '');
    }
  }

  /**
   * 清理资源
   */
  cleanup(): void {
    hilog.info(0x0000, Constants.LOG_TAG, '%{public}s',
      'BluetoothService: Cleaning up');

    this.disconnect();
    this.dataCallback = undefined;
  }

  /**
   * 获取连接状态
   */
  isConnected(): boolean {
    return this.isConnected;
  }

  /**
   * 获取配对设备列表
   */
  getPairedDevices(): any[] {
    try {
      return bluetooth.getPairedDevices();
    } catch (error) {
      hilog.error(0x0000, Constants.LOG_TAG,
        'BluetoothService: Error getting paired devices: %{public}s',
        JSON.stringify(error) ?? '');
      return [];
    }
  }
}
