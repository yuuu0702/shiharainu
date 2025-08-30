# CLAUDE.md

このファイルはClaude Code (claude.ai/code)がこのリポジトリで作業する際のガイダンスを提供します。

## YOU MUST: 
- 回答は日本語で行ってください

## よく使用する開発コマンド

### パッケージ管理
- `flutter pub get` - 依存関係をインストール
- `flutter pub upgrade` - 依存関係を更新
- `flutter pub outdated` - 古くなったパッケージをチェック

### 開発
- `flutter run` - 接続されたデバイス/エミュレーターでアプリを実行
- `flutter run -d chrome` - Chrome（Web）で実行
- `flutter run --hot` - ホットリロードを有効にして実行
- `flutter run --release` - リリースモードで実行

### コード生成
- `dart run build_runner build` - コード生成（freezed、json_serializable）
- `dart run build_runner build --delete-conflicting-outputs` - 強制的に再生成

### テストと解析
- `flutter test` - ユニットテストを実行
- `flutter analyze` - 静的コード解析
- `dart format .` - コードをフォーマット

### ビルド
- `flutter build apk` - Android APKをビルド
- `flutter build ios` - iOSアプリをビルド
- `flutter build web` - Webアプリをビルド

## プロジェクトアーキテクチャ

### 概要
Shiharainu（しはらいぬ）は、以下の技術で構築されたFlutterイベント支払い管理アプリケーションです：
- **状態管理**: Riverpod (hooks_riverpod + flutter_hooks)
- **ナビゲーション**: GoRouterによる宣言的ルーティング
- **UIフレームワーク**: カスタムFigmaベースのデザインシステムを使用したMaterial Design 3
- **コード生成**: データモデルとJSONシリアライゼーション用のFreezed

### 主要な依存関係
- `hooks_riverpod` + `flutter_hooks` - 状態管理とライフサイクル
- `go_router` - ナビゲーションとルーティング
- `freezed` + `json_annotation` - データモデリングとシリアライゼーション
- `build_runner` - コード生成
- `intl` - 国際化
- `uuid` - 一意識別子生成

### ディレクトリ構造
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

### デザインシステム
アプリはFigmaガイドラインに基づくカスタムデザインシステムを使用：
- **プライマリカラー**: #EA3800（オレンジレッド）
- **デストラクティブカラー**: #d4183d  
- **ミューテッドカラー**: #ececf0（背景）、#717182（テキスト）
- **入力背景**: #f3f3f5
- **日本語フォント**: NotoSansJP
- **ボーダー半径**: 6px（ボタン/入力）、8px（カード）
- **対応**: ライト・ダークテーマとシステム設定自動検出

### ナビゲーション構造
`lib/app.dart`でのGoRouter設定：
- `/login` - LoginPage（初期ルート）
- `/dashboard` - DashboardPage
- `/event-creation` - EventCreationPage

### コンポーネントアーキテクチャ
- すべての共有ウィジェットは`App`プレフィックス付き（AppButton、AppCardなど）
- ウィジェットは`lib/shared/widgets/widgets.dart`バレルファイルからエクスポート
- コンポーネントはカスタムスタイリングでMaterial Design 3パターンに従う
- テーマ設定は`AppTheme`ですべてのデザイントークンを一元化

### 状態管理パターン
- 状態管理にRiverpodプロバイダーを使用
- ウィジェットライフサイクル管理にFlutter Hooks
- `main.dart`でProviderScopeがアプリ全体をラップ

### コード生成
以下を追加する際は`dart run build_runner build`を実行：
- 新しいFreezedデータモデル
- JSONシリアライゼーションアノテーション
- その他のコード生成アノテーション

## コーディング規約と命名規則

### ファイル・ディレクトリ命名規則
- **ファイル名**: スネークケース（例: `login_page.dart`, `app_button.dart`）
- **クラス名**: パスカルケース（例: `LoginPage`, `AppButton`, `EventCreationPage`）
- **変数・メソッド名**: キャメルケース（例: `_emailController`, `_handleLogin`）
- **定数**: スクリーミングスネークケース（例: `PRIMARY_COLOR`）ただし、クラス内定数はキャメルケース（例: `primaryColor`）

