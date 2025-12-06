/**
 * VM Serviceから取得するタイムラインイベントの型定義
 * Chrome Trace Event Format準拠
 */
export interface TimelineEvent {
  name: string;           // イベント名（例: "Frame", "BUILD", "LAYOUT"）
  cat: string;            // カテゴリ（例: "Dart", "Embedder", "GC"）
  ph: string;             // フェーズ（例: "X" = Complete Event）
  ts: number;             // タイムスタンプ（マイクロ秒）
  dur?: number;           // 継続時間（マイクロ秒）
  pid: number;            // プロセスID
  tid: number;            // スレッドID
  args?: Record<string, any>;  // 追加引数
}

/**
 * VM Serviceからのタイムラインレスポンス
 */
export interface TimelineResponse {
  type: string;
  traceEvents: TimelineEvent[];
  timeOriginMicros: number;
  timeExtentMicros: number;
}

/**
 * フレームごとのパフォーマンスメトリクス
 */
export interface FrameMetrics {
  frameNumber: number;         // フレーム番号
  buildDuration: number;       // Widget build時間（ms）
  layoutDuration: number;      // Layout計算時間（ms）
  paintDuration: number;       // Paint処理時間（ms）
  rasterDuration: number;      // GPU Rasterize時間（ms）
  totalDuration: number;       // フレーム全体の時間（ms）
  isJanky: boolean;            // フレームドロップ判定
  bottleneck: 'build' | 'layout' | 'paint' | 'raster' | null;
  timestamp: number;           // フレーム開始時刻（マイクロ秒）
}

/**
 * ボトルネック集計
 */
export interface BottleneckSummary {
  build: number;    // Build起因のフレームドロップ数
  layout: number;   // Layout起因のフレームドロップ数
  paint: number;    // Paint起因のフレームドロップ数
  raster: number;   // Raster起因のフレームドロップ数
}

/**
 * パフォーマンスサマリー
 */
export interface PerformanceSummary {
  totalFrames: number;           // 総フレーム数
  jankyFrames: number;           // フレームドロップ数
  jankyPercentage: string;       // フレームドロップ率（%）
  avgFps: string;                // 平均FPS
  avgBuildTime: string;          // 平均Build時間（ms）
  avgLayoutTime: string;         // 平均Layout時間（ms）
  avgPaintTime: string;          // 平均Paint時間（ms）
  avgRasterTime: string;         // 平均Raster時間（ms）
  bottlenecks: BottleneckSummary;
  recordingDuration: number;     // 記録時間（秒）
}

/**
 * パフォーマンス分析結果（MCPリソース用）
 */
export interface PerformanceAnalysis {
  summary: PerformanceSummary;
  frames: FrameMetrics[];
  recommendations: string[];      // AI用の推奨事項リスト
}

/**
 * VM Service接続設定
 */
export interface VMServiceConfig {
  uri: string;                    // VM Service URI（例: http://localhost:8181）
  isolateId?: string;             // 対象IsolateID
  recordingDuration?: number;     // 記録時間（秒、デフォルト: 10）
}

/**
 * VM Service JSONRPCリクエスト
 */
export interface VMServiceRequest {
  jsonrpc: string;
  id: number;
  method: string;
  params: Record<string, any>;
}

/**
 * VM Service JSONRPCレスポンス
 */
export interface VMServiceResponse {
  jsonrpc: string;
  id: number;
  result?: any;
  error?: {
    code: number;
    message: string;
    data?: any;
  };
}
