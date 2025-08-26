# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリでコードを扱う際のガイダンスを提供します。

## プロジェクト概要

**shiharainu** は、飲み会や企業イベント向けのイベント決済管理用Flutterアプリケーションです。主催者が簡単に支払いを管理し、比例配分を計算し、ゲーミフィケーション要素を含む支払い確認機能を提供します。

### アプリケーションの目的
- 自動比例配分計算による イベント決済管理
- 主催者向けリアルタイム支払いステータス追跡
- 外部決済アプリ連携（PayPay、LINE Pay、楽天ペイ）
- バッジとランキングのゲーミフィケーション機能
- 二次会参加確認

## 一般的な開発コマンド

### アプリケーションの実行
```bash
# Chrome（Web）で実行
flutter run -d chrome

# 接続されている全デバイスで実行
flutter run -d all

# 特定のデバイスで実行
flutter run -d <device_id>

# 利用可能デバイス一覧
flutter devices
```

### ビルド
```bash
# Web用ビルド
flutter build web

# Android用ビルド
flutter build apk
flutter build appbundle

# iOS用ビルド
flutter build ios
```

### テストと品質管理
```bash
# 全テスト実行
flutter test

# 特定のテストファイル実行
flutter test test/widget_test.dart

# リンティング問題チェック
flutter analyze

# 依存関係更新取得
flutter pub get
flutter pub outdated
```

## アーキテクチャと構造

### 目標アーキテクチャ
- **フロントエンド**: Flutter (マルチプラットフォーム: iOS, Android, Web)
- **バックエンド**: Firebase または AWS Amplify
- **決済連携**: PayPay、LINE Pay、楽天ペイ API
- **通知**: Firebase Cloud Messaging (FCM)
- **リアルタイム通信**: Firebase Realtime Database または Firestore
- **認証**: 二要素認証
- **データエクスポート**: CSV/Excel エクスポート機能

### 現在の状態
- **クリーンアーキテクチャ実装済み** - 機能別組織化
- **Riverpod状態管理** - コード生成セットアップ済み
- **Go Router ナビゲーション** - 認証ガード付き
- **Material 3 テーマ** - ライト/ダークモード対応
- **Freezed データモデル** - JSON シリアライゼーション付き
- **マルチプラットフォーム対応** - Web、iOS、Android用設定済み
- **デバッグ認証システム** - 現在実装中（Firebase はコメントアウト）

### 計画中のアプリケーション画面

#### 幹事画面
1. **イベント作成画面** - QR/URL共有での新規イベント作成
2. **管理ダッシュボード** - リアルタイム支払いステータス概観
3. **比例パターン設定** - カスタム請求パターン設定
4. **二次会確認** - フォローアップイベント出席管理
5. **エクスポート画面** - CSV/Excel エクスポート機能

#### 参加者画面
1. **ユーザー登録画面** - URL/QRコードアクセスによるプロファイル設定
2. **支払い金額確認** - 計算された比例金額の表示
3. **外部決済連携** - 決済アプリへのリダイレクト
4. **支払い完了確認** - 支払いステータス確認
5. **二次会参加** - フォローアップイベント参加確認
6. **ランキングとバッジ** - ゲーミフィケーション要素表示

### 実装予定の主要機能
- **比例請求アルゴリズム**: 役職、年齢、性別、飲酒状況に基づく自動計算
- **リアルタイム支払い追跡**: 幹事向けリアルタイム更新
- **外部決済連携**: 決済アプリへのシームレス遷移
- **ゲーミフィケーションシステム**: スピード賞、スポンサーバッジ、ランキング
- **ゲストモード**: 登録なし支払い
- **自動リマインダー**: 支払い期限通知

### 主要ディレクトリ
- `lib/` - 機能別に整理されたメインアプリケーションコード
- `lib/shared/` - 共有モデル、サービス、ルーティング、テーマ設定
- `lib/features/` - 機能モジュール (auth, dashboard, payment など)
- `test/` - ウィジェットと単体テスト
- `android/` - Android固有の設定とビルドファイル
- `ios/` - iOS固有の設定とXcodeプロジェクト
- `web/` - Web固有のアセットと設定