### ウィジェット設計パターン

#### 共有ウィジェット
- すべての再利用可能ウィジェットには `App` プレフィックスを付ける
- バリアント機能は enum で実装（例: `AppButtonVariant`, `AppButtonSize`）
- 名前付きコンストラクタで一般的なバリアントを提供（例: `AppButton.primary()`, `AppButton.outline()`）
- アイコン専用コンストラクタは `.icon()` を使用

#### ページウィジェット
- ページクラス名は `Page` サフィックス（例: `LoginPage`, `DashboardPage`）
- StatefulWidget を使用し、State クラスは `_PageNameState` パターン
- コントローラは `_controllerName` パターンで命名（例: `_emailController`）
- 状態変数は `_` プレフィックス付きキャメルケース（例: `_isLoading`）

### コンポーネント実装規約

#### 必須実装パターン
- **dispose()**: コントローラを使用する場合は必ず実装
- **mounted チェック**: 非同期処理後の setState 前に必ず確認
- **const コンストラクタ**: 可能な限り使用
- **super.key**: すべてのウィジェットコンストラクタで指定

#### プロパティ定義順序
```dart
class AppWidget extends StatelessWidget {
  // 1. 必須プロパティ
  final String text;
  
  // 2. オプショナルプロパティ（データ）
  final String? placeholder;
  final Widget? icon;
  
  // 3. オプショナルプロパティ（動作）
  final VoidCallback? onPressed;
  final ValueChanged<String>? onChanged;
  
  // 4. 設定・フラグ類
  final bool isRequired;
  final bool isLoading;
  
  // 5. スタイル・サイズ
  final AppButtonSize size;
  final AppButtonVariant variant;
}
```

#### エラーハンドリング
- `assert()` を使用してプロパティの妥当性をチェック
- 必須フィールドには `isRequired` フラグと視覚的な「*」マークを表示
- エラー状態は `errorText` プロパティで表示

### アーキテクチャ規約

#### レイヤー構造
```
lib/
├── main.dart              # アプリケーションエントリーポイント
├── app.dart               # アプリ設定とルーティング
├── pages/                 # 画面レベルコンポーネント
├── shared/
│   ├── constants/         # 定数・テーマ
│   ├── widgets/          # 共有UIコンポーネント
│   ├── models/           # データモデル（将来追加）
│   ├── services/         # ビジネスロジック（将来追加）
│   └── providers/        # Riverpod プロバイダー（将来追加）
```

#### インポート順序
```dart
// 1. Dart標準ライブラリ
import 'dart:async';

// 2. Flutter SDK
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. サードパーティライブラリ
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 4. 自プロジェクト（相対パス順）
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
```

#### 状態管理パターン
- **ローカル状態**: StatefulWidget + setState
- **グローバル状態**: Riverpod Provider（将来実装）
- **フォーム状態**: TextEditingController + dispose パターン
- **非同期処理**: async/await + mounted チェック

#### テーマ・スタイル管理
- すべての色は `AppTheme` クラスで定義
- マジックナンバーは定数化（例: パディング、ボーダー半径）
- フォントサイズとウェイトは統一ルールに従う
- 日本語対応のため NotoSansJP フォント使用

### コメント・ドキュメント規約
- 日本語コメントを使用
- TODO コメントには実装予定を記載（例: `// TODO: パスワードリセット機能`）
- 複雑なビジネスロジックには説明コメントを追加
- デバッグ用コードには明確にコメント記載（例: `// デバッグ用ログインボタン`）

## 開発品質基準（必須遵守事項）

### コード品質基準

#### 命名規則の統一性
- **ソースコードが命名規則通りに統一されている事**
  - ファイル名、クラス名、変数名、定数名等の命名が意味がわかるもので統一されているか
  - キャメルケース、スネークケースの統一はされているか
  - 略語は避け、意図が明確に伝わる名前を使用

#### 静的解析クリーン
- **静的解析で指摘事項がない事**
  - 特別な理由がなければ`flutter analyze`の指摘事項は全て解消すること
  - `analysis_options.yaml`のルールに準拠
  - 未使用インポート、未使用変数、デッドコードは削除

