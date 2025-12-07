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
├── main.dart                      # ProviderScopeを含むアプリエントリーポイント
├── app.dart                       # ルーティング設定を持つメインアプリウィジェット
├── pages/                         # ページレベルのウィジェット
│   ├── home_page.dart             # ホームページ（メイン: 169行）
│   ├── home/                      # ホームページのセクション分割
│   │   ├── home_data_models.dart
│   │   ├── home_welcome_section.dart
│   │   ├── home_quick_actions.dart
│   │   ├── home_notifications_section.dart
│   │   ├── home_events_section.dart
│   │   └── home_activity_summary.dart
│   ├── event_detail_page.dart     # イベント詳細ページ（メイン: 135行）
│   ├── event_detail/              # イベント詳細のセクション分割
│   │   ├── event_detail_badges.dart
│   │   ├── event_detail_header.dart
│   │   ├── event_detail_action_cards.dart
│   │   ├── event_detail_info_section.dart
│   │   ├── event_detail_participants_section.dart
│   │   └── after_party_section.dart
│   ├── login_page.dart
│   ├── event_creation_page.dart
│   └── ...
└── shared/
    ├── constants/
    │   ├── app_theme.dart         # Figmaベースのデザインシステムテーマ
    │   └── app_breakpoints.dart   # レスポンシブブレークポイント
    ├── widgets/                   # 再利用可能なUIコンポーネント（23個）
    │   ├── widgets.dart           # バレルエクスポートファイル
    │   ├── app_loading_state.dart # 統一ローディング/エラー表示
    │   ├── app_badge.dart
    │   ├── app_button.dart
    │   ├── app_card.dart
    │   ├── app_input.dart
    │   └── ...
    ├── models/                    # Freezedデータモデル
    │   ├── event_model.dart
    │   ├── participant_model.dart
    │   └── ...
    ├── services/                  # ビジネスロジック
    │   ├── event_service.dart
    │   ├── auth_service.dart
    │   └── ...
    ├── providers/                 # Riverpodプロバイダー
    │   └── after_party_providers.dart
    └── utils/                     # ユーティリティ関数
        └── app_logger.dart
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

#### レスポンシブデザイン対応
**このアプリはWebとモバイルの両方で利用される想定のため、レスポンシブデザインに対応する**

##### 画面サイズ対応方針
- **モバイル**: 360px～414px（主要スマートフォン）
- **タブレット**: 768px～1024px
- **デスクトップ**: 1200px以上

##### ブレークポイント定義
```dart
// lib/shared/constants/breakpoints.dart での定義例
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1200;
}
```

##### レスポンシブ実装パターン
- **LayoutBuilder 活用**: 画面サイズに応じたレイアウト切り替え
- **MediaQuery.of(context).size.width** での条件分岐
- **Expanded, Flexible** での柔軟なレイアウト
- **SingleChildScrollView** での縦スクロール対応
- **GridView.builder** でのグリッドレイアウト（列数調整）

##### レスポンシブウィジェット設計
```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          return desktop;
        } else if (constraints.maxWidth >= AppBreakpoints.tablet) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

##### レスポンシブナビゲーション実装パターン
```dart
// ✅ 推奨: ResponsivePageScaffold使用
return ResponsivePageScaffold(
  title: 'ページタイトル',
  navigationItems: navigationItems,
  currentRoute: '/current',
  actions: [...],
  body: pageContent,
);

