#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListResourcesRequestSchema,
  ListToolsRequestSchema,
  ReadResourceRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { VMServiceConnector } from './vm-service.js';
import { MetricsAnalyzer } from './metrics-analyzer.js';
import type { PerformanceAnalysis } from './types.js';

/**
 * Flutter Performance MCP Server
 * FlutterアプリのパフォーマンスをVM Service経由で分析するMCPサーバー
 */
class FlutterPerformanceMCPServer {
  private server: Server;
  private vmConnector: VMServiceConnector | null = null;
  private lastAnalysis: PerformanceAnalysis | null = null;
  private vmServiceUri: string;

  constructor() {
    // VM Service URIをコマンドライン引数から取得（デフォルト: http://localhost:8181）
    const args = process.argv.slice(2);
    const uriIndex = args.indexOf('--vm-service-uri');
    this.vmServiceUri = uriIndex !== -1 && args[uriIndex + 1]
      ? args[uriIndex + 1]
      : 'http://localhost:8181';

    this.server = new Server(
      {
        name: 'flutter-performance-mcp',
        version: '1.0.0',
      },
      {
        capabilities: {
          resources: {},
          tools: {},
        },
      }
    );

    this.setupHandlers();

    // エラーハンドリング
    this.server.onerror = (error) => {
      console.error('[MCP Server] Error:', error);
    };

    process.on('SIGINT', async () => {
      await this.cleanup();
      process.exit(0);
    });
  }

