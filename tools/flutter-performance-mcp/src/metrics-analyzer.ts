import type {
  TimelineEvent,
  TimelineResponse,
  FrameMetrics,
  PerformanceSummary,
  PerformanceAnalysis,
  BottleneckSummary
} from './types.js';

/**
 * パフォーマンスメトリクスを計算・分析するクラス
 */
export class MetricsAnalyzer {
  private static readonly TARGET_FRAME_TIME = 16.67; // 60fps = 16.67ms/frame
  private static readonly MICROSECONDS_TO_MS = 1000;

  /**
   * タイムラインデータからフレームメトリクスを計算
   */
  static analyzeTimeline(timelineData: TimelineResponse): PerformanceAnalysis {
    const frames = this.extractFrameMetrics(timelineData.traceEvents);
    const summary = this.calculateSummary(frames, timelineData);
    const recommendations = this.generateRecommendations(summary, frames);

    return {
      summary,
      frames,
      recommendations
    };
  }

  /**
   * タイムラインイベントからフレームメトリクスを抽出
   */
  private static extractFrameMetrics(events: TimelineEvent[]): FrameMetrics[] {
    const frames: FrameMetrics[] = [];

    // "Frame"イベントを探す（UIスレッドのフレーム）
    const frameEvents = events.filter(e =>
      e.name === 'Frame' && e.ph === 'X' && e.cat === 'Embedder'
    );

    for (const frameEvent of frameEvents) {
      const frameNumber = frameEvent.args?.number ?? frames.length;
      const timestamp = frameEvent.ts;

      // フレーム内の各フェーズイベントを検索
      const buildEvent = this.findPhaseEvent(events, timestamp, 'BUILD');
      const layoutEvent = this.findPhaseEvent(events, timestamp, 'LAYOUT');
      const paintEvent = this.findPhaseEvent(events, timestamp, 'PAINT');

      // Rasterスレッドのイベントを検索
      const rasterEvent = this.findRasterEvent(events, timestamp, frameEvent.dur || 0);

      const buildMs = this.microsToMs(buildEvent?.dur || 0);
      const layoutMs = this.microsToMs(layoutEvent?.dur || 0);
      const paintMs = this.microsToMs(paintEvent?.dur || 0);
      const rasterMs = this.microsToMs(rasterEvent?.dur || 0);
      const totalDuration = this.microsToMs(frameEvent.dur || 0);

      const isJanky = totalDuration > this.TARGET_FRAME_TIME || rasterMs > this.TARGET_FRAME_TIME;

      // ボトルネック特定
      let bottleneck: FrameMetrics['bottleneck'] = null;
      if (isJanky) {
        const maxDuration = Math.max(buildMs, layoutMs, paintMs, rasterMs);
        if (buildMs === maxDuration && buildMs > this.TARGET_FRAME_TIME * 0.5) {
          bottleneck = 'build';
        } else if (layoutMs === maxDuration && layoutMs > this.TARGET_FRAME_TIME * 0.3) {
          bottleneck = 'layout';
        } else if (paintMs === maxDuration && paintMs > this.TARGET_FRAME_TIME * 0.3) {
          bottleneck = 'paint';
        } else if (rasterMs === maxDuration && rasterMs > this.TARGET_FRAME_TIME * 0.5) {
          bottleneck = 'raster';
        }
      }

      frames.push({
        frameNumber,
        buildDuration: buildMs,
        layoutDuration: layoutMs,
        paintDuration: paintMs,
        rasterDuration: rasterMs,
        totalDuration,
        isJanky,
        bottleneck,
        timestamp
      });
    }

    return frames;
  }

  /**
   * 特定フェーズのイベントを検索
   */
  private static findPhaseEvent(
    events: TimelineEvent[],
    frameTimestamp: number,
    phaseName: string
  ): TimelineEvent | undefined {
    // フレームタイムスタンプ前後の範囲でイベントを検索
    const rangeMs = 20000; // ±20ms（マイクロ秒）

    return events.find(e =>
      e.name === phaseName &&
      e.ts >= frameTimestamp - rangeMs &&
      e.ts <= frameTimestamp + rangeMs
    );
  }

  /**
   * Rasterスレッドのイベントを検索
   */
  private static findRasterEvent(
    events: TimelineEvent[],
    frameTimestamp: number,
    frameDuration: number
  ): TimelineEvent | undefined {
    // GPUスレッドの"Rasterizer::Draw"イベントを探す
    const rangeEnd = frameTimestamp + frameDuration + 50000; // フレーム終了+50ms

    return events.find(e =>
      (e.name === 'Rasterizer::Draw' || e.name === 'GPURasterizer::Draw') &&
      e.ts >= frameTimestamp &&
      e.ts <= rangeEnd
    );
  }