// ❌ 非推奨: 直接Scaffoldでボトムナビ固定
return Scaffold(
  bottomNavigationBar: AppBottomNavigation(...), // デスクトップでUX劣化
);
```

##### ナビゲーションUX設計指針
- **操作性**: デスクトップはマウス、モバイルはタッチに最適化
- **視線の流れ**: デスクトップは左サイド、モバイルは下部が自然
- **画面効率**: デスクトップの縦空間有効活用、モバイルの横幅制約考慮
- **一貫性**: 同一デバイスクラス内でナビゲーション方式を統一

##### レスポンシブ対応指針
- **フォントサイズ**: 画面サイズに応じた調整（14px～18px）
- **パディング・マージン**: 画面幅に応じた調整（16px～32px）
- **ボタンサイズ**: タッチデバイス考慮（最小44px×44px）
- **カードレイアウト**: 画面幅に応じた列数変更
- **ナビゲーション戦略**: 
  - モバイル（～600px）: BottomNavigationBar（親指操作性重視）
  - タブレット（600px～1200px）: BottomNavigationBar または NavigationRail
  - デスクトップ（1200px～）: NavigationRail（垂直サイドナビゲーション）
  - **重要**: デスクトップでBottomNavigationBarは使用禁止（UX劣化）

##### Web対応時の追加考慮事項
- **キーボードナビゲーション**: Tab順序の適切な設定
- **ホバーエフェクト**: マウスオーバー時のインタラクション
- **右クリックメニュー**: 必要に応じて無効化
- **テキスト選択**: 適切な選択可能領域の設定
- **URL対応**: GoRouterでのWeb URL対応
- **SEO対応**: 適切なタイトルとメタデータ設定

##### レスポンシブテスト指針
- **デバイステスト**: 異なる画面サイズでの動作確認
- **Chrome DevTools**: レスポンシブモードでの確認
- **実機テスト**: iOS/Android の実際のデバイス確認
- **Webブラウザテスト**: Chrome, Firefox, Safari での確認
- **画面回転テスト**: 横向き・縦向き切り替え確認

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

### 実装時のコミット戦略（重要）

#### 小刻みコミットの実践
**実装ごとに必ずコミットを作成する**：
- 新しいコンポーネント作成時
- 機能追加・修正完了時
- リファクタリング完了時
- バグ修正完了時

#### コミット単位の例
```bash
# 良い例（適切な粒度）
git commit -m "feat: DashboardFeatureCardsコンポーネントを新規作成"
git commit -m "refactor: dashboard_page.dartから機能カード部分を分離"
git commit -m "feat: レスポンシブデザイン基盤（AppBreakpoints）を実装"
git commit -m "feat: ResponsiveLayoutウィジェット群を追加"
git commit -m "feat: 支払い管理画面の基本機能を実装"

# 悪い例（大きすぎる変更）
git commit -m "feat: レスポンシブ対応と支払い管理画面を一括実装"
```

#### コミットタイミング
1. **単一責務完了時**：1つの機能やコンポーネントが完成した時点
2. **テスト通過後**：`flutter analyze`が通った状態
3. **動作確認後**：実装した機能が期待通り動作することを確認
4. **他機能への影響確認後**：既存機能に悪影響がないことを確認

#### コミットメッセージの品質
- **具体的な変更内容**：何をしたのかが明確
- **影響範囲の明示**：どのファイル・機能に関する変更か
- **理由の説明**：なぜその変更をしたのか（body部分）

```bash
# 推奨されるコミット例
git commit -m "feat: 支払い管理画面にレスポンシブグリッドを適用

- モバイル: 1列表示
- タブレット: 2列表示  
- デスクトップ: 3列表示
- 参加者カードのタッチ操作性を向上

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

#### バックアップとしてのコミット履歴
- **実装の履歴保存**：各段階での動作状態を保持
- **問題発生時の復旧**：特定のコミットに戻ることで安全に修正
- **レビューの容易さ**：小さな変更単位で差分確認が可能
- **チーム協力**：他の開発者が変更内容を理解しやすい

## ページ分割パターン（400行超過時の対応）

### 分割が必要なタイミング
- **ファイルが400行を超えた場合**は必ず分割を検討
- 複数の責務（セクション、機能）が1つのファイルに混在している場合
- メンテナンス性・可読性が低下していると感じた場合

### 分割パターン

#### 1. ページファイル + セクションサブディレクトリ構造
```
lib/pages/
├── example_page.dart              # メインページ（150～200行程度）
└── example/                       # セクション用サブディレクトリ
    ├── example_data_models.dart   # データモデル
    ├── example_header.dart        # ヘッダーセクション
    ├── example_content.dart       # コンテンツセクション
    └── example_footer.dart        # フッターセクション
```

