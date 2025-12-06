import WebSocket from 'ws';
import type {
  VMServiceConfig,
  VMServiceRequest,
  VMServiceResponse,
  TimelineResponse
} from './types.js';

/**
 * Flutter VM Serviceへの接続とデータ取得を管理するクラス
 */
export class VMServiceConnector {
  private ws: WebSocket | null = null;
  private requestId = 0;
  private config: VMServiceConfig;
  private pendingRequests = new Map<number, {
    resolve: (value: any) => void;
    reject: (reason: any) => void;
  }>();

  constructor(config: VMServiceConfig) {
    this.config = config;
  }

  /**
   * VM Serviceに接続
   */
  async connect(): Promise<void> {
    const wsUri = this.config.uri.replace('http://', 'ws://').replace('https://', 'wss://');
    const fullUri = wsUri.endsWith('/ws') ? wsUri : `${wsUri}/ws`;

    console.error(`[VM Service] Connecting to ${fullUri}...`);

    return new Promise((resolve, reject) => {
      this.ws = new WebSocket(fullUri);

      this.ws.on('open', () => {
        console.error('[VM Service] Connected successfully');
        resolve();
      });

      this.ws.on('message', (data: WebSocket.Data) => {
        this.handleMessage(data.toString());
      });

      this.ws.on('error', (error) => {
        console.error('[VM Service] WebSocket error:', error);
        reject(error);
      });

      this.ws.on('close', () => {
        console.error('[VM Service] Connection closed');
      });

      // タイムアウト設定（5秒）
      setTimeout(() => {
        if (this.ws?.readyState !== WebSocket.OPEN) {
          reject(new Error('Connection timeout'));
        }
      }, 5000);
    });
  }

  /**
   * VM Serviceからのメッセージを処理
   */
  private handleMessage(message: string): void {
    try {
      const response: VMServiceResponse = JSON.parse(message);

      // ストリームイベント（event通知）は無視
      if ('method' in response) {
        return;
      }

      const pending = this.pendingRequests.get(response.id);
      if (pending) {
        this.pendingRequests.delete(response.id);

        if (response.error) {
          pending.reject(new Error(response.error.message));
        } else {
          pending.resolve(response.result);
        }
      }
    } catch (error) {
      console.error('[VM Service] Failed to parse message:', error);
    }
  }

  /**
   * VM Serviceにリクエストを送信
   */
  private async sendRequest(method: string, params: Record<string, any> = {}): Promise<any> {
    if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
      throw new Error('VM Service is not connected');
    }

    const id = ++this.requestId;
    const request: VMServiceRequest = {
      jsonrpc: '2.0',
      id,
      method,
      params
    };

    return new Promise((resolve, reject) => {
      this.pendingRequests.set(id, { resolve, reject });

      this.ws!.send(JSON.stringify(request));

      // リクエストタイムアウト（10秒）
      setTimeout(() => {
        if (this.pendingRequests.has(id)) {
          this.pendingRequests.delete(id);
          reject(new Error(`Request timeout: ${method}`));
        }
      }, 10000);
    });
  }

  /**
   * VM情報を取得
   */
  async getVM(): Promise<any> {
    return this.sendRequest('getVM', {});
  }

  /**
   * メインIsolateのIDを取得
   */
  async getMainIsolateId(): Promise<string> {
    const vm = await this.getVM();

    // メインIsolateを探す（通常は最初のIsolate）
    const mainIsolate = vm.isolates?.find((isolate: any) =>
      isolate.name === 'main' || isolate.number === '1'
    );

    if (!mainIsolate) {
      throw new Error('Main isolate not found');
    }

    return mainIsolate.id;
  }

  /**
   * タイムライン記録を開始
   */
  async startTimeline(): Promise<void> {
    console.error('[VM Service] Starting timeline recording...');

    // タイムラインストリームを有効化
    await this.sendRequest('setVMTimelineFlags', {
      recordedStreams: ['Dart', 'Embedder', 'GC', 'Isolate']
    });

    // 既存のタイムラインデータをクリア
    await this.sendRequest('clearVMTimeline', {});

    console.error('[VM Service] Timeline recording started');
  }

  /**
   * タイムライン記録を停止してデータを取得
   */
  async stopTimeline(): Promise<TimelineResponse> {
    console.error('[VM Service] Stopping timeline recording...');

    // タイムラインデータを取得
    const result = await this.sendRequest('getVMTimeline', {});

    // タイムライン記録を停止
    await this.sendRequest('setVMTimelineFlags', {
      recordedStreams: []
    });

    console.error(`[VM Service] Timeline recording stopped (${result.traceEvents?.length || 0} events)`);

    return result as TimelineResponse;
  }

  /**
   * 指定時間タイムラインを記録
   */
  async recordTimeline(durationSeconds: number = 10): Promise<TimelineResponse> {
    await this.startTimeline();

    console.error(`[VM Service] Recording for ${durationSeconds} seconds...`);

    // 指定時間待機
    await new Promise(resolve => setTimeout(resolve, durationSeconds * 1000));

    return this.stopTimeline();
  }

  /**
   * 接続を切断
   */
  disconnect(): void {
    if (this.ws) {
      this.ws.close();
      this.ws = null;
      console.error('[VM Service] Disconnected');
    }
  }

  /**
   * 接続状態を確認
   */
  isConnected(): boolean {
    return this.ws?.readyState === WebSocket.OPEN;
  }
}