  /**
   * マイクロ秒をミリ秒に変換
   */
  private static microsToMs(micros: number): number {
    return micros / this.MICROSECONDS_TO_MS;
  }

  /**
   * サマリー統計を計算
   */
  private static calculateSummary(
    frames: FrameMetrics[],
    timelineData: TimelineResponse
  ): PerformanceSummary {
    const totalFrames = frames.length;
    const jankyFrames = frames.filter(f => f.isJanky).length;

    const avgBuild = this.average(frames.map(f => f.buildDuration));
    const avgLayout = this.average(frames.map(f => f.layoutDuration));
    const avgPaint = this.average(frames.map(f => f.paintDuration));
    const avgRaster = this.average(frames.map(f => f.rasterDuration));

    const avgFrameTime = this.average(frames.map(f => f.totalDuration));
    const avgFps = avgFrameTime > 0 ? 1000 / avgFrameTime : 60;

    const bottlenecks: BottleneckSummary = {
      build: frames.filter(f => f.bottleneck === 'build').length,
      layout: frames.filter(f => f.bottleneck === 'layout').length,
      paint: frames.filter(f => f.bottleneck === 'paint').length,
      raster: frames.filter(f => f.bottleneck === 'raster').length
    };

    const recordingDuration = timelineData.timeExtentMicros
      ? timelineData.timeExtentMicros / 1000000
      : 0;

    return {
      totalFrames,
      jankyFrames,
      jankyPercentage: totalFrames > 0 ? ((jankyFrames / totalFrames) * 100).toFixed(1) : '0.0',
      avgFps: avgFps.toFixed(1),
      avgBuildTime: avgBuild.toFixed(2),
      avgLayoutTime: avgLayout.toFixed(2),
      avgPaintTime: avgPaint.toFixed(2),
      avgRasterTime: avgRaster.toFixed(2),
      bottlenecks,
      recordingDuration: parseFloat(recordingDuration.toFixed(1))
    };
  }

  /**
   * 平均値を計算
   */
  private static average(values: number[]): number {
    if (values.length === 0) return 0;
    return values.reduce((sum, val) => sum + val, 0) / values.length;
  }

  /**
   * 改善提案を生成
   */
  private static generateRecommendations(
    summary: PerformanceSummary,
    frames: FrameMetrics[]
  ): string[] {
    const recommendations: string[] = [];

    // フレームドロップ率が高い場合
    if (parseFloat(summary.jankyPercentage) > 5) {
      recommendations.push(
        `フレームドロップ率が${summary.jankyPercentage}%と高めです。以下の改善を検討してください。`
      );
    }

    // Buildボトルネック
    if (summary.bottlenecks.build > 0) {
      recommendations.push(
        `Widget再構築による遅延が${summary.bottlenecks.build}フレームで検出されました。` +
        `\n- const constructorの活用\n- RepaintBoundaryの配置\n- メモ化（useMemoized）の検討`
      );
    }

    // Layoutボトルネック
    if (summary.bottlenecks.layout > 0) {
      recommendations.push(
        `Layout計算による遅延が${summary.bottlenecks.layout}フレームで検出されました。` +
        `\n- Column/Rowの深いネストを避ける\n- IntrinsicHeight/Widthの使用を最小化\n- LayoutBuilderの使用を減らす`
      );
    }

    // Paintボトルネック
    if (summary.bottlenecks.paint > 0) {
      recommendations.push(
        `Paint処理による遅延が${summary.bottlenecks.paint}フレームで検出されました。` +
        `\n- 複雑なClipPathを避ける\n- 不要な透明度処理を削減\n- CustomPainterの最適化`
      );
    }

    // Rasterボトルネック
    if (summary.bottlenecks.raster > 0) {
      recommendations.push(
        `GPU Rasterize処理による遅延が${summary.bottlenecks.raster}フレームで検出されました。` +
        `\n- saveLayerを引き起こすWidgetの削減\n- 複数のBoxShadowを画像アセットに置き換え\n- RepaintBoundaryで再描画範囲を限定`
      );
    }

    // 平均FPSが低い場合
    if (parseFloat(summary.avgFps) < 55) {
      recommendations.push(
        `平均FPSが${summary.avgFps}と目標の60fpsを下回っています。全体的なパフォーマンス改善が必要です。`
      );
    }

    // 改善提案がない場合
    if (recommendations.length === 0) {
      recommendations.push(
        `パフォーマンスは良好です。平均FPS: ${summary.avgFps}、フレームドロップ率: ${summary.jankyPercentage}%`
      );
    }

    return recommendations;
  }

  /**
   * 最も重いフレームを特定
   */
  static findHeaviestFrames(frames: FrameMetrics[], count: number = 5): FrameMetrics[] {
    return frames
      .sort((a, b) => b.totalDuration - a.totalDuration)
      .slice(0, count);
  }
}
