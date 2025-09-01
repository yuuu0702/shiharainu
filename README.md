# shiharainu

Flutterで構築されたイベント支払い管理アプリケーション

## プロジェクト概要

Shiharainu（しはらいぬ）は、イベントの支払い管理を効率化するFlutterアプリケーションです。

### 技術スタック
- **フレームワーク**: Flutter/Dart
- **状態管理**: Riverpod (hooks_riverpod + flutter_hooks)
- **ナビゲーション**: GoRouter
- **UIフレームワーク**: カスタムFigmaベースのデザインシステム + Material Design 3
- **コード生成**: Freezed + JSON Serialization

## セットアップ

### 必要な環境
- Flutter SDK (最新版)
- Dart SDK
- IDE (VS Code推奨)

### インストール手順
```bash
# リポジトリクローン
git clone https://github.com/yuuu0702/shiharainu.git
cd shiharainu

# 依存関係インストール
flutter pub get

# コード生成実行
dart run build_runner build

# アプリ実行
flutter run
```

## 開発コマンド

### パッケージ管理
```bash
flutter pub get          # 依存関係をインストール
flutter pub upgrade      # 依存関係を更新
flutter pub outdated     # 古くなったパッケージをチェック
```

### 開発・実行
```bash
flutter run              # 接続されたデバイス/エミュレーターで実行
flutter run -d chrome    # Chrome（Web）で実行
flutter run --hot        # ホットリロードを有効にして実行
flutter run --release    # リリースモードで実行
```

### コード生成
```bash
dart run build_runner build                            # コード生成（freezed、json_serializable）
dart run build_runner build --delete-conflicting-outputs # 強制的に再生成
```

### テストと解析
```bash
flutter test             # ユニットテストを実行
flutter analyze          # 静的コード解析
dart format .            # コードをフォーマット
```

### ビルド
```bash
flutter build apk        # Android APKをビルド
flutter build ios        # iOSアプリをビルド
flutter build web        # Webアプリをビルド
```

## プロジェクト構造

```
lib/
├── main.dart                 # ProviderScopeを含むアプリエントリーポイント
├── app.dart                  # ルーティング設定を持つメインアプリウィジェット
├── pages/                    # ページレベルのウィジェット
│   ├── login_page.dart
│   ├── dashboard_page.dart
│   └── event_creation_page.dart
└── shared/
    ├── constants/
    │   └── app_theme.dart    # Figmaベースのデザインシステムテーマ
    └── widgets/              # 再利用可能なUIコンポーネント
        ├── widgets.dart      # バレルエクスポートファイル
        ├── app_badge.dart
        ├── app_bottom_navigation.dart
        ├── app_button.dart
        ├── app_card.dart
        ├── app_input.dart
        ├── app_segmented_control.dart
        └── app_tabs.dart
```

## Claude Code 使い方ガイド

### 🤖 **Claude Code とは**
このプロジェクトではAnthropic公式のCLIツール「Claude Code」を開発支援に使用しています。専門的なagentsと豊富なツールを活用して効率的な開発を行えます。

### 👥 **利用可能なAgents**

#### **🎭 ui-ux-designer**
- **機能**: インターフェースデザイン、ワイヤーフレーム、デザインシステム作成
- **自動起動**: デザインシステム、ユーザーフロー、インターフェース最適化作業時

#### **📱 flutter-expert**
- **機能**: Flutter/Dart開発全般のエキスパート
- **対応**: ウィジェット開発、状態管理、アニメーション、テスト、パフォーマンス最適化
- **自動起動**: Flutterアーキテクチャ、UI実装、クロスプラットフォーム機能開発時

#### **🏗️ architect-reviewer**
- **機能**: コード変更のアーキテクチャ整合性とパターンをレビュー
- **自動起動**: 構造的変更、新サービス作成、API修正後

#### **📊 business-analyst**
- **機能**: メトリクス分析、レポート作成、KPI追跡
- **自動起動**: ビジネスメトリクスや分析関連作業時

#### **🧠 prompt-engineer**
- **機能**: LLMおよびAIシステム向けプロンプトの最適化
- **用途**: AI機能構築、システムプロンプト作成

#### **🔍 general-purpose**
- **機能**: 複雑な質問の調査、コード検索、マルチステップタスクの実行
- **用途**: 複合的なタスクの自動化、広範囲な検索作業

### 🛠️ **主要機能**

#### **ファイル操作**
- **Read**: ファイル内容の読み込み
- **Edit**: 既存コードの置換・修正
- **MultiEdit**: 1つのファイルで複数の編集を一括実行
- **Write**: 新しいファイルの作成

#### **コード検索・分析**
- **Glob**: `"**/*.dart"`のようなパターンでファイル検索
- **Grep**: 正規表現を使用したコード内容検索
- **Bash**: シェルコマンドの実行

#### **タスク管理**
- **TodoWrite**: 複雑なタスクの計画・進捗管理
- **Task**: 専門agentを起動して特定タスクを実行

### 💡 **効果的な使い方**

#### **1. 計画的アプローチ**
```bash
# 複雑なタスクはTodoWriteで計画
TodoWrite: 新機能実装の段階的計画作成

# 段階的な実装
1. 要件整理 → 2. 設計 → 3. 実装 → 4. テスト → 5. レビュー
```

#### **2. 品質管理**
```bash
# 実装後の必須確認
flutter analyze          # 静的解析エラーゼロ確認
flutter test            # テスト実行
dart format .           # コードフォーマット
```

#### **3. Agent活用戦略**
- **自動起動Agents**: 該当作業時に自動的に最適なagentが起動
- **手動起動**: `Task`ツールで特定agentを指定して実行
- **複合タスク**: general-purposeで複数ステップのタスクを統合処理

### 🚨 **重要な注意事項**

#### **セキュリティ**
- 秘密鍵やパスワードは絶対にコミットしない
- ログ出力に機密情報を含めない
- 防御的セキュリティタスクのみ実行

#### **開発品質**
- 静的解析エラーゼロを維持
- 例外処理とnull安全を徹底
- レスポンシブデザインとアクセシビリティに配慮

### 📋 **設定ファイル**
- **CLAUDE.md**: プロジェクト固有の開発指示とガイドライン
- **analysis_options.yaml**: 静的解析ルール設定
- **pubspec.yaml**: 依存関係とプロジェクト設定

## コントリビューション

プロジェクトへの貢献をお待ちしています。

### ブランチ戦略
- `main`: 本番環境用
- `feature/[機能名]`: 新機能開発
- `fix/[修正内容]`: バグ修正

### 開発フロー
1. 機能ブランチ作成
2. 実装・テスト
3. Claude Codeでの品質確認
4. プルリクエスト作成

## ライセンス

このプロジェクトは[MIT License](LICENSE)の下で公開されています。