#### ファイルサイズ管理
- **1つのファイルで400行を超える場合別ファイルに移動する**
  - 機能ごとにファイルを分割
  - 共通化できる処理はユーティリティ関数として抽出
  - 複数の責務が混在していないかレビュー

### パフォーマンス品質

#### リスト表示の最適化
- **リスト表示で遅延処理が正しく実装されている事**
  - ListView.builder を使用してメモリ効率を確保
  - 分からない場合は、スクロールするたびにリスト内の要素のインスタンスが生成と破棄を繰り返していることをログレベルで確認する
  - 大量データの場合は仮想スクロールやページングを検討

### エラーハンドリング・例外処理

#### 堅牢性の確保
- **例外ケースでも耐えれる実装ができている事**
  - **nullableデータの適切な処理**
    - null強制参照エラーが発生していないか
    - null安全を活用し、`??`, `?.`, `!`の適切な使い分け
  - **UI破綻の防止**
    - 文字数が多い場合に画面が崩れない事（Overflow回避）
    - `Flexible`, `Expanded`, `Wrap`の適切な使用
  - **Exception の適切な処理**
    - try-catch でキャッチし、ユーザーに分かりやすいメッセージを表示
    - ログ出力とクラッシュ防止の両立

#### 非同期・ネットワーク処理
- **非同期処理のローディング中や機内モード中のエラーハンドリングの実装ができている事**
  - ローディング状態の適切な表示（`isLoading`フラグ活用）
  - ネットワーク接続エラーの処理
  - 端末の機内モードを使い、ネットワーク接続できない状態で動作確認をする事
  - タイムアウト設定とリトライ機能の実装

### コードベース整合性

#### コンフリクト管理
- **コンフリクトを解消している事**
  - 解消後、再度動作確認している事
  - マージ後の回帰テスト実施

#### 設計準拠
- **アプリの設計通りに実装されている事**
  - Figmaデザインとの整合性確保
  - アーキテクチャパターンの遵守
  - 既存コンポーネントとの一貫性維持

### アーキテクチャ品質

#### ベストプラクティス遵守
- **フレームワークや外部パッケージのアンチパターンを踏んでいない事**
  - 公式ドキュメントやパッケージのドキュメントを確認する
  - Flutter/Dart のイディオムに従った実装
  - パフォーマンス上問題のある実装パターンを回避

#### コード重複排除
- **重複する実装はしていない事**
  - 共通ロジックの適切な抽出
  - ユーティリティ関数・カスタムウィジェットの活用
  - DRY原則の遵守

#### 適切なカプセル化
- **過剰なカプセル化をしてメンテナンスしづらい実装にしていない事**
  - 保守性・可読性が失われていない事
  - 必要以上の抽象化を避ける
  - シンプルで理解しやすい構造を保つ

### 将来性・保守性

#### 拡張可能設計
- **ビジネスロジックやカプセル化ロジックに対して、機能拡張されても耐えれるようなIF設計がされている事**
  - インターフェース設計の明確化
  - 依存関係の適切な管理
  - SOLID原則の考慮

#### チーム開発対応
- **第3者が触っても崩れない設計になっている事**
  - 途中から参画したエンジニアが誤った実装をすることを防ぐ
  - 型安全性の活用
  - 明確なAPIとコントラクト定義
  - 適切なドキュメントとコメント

### 品質チェックリスト（実装完了時の確認項目）
- [ ] 命名規則が統一されているか
- [ ] `flutter analyze` で警告・エラーが0件か
- [ ] ファイルサイズが400行以下か
- [ ] リスト表示のパフォーマンスが適切か
- [ ] null安全に対応しているか  
- [ ] UI破綻（Overflow等）が発生しないか
- [ ] Exception処理が適切に実装されているか
- [ ] ネットワークエラー時の動作確認済みか
- [ ] ローディング状態の表示が適切か
- [ ] コード重複が排除されているか
- [ ] 設計・既存パターンとの整合性があるか

## Git ワークフロー・ブランチルール

