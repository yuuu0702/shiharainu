# Flutter Performance MCP Server

FlutterアプリのパフォーマンスをAIに自動分析させるMCPサーバー。

## 概要

このMCPサーバーは、Flutter VM Serviceに接続してパフォーマンスデータを収集し、Claudeが分析できる形式で提供します。

### 主な機能

- **自動パフォーマンス記録**: VM Service経由でタイムラインデータを自動収集
- **フレームメトリクス分析**: フレームごとのBuild/Layout/Paint/Raster時間を計算
- **ボトルネック検出**: パフォーマンス低下の原因を自動特定
- **改善提案生成**: 具体的なコード改善案を提示

## セットアップ

### 1. 依存関係のインストール

```bash
cd tools/flutter-performance-mcp
npm install
```

### 2. ビルド

```bash
npm run build
```

### 3. VS Code設定

`.claude/settings.local.json` に以下を追加:

```json
{
  "mcpServers": {
    "flutter-performance": {
      "command": "node",
      "args": [
        "c:/Users/yudai/Repositories/shiharainu/tools/flutter-performance-mcp/dist/index.js",
        "--vm-service-uri",
        "http://localhost:8181"
      ]
    }
  }
}
```

## 使い方

### 1. Flutterアプリを起動

```bash
flutter run --observatory-port=8181
```

### 2. VS CodeでClaude Codeを開く

### 3. パフォーマンス分析を依頼

```
このアプリのパフォーマンスを分析して
```

Claudeが自動的に以下を実行します：
1. VM Serviceに接続
2. 10秒間のタイムラインデータを収集
3. フレームメトリクスを計算
4. ボトルネックを特定
5. 改善提案を生成

### 利用可能なツール

#### `start_performance_recording`
パフォーマンス記録を開始します。

**パラメータ**:
- `durationSeconds` (オプション): 記録時間（秒）。デフォルト: 10秒

**使用例**:
```
20秒間パフォーマンスを記録して
```

#### `get_performance_analysis`
最後に記録したパフォーマンスデータの分析結果を取得します。

**使用例**:
```
パフォーマンス分析結果を詳しく教えて
```

### 利用可能なリソース

#### `flutter://performance/timeline`
フレームごとの詳細メトリクス（JSON形式）

#### `flutter://performance/summary`
パフォーマンスサマリーと改善提案（Markdown形式）

## 出力例

```markdown
# Flutter Performance Analysis Report

## 📊 基本メトリクス

- **総フレーム数**: 600
- **フレームドロップ**: 45フレーム (7.5%)
- **平均FPS**: 55.3 fps

## ⚠️ ボトルネック検出結果

- **Build**: 23フレーム
- **Layout**: 12フレーム
- **Raster**: 10フレーム

## 💡 改善提案

Widget再構築による遅延が23フレームで検出されました。
- const constructorの活用
- RepaintBoundaryの配置
- メモ化（useMemoized）の検討
```

## 開発

### デバッグモード実行

```bash
npm run dev
```

### ウォッチモード（自動ビルド）

```bash
npm run watch
```

## トラブルシューティング

### 「VM Service is not connected」エラー

**原因**: Flutterアプリが起動していないか、ポートが異なる

**解決策**:
```bash
# --observatory-portオプション付きで起動
flutter run --observatory-port=8181
```

### 「Connection timeout」エラー

**原因**: VM Service URIが間違っている

**解決策**:
`.claude/settings.local.json` の `--vm-service-uri` を確認

```json
{
  "args": [
    "...",
    "--vm-service-uri",
    "http://localhost:8181"  // ← ポート番号を確認
  ]
}
```

## ライセンス

MIT