#### 2. メインページの役割
- **ページ全体の構造定義**：Scaffoldやレイアウト構成
- **状態管理**：Riverpodプロバイダーの監視、ローカル状態管理
- **ナビゲーション処理**：画面遷移ロジック
- **セクションの組み立て**：各セクションウィジェットの配置
- **目標行数**：150～200行程度（最大でも300行以内）

```dart
// 良い例: home_page.dart（169行）
class HomePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状態管理とデータ取得
    final profile = ref.watch(userProfileProvider);

    return ResponsivePageScaffold(
      title: 'ホーム',
      body: SingleChildScrollView(
        child: Column(
          children: [
            // セクションウィジェットの組み立て
            HomeWelcomeSection(userName: profile?.name ?? 'ゲスト'),
            const HomeQuickActions(),
            HomeNotificationsSection(notifications: _notifications),
            HomeEventsSection(events: _events),
            const HomeActivitySummary(),
          ],
        ),
      ),
    );
  }
}
```

#### 3. セクションファイルの役割
- **単一責務の原則**：1つのセクションは1つの機能のみ
- **再利用可能な設計**：他のページでも使える可能性を考慮
- **適切なカプセル化**：必要なデータのみをプロパティで受け取る
- **目標行数**：50～150行程度（複雑な場合は200行まで許容）

```dart
// 良い例: home_welcome_section.dart（65行）
class HomeWelcomeSection extends StatelessWidget {
  final String userName;
  final String dogEmoji;

  const HomeWelcomeSection({
    super.key,
    required this.userName,
    required this.dogEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          // セクション固有のUI実装
          Text(dogEmoji, style: TextStyle(fontSize: 48)),
          SizedBox(width: 16),
          Text('こんにちは、$userName さん！'),
        ],
      ),
    );
  }
}
```

#### 4. データモデルファイルの役割
- **ページ固有のデータ構造定義**
- **Enumやヘルパークラスの定義**
- **共有モデル（shared/models/）との区別**：ページ固有のみここに配置

```dart
// 良い例: home_data_models.dart（49行）
class EventData {
  final String id;
  final String title;
  final EventRole role;
  final EventStatus status;

  const EventData({...});
}

enum EventRole { organizer, participant }
enum EventStatus { planning, active, completed }
```

### 分割手順（ステップバイステップ）

#### ステップ1: 現状分析
1. `flutter analyze`で警告がないことを確認
2. ファイルの行数確認（400行超過しているか）
3. 責務の洗い出し（セクション、データモデル、ヘルパー関数等）

#### ステップ2: サブディレクトリ作成
```bash
mkdir lib/pages/example
```

#### ステップ3: データモデルの抽出（存在する場合）
- ページ内で定義されているクラスやEnumを抽出
- `example_data_models.dart`として作成

#### ステップ4: セクションウィジェットの抽出
- `_buildHeader()`, `_buildContent()`等のメソッドを独立ウィジェット化
- セクションごとに`example_section_name.dart`ファイル作成
- 各セクションは`StatelessWidget`または`StatefulWidget`として定義

#### ステップ5: メインページの書き換え
- 抽出したセクションをインポート
- `_build*`メソッドをセクションウィジェットに置き換え
- 必要なデータをプロパティとして渡す

#### ステップ6: 動作確認
```bash
flutter analyze     # 静的解析
flutter run         # 動作確認
```

#### ステップ7: コミット
```bash
git add .
git commit -m "refactor: example_page.dartを複数ファイルに分割（XXX行→YYY行）"
```

### 分割時の注意点

#### Do（推奨）
- ✅ **セクション単位で分割**：ヘッダー、コンテンツ、フッター等の意味のある単位
- ✅ **適切なファイル命名**：`{page_name}_{section_name}.dart`パターン
- ✅ **プロパティで依存を明示**：必要なデータを明確にプロパティで受け取る
- ✅ **constコンストラクタ活用**：パフォーマンス向上のため
- ✅ **既存パターンの踏襲**：home_page、event_detail_pageの分割パターンを参考に