### プラットフォーム設定
- **Android**: Kotlin DSL使用Gradle、パッケージ名 `com.example.shiharainu`
- **iOS**: Swift使用Xcodeプロジェクト、バンドル識別子設定可能
- **Web**: manifest.json付きPWA対応、青テーマ (#0175C2)

## 開発ワークフロー

### 現在の依存関係
- **Flutter SDK**: ^3.8.1
- **状態管理**: flutter_riverpod ^2.4.9, hooks_riverpod ^2.4.9
- **データモデル**: freezed ^2.4.6, json_annotation ^4.8.1
- **ルーティング**: go_router ^12.1.3
- **UI**: flutter_svg, cached_network_image, qr_flutter, mobile_scanner
- **ユーティリティ**: uuid, intl, url_launcher, csv, excel
- **開発ツール**: build_runner ^2.4.7, flutter_lints ^5.0.0
- **Firebase**: バージョン競合により現在コメントアウト

### コード品質
- 推奨リンティングルールに `flutter_lints` パッケージを使用
- `analysis_options.yaml` で解析オプション設定
- ウィジェットテスト付き標準Flutter テストセットアップ

### プロジェクト状況
- **バージョン**: 1.0.0+1
- **公開**: プライベート (publish_to: 'none')
- **現在の状態**: 機能ベースクリーンアーキテクチャで実装済み

## アーキテクチャ拡張メモ

### 現在の技術スタック

#### コアフレームワーク
- **Flutter SDK**: ^3.8.1 (マルチプラットフォーム: iOS, Android, Web)
- **Dart**: 最新安定版

#### 状態管理とアーキテクチャ
- **flutter_riverpod**: ^2.4.9 - リアクティブ状態管理
- **hooks_riverpod**: ^2.4.9 - Flutter Hooks との Riverpod 統合
- **flutter_hooks**: ^0.20.3 - Flutter 向け React ライクフック
- **riverpod_annotation**: ^2.3.3 - コード生成アノテーション
- **riverpod_generator**: ^2.3.9 - 自動プロバイダーコード生成

#### データモデルとシリアライゼーション
- **freezed**: ^2.4.6 - コード生成付きイミュータブルデータクラス
- **freezed_annotation**: ^2.4.1 - Freezed アノテーション
- **json_annotation**: ^4.8.1 - JSON シリアライゼーションアノテーション
- **json_serializable**: ^6.7.1 - JSON シリアライゼーションコード生成

#### ルーティングとナビゲーション
- **go_router**: ^12.1.3 - 宣言的ルーティングソリューション

#### Firebase 統合
- **firebase_core**: ^2.24.2 - Firebase コア機能
- **firebase_auth**: ^4.15.3 - 認証
- **cloud_firestore**: ^4.13.6 - NoSQL データベース
- **firebase_messaging**: ^14.7.10 - プッシュ通知

#### 決済と外部統合
- **url_launcher**: ^6.2.2 - 外部決済アプリ起動

#### QRコードとスキャン
- **qr_flutter**: ^4.1.0 - QRコード生成
- **mobile_scanner**: ^3.5.7 - QRコードスキャン

#### エクスポートとファイル生成
- **csv**: ^5.0.2 - CSV ファイル生成
- **excel**: ^4.0.2 - Excel ファイル生成

#### UI とアセット
- **flutter_svg**: ^2.0.9 - SVG レンダリング
- **cached_network_image**: ^3.3.0 - 画像キャッシング

#### ユーティリティ
- **uuid**: ^4.2.1 - UUID 生成
- **intl**: ^0.18.1 - 国際化

#### 開発ツール
- **build_runner**: ^2.4.7 - コード生成ランナー
- **custom_lint**: ^0.5.7 - カスタムリンティングルール
- **riverpod_lint**: ^2.3.7 - Riverpod 固有リンティング
- **flutter_lints**: ^5.0.0 - Flutter 推奨リント

### 実装済みアーキテクチャパターン

#### 現在のフォルダ構造
```
lib/
  app.dart                      # ルーティング付きメインアプリウィジェット
  main.dart                     # ProviderScope 付きエントリーポイント
  features/
    auth/
      data/                     # データソース、リポジトリ
      domain/                   # エンティティ、ユースケース
      presentation/             # ページ、ウィジェット、プロバイダー
    event_creation/
      data/
      domain/
      presentation/
    payment/
      data/
      domain/
      presentation/
    dashboard/
      data/
      domain/
      presentation/
    gamification/
      data/
      domain/
      presentation/
    secondary_event/
      data/
      domain/
      presentation/
  shared/
    constants/
      app_theme.dart           # アプリテーマ設定
    models/
      user_model.dart          # Freezed 使用ユーザーデータモデル
      event_model.dart         # Freezed 使用イベントデータモデル
      payment_model.dart       # Freezed 使用決済データモデル
    routing/
      app_router.dart          # Go Router 設定
    services/                  # 共有サービス
    utils/                     # ユーティリティ関数
    widgets/                   # 再利用可能ウィジェット
```

#### アーキテクチャ原則
- **クリーンアーキテクチャ**: データ、ドメイン、プレゼンテーション層の関心事の分離
- **機能ベース組織化**: 各機能が自己完結
- **状態管理**: 型安全性のためのコード生成付き Riverpod
- **イミュータブルデータ**: すべてのデータモデルに Freezed 使用
- **依存性注入**: サービス注入のための Riverpod プロバイダー
- **リポジトリパターン**: Firebase 統合のための抽象データ層

#### コード生成セットアップ
- **build.yaml**: Freezed、JSON シリアライゼーション、Riverpod 用設定済み
- **ビルドランナーコマンド**:
  ```bash
  # 一度だけコード生成
  flutter packages pub run build_runner build
  
  # 変更監視して自動再構築
  flutter packages pub run build_runner watch
  
  # 生成ファイル削除
  flutter packages pub run build_runner clean
  ```

### セキュリティとパフォーマンス考慮事項
- **暗号化**: 個人情報（特に口座番号）は暗号化が必須
- **リアルタイム更新**: 最大100同時ユーザーサポート
- **決済セキュリティ**: アプリ内にカード情報は保存せず、外部API統合のみ
- **二要素認証**: セキュリティコンプライアンスのため必須

### 開発ガイドライン - Effective Dart

Effective Dart ガイドライン (https://dart.dev/effective-dart) に従う:

#### スタイル
- 識別子に `lowerCamelCase` を使用
- 型名に `UpperCamelCase` を使用
- ライブラリ名に `lowercase_with_underscores` を使用
- 可能な場合は `var` より `final` を優先

#### ドキュメンテーション
- パブリック API には `///` を使用
- 明確で簡潔なドキュメントを記述
- 複雑な関数には例を含める

#### 使用方法
- 可能な場合は `const` コンストラクタを使用
- null 合体には条件式より `??` を優先
- コンストラクタよりコレクションリテラルを使用
- 必要でない限り `dynamic` の使用を避ける

#### 設計
- 継承より合成を優先
- 可能な場合はクラスをイミュータブルにする
- 明確性のためnamed constructorを使用
- 単一責任原則に従う

### 非機能要件
- **対象ユーザー**: 20-50歳のビジネスプロフェッショナル
- **同時ユーザー**: 最大100同時ユーザー
- **UI/UX**: 最小タップ要件の直感的でシンプルなデザイン
- **パフォーマンス**: リアルタイム支払いステータス更新
- **アクセシビリティ**: 様々な画面サイズとアクセシビリティ機能のサポート

### 将来の拡張計画
- AI駆動の最適比例パターン推奨
- 飲み会以外の様々なイベントタイプサポート
- 高度な分析・レポート機能

## 開発ワークフローとGit戦略

### ブランチ戦略 (Git Flow)

#### メインブランチ
- **main**: プロダクション準備完了コード、常にデプロイ可能
- **develop**: 機能統合ブランチ、最新の開発変更

#### サポートブランチ
- **feature/**: 機能開発ブランチ
  - 命名规則: `feature/auth-implementation`, `feature/payment-integration`
  - 分岐元: `develop`
  - マージ先: `develop`

- **hotfix/**: プロダクション緊急バグ修正
  - 命名规則: `hotfix/payment-crash-fix`
  - 分岐元: `main`
  - マージ先: `main` および `develop`

- **release/**: リリース準備ブランチ
  - 命名规則: `release/v1.0.0`
  - 分岐元: `develop`
  - マージ先: `main` および `develop`

#### ワークフロー
1. `develop` から機能ブランチ作成
2. 定期コミットで機能開発
3. `develop` へのプルリクエスト作成
4. コードレビューとマージ
5. `develop` からステージングにデプロイ
6. 準備完了時にリリースブランチ作成
7. プロダクション用にリリースを `main` にマージ

### コミットメッセージ規約

一貫性のあるコミットメッセージのために慣例的コミット仕様に従う:

#### フォーマット
```
<type>(<scope>): <description>

[オプション本文]

[オプションフッター]
```

#### タイプ
- **feat**: ユーザー向け新機能
- **fix**: ユーザー向けバグ修正
- **docs**: ドキュメンテーション変更
- **style**: コードスタイル変更（フォーマット、セミコロン等）
- **refactor**: 機能変更のないコードリファクタリング
- **test**: テスト追加または更新
- **chore**: メンテナンスタスク、依存関係更新
- **perf**: パフォーマンス改善
- **build**: ビルドシステムまたは外部依存関係
- **ci**: 継続的統合設定

#### スコープ (オプション)
- **auth**: 認証関連変更
- **payment**: 決済機能
- **dashboard**: ダッシュボード機能
- **gamification**: ゲーミフィケーション機能
- **ui**: ユーザーインターフェース変更
- **api**: API 関連変更
- **config**: 設定変更

#### 例
```bash
# 機能コミット
feat(auth): add user login functionality
feat(payment): integrate PayPay payment method
feat(dashboard): add real-time payment status updates

# バグ修正
fix(auth): resolve login form validation issue
fix(payment): handle payment timeout errors
fix(ui): fix responsive layout on mobile devices

# ドキュメンテーション
docs(readme): update installation instructions
docs(api): add payment API documentation

# リファクタリング
refactor(auth): extract user validation logic
refactor(payment): simplify payment flow state management

# テスト
test(auth): add unit tests for login service
test(payment): add integration tests for payment flow

# 雑務
chore(deps): update firebase dependencies
chore(build): configure build optimization
```

#### 破壊的変更
破壊的変更には、タイプの後に `!` を追加し、フッターに `BREAKING CHANGE:` を含める:
```
feat(api)!: change user authentication flow

BREAKING CHANGE: User authentication now requires email verification
```

### Git 統合付き開発コマンド

#### コード生成 + コミット
```bash
# コード生成とコミット
flutter packages pub run build_runner build
git add .
git commit -m "build: generate code for new models"
```

#### 機能開発ワークフロー
```bash
# 新機能開始
git checkout develop
git pull origin develop
git checkout -b feature/payment-integration

# 定期開発
git add .
git commit -m "feat(payment): add PayPay integration"
git push origin feature/payment-integration

# 機能完成時
git checkout develop
git pull origin develop
git checkout feature/payment-integration
git rebase develop
git push origin feature/payment-integration --force-with-lease
```

### プリコミットフック (オプション)
以下のプリコミットフックの追加を検討:
- コードフォーマット (`dart format`)
- リンティング (`flutter analyze`)
- テスト (`flutter test`)
- コード生成チェック