### ブランチ戦略

#### メインブランチ
- **`main`**: 本番環境デプロイ用ブランチ
  - 常に安定した状態を保つ
  - 直接のコミットは禁止
  - リリース可能な状態のみをマージ

#### 開発ブランチ
- **`develop`**: 開発統合ブランチ（存在する場合）
  - 機能ブランチからのマージ先
  - 次回リリース用の機能統合

#### フィーチャーブランチ
- **`feature/[機能名]`**: 新機能開発用ブランチ
- **`fix/[修正内容]`**: バグ修正用ブランチ
- **`refactor/[対象]`**: リファクタリング用ブランチ
- **`docs/[対象]`**: ドキュメント更新用ブランチ
- **`style/[対象]`**: UI/スタイル調整用ブランチ

### ブランチ命名規則

#### 機能開発ブランチ
```
feature/login-page-implementation
feature/event-creation-form
feature/payment-calculation-logic
```

#### バグ修正ブランチ
```
fix/login-validation-error
fix/null-reference-dashboard
fix/overflow-event-list
```

#### その他のブランチ
```
refactor/app-theme-structure
docs/claude-md-update
style/figma-design-alignment
```

### ブランチ作成・運用ルール

#### 新機能・修正開発時の流れ
1. **ブランチ作成**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/新機能名
   ```

2. **開発作業**
   - 小さな単位で定期的にコミット
   - コミットメッセージ規約に従う
   - 開発中も定期的に`main`から最新をマージ

3. **プルリクエスト作成前**
   - `flutter analyze` でエラー0件確認
   - 品質チェックリスト完了
   - `main`ブランチとのコンフリクト解消

4. **マージ後**
   - ローカルブランチ削除
   - 動作確認実施

### コミットメッセージ規約

#### コミットメッセージ形式
```
<type>: <subject>

<body>（オプション）

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

#### Type（種類）の定義
- **`feat`**: 新機能追加
- **`fix`**: バグ修正  
- **`refactor`**: リファクタリング（機能変更なし）
- **`style`**: UI/デザイン調整
- **`docs`**: ドキュメント更新
- **`test`**: テスト追加・修正
- **`chore`**: ビルド・設定変更

#### コミットメッセージ例
```
feat: ログインページのバリデーション機能を実装

- メールアドレス形式チェック機能追加
- パスワード必須入力チェック追加
- エラーメッセージ表示機能実装

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

```
fix: ダッシュボードでのnull参照エラーを修正

イベント一覧が空の場合のnull参照エラーを解消
空リスト表示とプレースホルダーを追加

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

```
style: Figmaデザインガイドラインに基づくボタンスタイル調整

- プライマリボタンの角丸を6pxに統一
- ホバーエフェクトの色調整
- フォントウェイトを500に統一

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### プルリクエスト規約

#### PRタイトル形式
```
[Type] 機能概要
```

#### PR説明テンプレート
```markdown
## 概要
この変更の目的と概要を記述

## 変更内容
- [ ] 新機能A の実装
- [ ] バグB の修正
- [ ] リファクタリングC の実施

## テスト項目
- [ ] 新機能の動作確認
- [ ] 既存機能の回帰テスト
- [ ] エラーケースの確認
- [ ] 機内モードでの動作確認

## 関連Issue
#1234

## スクリーンショット（UI変更がある場合）
Before/After の画像を添付

🤖 Generated with [Claude Code](https://claude.ai/code)
```

### 緊急時・ホットフィックス対応

#### ホットフィックスブランチ
```
hotfix/critical-login-bug
hotfix/payment-calculation-error
```

#### 緊急対応フロー
1. `main`ブランチから`hotfix/`ブランチ作成
2. 修正実装・テスト
3. `main`と`develop`（存在する場合）両方にマージ
4. 即座にデプロイ・動作確認

### 禁止事項・注意点
- **`main`ブランチへの直接コミット禁止**
- **強制プッシュ（force push）の禁止**
- **WIP（Work in Progress）状態でのPR作成は避ける**
- **大きすぎる変更を1つのPRにまとめない**
- **未完了・未テスト機能のマージ禁止**