  /**
   * MCPハンドラーをセットアップ
   */
  private setupHandlers(): void {
    // リソース一覧
    this.server.setRequestHandler(ListResourcesRequestSchema, async () => {
      return {
        resources: [
          {
            uri: 'flutter://performance/timeline',
            name: 'Flutter Performance Timeline',
            description: 'フレームごとの詳細パフォーマンスメトリクス（JSON形式）',
            mimeType: 'application/json',
          },
          {
            uri: 'flutter://performance/summary',
            name: 'Performance Summary Report',
            description: 'パフォーマンスサマリーと改善提案（Markdown形式）',
            mimeType: 'text/markdown',
          },
        ],
      };
    });

    // リソース読み取り
    this.server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
      const { uri } = request.params;

      if (!this.lastAnalysis) {
        throw new Error(
          'パフォーマンスデータがありません。先に start_performance_recording ツールを実行してください。'
        );
      }

      if (uri === 'flutter://performance/timeline') {
        return {
          contents: [
            {
              uri,
              mimeType: 'application/json',
              text: JSON.stringify(
                {
                  summary: this.lastAnalysis.summary,
                  frames: this.lastAnalysis.frames.slice(0, 100), // 最初の100フレーム
                  heaviestFrames: MetricsAnalyzer.findHeaviestFrames(this.lastAnalysis.frames, 10),
                },
                null,
                2
              ),
            },
          ],
        };
      }

      if (uri === 'flutter://performance/summary') {
        const summary = this.lastAnalysis.summary;
        const markdown = this.generateMarkdownReport(this.lastAnalysis);

        return {
          contents: [
            {
              uri,
              mimeType: 'text/markdown',
              text: markdown,
            },
          ],
        };
      }

      throw new Error(`Unknown resource URI: ${uri}`);
    });

    // ツール一覧
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: [
          {
            name: 'start_performance_recording',
            description:
              'Flutterアプリのパフォーマンス記録を開始します。指定時間（デフォルト10秒）のタイムラインデータを収集し、分析結果を取得します。',
            inputSchema: {
              type: 'object',
              properties: {
                durationSeconds: {
                  type: 'number',
                  description: '記録時間（秒）。デフォルト: 10秒',
                  default: 10,
                },
              },
            },
          },
          {
            name: 'get_performance_analysis',
            description:
              '最後に記録したパフォーマンスデータの分析結果を取得します。フレームドロップの原因と改善提案が含まれます。',
            inputSchema: {
              type: 'object',
              properties: {},
            },
          },
        ],
      };
    });

    // ツール実行
    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      if (name === 'start_performance_recording') {
        const durationSeconds = (args?.durationSeconds as number) || 10;

        try {
          // VM Serviceに接続
          if (!this.vmConnector) {
            this.vmConnector = new VMServiceConnector({ uri: this.vmServiceUri });
            await this.vmConnector.connect();
          }

          // タイムライン記録
          const timelineData = await this.vmConnector.recordTimeline(durationSeconds);

          // 分析
          this.lastAnalysis = MetricsAnalyzer.analyzeTimeline(timelineData);

          const summary = this.lastAnalysis.summary;

          return {
            content: [
              {
                type: 'text',
                text: `パフォーマンス記録完了（${durationSeconds}秒間）\n\n` +
                  `📊 基本メトリクス:\n` +
                  `- 総フレーム数: ${summary.totalFrames}\n` +
                  `- フレームドロップ: ${summary.jankyFrames}フレーム (${summary.jankyPercentage}%)\n` +
                  `- 平均FPS: ${summary.avgFps}\n\n` +
                  `詳細は flutter://performance/summary リソースで確認できます。`,
              },
            ],
          };
        } catch (error) {
          return {
            content: [
              {
                type: 'text',
                text: `エラーが発生しました: ${error instanceof Error ? error.message : String(error)}\n\n` +
                  `VM Service URI: ${this.vmServiceUri}\n` +
                  `Flutterアプリが起動していて、--observatory-port オプションが指定されているか確認してください。`,
              },
            ],
            isError: true,
          };
        }
      }

      if (name === 'get_performance_analysis') {
        if (!this.lastAnalysis) {
          return {
            content: [
              {
                type: 'text',
                text: 'パフォーマンスデータがありません。先に start_performance_recording を実行してください。',
              },
            ],
            isError: true,
          };
        }

        const markdown = this.generateMarkdownReport(this.lastAnalysis);

        return {
          content: [
            {
              type: 'text',
              text: markdown,
            },
          ],
        };
      }

      throw new Error(`Unknown tool: ${name}`);
    });
  }

  /**
   * Markdown形式のレポートを生成
   */
  private generateMarkdownReport(analysis: PerformanceAnalysis): string {
    const { summary, recommendations } = analysis;

    let markdown = `# Flutter Performance Analysis Report\n\n`;
    markdown += `## 📊 基本メトリクス\n\n`;
    markdown += `- **総フレーム数**: ${summary.totalFrames}\n`;
    markdown += `- **フレームドロップ**: ${summary.jankyFrames}フレーム (${summary.jankyPercentage}%)\n`;
    markdown += `- **平均FPS**: ${summary.avgFps} fps\n`;
    markdown += `- **記録時間**: ${summary.recordingDuration}秒\n\n`;

    markdown += `### フェーズ別平均処理時間\n\n`;
    markdown += `| フェーズ | 平均時間 |\n`;
    markdown += `|---------|----------|\n`;
    markdown += `| Build   | ${summary.avgBuildTime} ms |\n`;
    markdown += `| Layout  | ${summary.avgLayoutTime} ms |\n`;
    markdown += `| Paint   | ${summary.avgPaintTime} ms |\n`;
    markdown += `| Raster  | ${summary.avgRasterTime} ms |\n\n`;

    if (summary.bottlenecks.build + summary.bottlenecks.layout + summary.bottlenecks.paint + summary.bottlenecks.raster > 0) {
      markdown += `## ⚠️ ボトルネック検出結果\n\n`;

      if (summary.bottlenecks.build > 0) {
        markdown += `- **Build**: ${summary.bottlenecks.build}フレーム\n`;
      }
      if (summary.bottlenecks.layout > 0) {
        markdown += `- **Layout**: ${summary.bottlenecks.layout}フレーム\n`;
      }
      if (summary.bottlenecks.paint > 0) {
        markdown += `- **Paint**: ${summary.bottlenecks.paint}フレーム\n`;
      }
      if (summary.bottlenecks.raster > 0) {
        markdown += `- **Raster**: ${summary.bottlenecks.raster}フレーム\n`;
      }

      markdown += `\n`;
    }

    markdown += `## 💡 改善提案\n\n`;
    for (const recommendation of recommendations) {
      markdown += `${recommendation}\n\n`;
    }

    // 最も重いフレームを表示
    const heaviestFrames = MetricsAnalyzer.findHeaviestFrames(analysis.frames, 5);
    if (heaviestFrames.length > 0) {
      markdown += `## 🔍 最も重い5フレーム\n\n`;
      markdown += `| フレーム番号 | 合計時間 | Build | Layout | Paint | Raster | ボトルネック |\n`;
      markdown += `|------------|---------|-------|--------|-------|--------|-------------|\n`;

      for (const frame of heaviestFrames) {
        markdown += `| #${frame.frameNumber} | ${frame.totalDuration.toFixed(2)}ms | ${frame.buildDuration.toFixed(2)}ms | ${frame.layoutDuration.toFixed(2)}ms | ${frame.paintDuration.toFixed(2)}ms | ${frame.rasterDuration.toFixed(2)}ms | ${frame.bottleneck || '-'} |\n`;
      }
    }

    return markdown;
  }

  /**
   * サーバーを起動
   */
  async run(): Promise<void> {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);

    console.error('[MCP Server] Flutter Performance MCP Server running on stdio');
    console.error(`[MCP Server] VM Service URI: ${this.vmServiceUri}`);
    console.error('[MCP Server] Use --vm-service-uri to specify a different URI');
  }

  /**
   * クリーンアップ
   */
  private async cleanup(): Promise<void> {
    if (this.vmConnector) {
      this.vmConnector.disconnect();
    }
    await this.server.close();
  }
}

// サーバーを起動
const server = new FlutterPerformanceMCPServer();
server.run().catch((error) => {
  console.error('[MCP Server] Fatal error:', error);
  process.exit(1);
});