#### Don't（非推奨）
- ❌ **過度な細分化**：50行未満のセクションを無理に分割しない
- ❌ **不自然な責務分割**：関連性の高いコードを無理に分離しない
- ❌ **グローバル状態の乱用**：セクション間でグローバル変数を共有しない
- ❌ **循環参照の作成**：セクション間で相互依存を作らない
- ❌ **命名の不統一**：既存の命名規則から逸脱しない

### 実例：event_detail_page.dartの分割

#### 分割前（762行）
```dart
class EventDetailPage extends HookConsumerWidget {
  // 全てのロジックとUIが1ファイルに集約
  Widget _buildHeader() {...}       // 70行
  Widget _buildActionCards() {...}  // 146行
  Widget _buildInfo() {...}         // 76行
  Widget _buildParticipants() {...} // 79行
  Widget _buildAfterParty() {...}   // 302行
}
```

#### 分割後（135行 + 6ファイル）
```
event_detail_page.dart (135行)     # メイン構造のみ
event_detail/
├── event_detail_badges.dart (57行)         # バッジとユーティリティ
├── event_detail_header.dart (70行)         # ヘッダーセクション
├── event_detail_action_cards.dart (146行)  # アクションカード
├── event_detail_info_section.dart (76行)   # 情報セクション
├── event_detail_participants_section.dart (79行) # 参加者一覧
└── after_party_section.dart (302行)        # アフターパーティ
```

#### メインページ（event_detail_page.dart: 135行）
```dart
import 'package:shiharainu/pages/event_detail/event_detail_header.dart';
import 'package:shiharainu/pages/event_detail/event_detail_action_cards.dart';
// ... 他のインポート

class EventDetailPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状態管理のみ
    final event = ref.watch(eventProvider(eventId));

    return event.when(
      data: (event) => SingleChildScrollView(
        child: Column(
          children: [
            EventDetailHeader(event: event),
            EventDetailActionCards(eventId: eventId, event: event, role: role),
            EventDetailInfoSection(event: event, participants: participants),
            AfterPartySection(eventId: eventId, eventTitle: event.title),
            EventDetailParticipantsSection(participants: participants),
          ],
        ),
      ),
      loading: () => const AppLoadingState(),
      error: (error, _) => AppErrorState(error: error),
    );
  }
}
```

### 統一ローディング・エラー状態パターン

#### AppLoadingStateとAppErrorStateの使用
すべてのページで統一されたローディング・エラー表示を使用：

```dart
// ✅ 推奨: 統一ウィジェット使用
return asyncValue.when(
  data: (data) => _buildContent(data),
  loading: () => const AppLoadingState(message: '読み込み中...'),
  error: (error, stack) => AppErrorState(
    error: error,
    onRetry: () => ref.refresh(dataProvider),
  ),
);

// ❌ 非推奨: 個別実装
Widget _buildLoading() {
  return Center(
    child: CircularProgressIndicator(),  // 重複コード
  );
}
```

#### AppLoadingState の3つのウィジェット
```dart
// 1. AppLoadingState - フルスクリーンローディング
const AppLoadingState(
  message: '読み込み中...',
  showAppBar: true,
  title: 'イベント詳細',
)

// 2. AppErrorState - エラー表示（リトライボタン付き）
AppErrorState(
  error: error,
  onRetry: () => ref.refresh(provider),
)

// 3. AppInlineLoading - インラインローディング（セクション内）
const AppInlineLoading(
  message: '保存中...',
  size: 24,
)
```

### 分割による効果測定

#### 定量的効果
- **コード削減**: home_page 690行→169行（76%削減）、event_detail_page 762行→135行（82%削減）
- **重複排除**: ローディング/エラー処理の重複コード296行削除
- **可読性向上**: 1ファイルあたり平均150行以下で管理可能

#### 定性的効果
- **保守性向上**: セクション単位での修正が容易
- **再利用性向上**: セクションウィジェットの他ページ流用が可能
- **テスト容易性**: セクション単位でのユニットテスト作成が簡単
- **チーム開発**: 複数人での並行開発時のコンフリクト削減