# Shiharainu アーキテクチャ設計書

## 概要

ShiharainuはMVVM（Model-View-ViewModel）パターンをベースとし、Riverpod + Hooks + Freezedを活用したFlutterアプリケーションです。

## アーキテクチャパターン

### MVVM + Riverpod アーキテクチャ

```
┌─────────────────────────────────────────┐
│               View (UI)                 │
│        HookConsumerWidget               │
│   - UI コンポーネント                      │
│   - ユーザーインタラクション                 │
│   - Flutter Hooks (副作用管理)            │
└─────────────────┬───────────────────────┘
                  │ ref.watch/listen
                  ▼
┌─────────────────────────────────────────┐
│           ViewModel                     │
│      Riverpod StateNotifier             │
│   - ビジネスロジック                       │
│   - 状態管理                            │
│   - UI ステートの制御                     │
└─────────────────┬───────────────────────┘
                  │ データ操作
                  ▼
┌─────────────────────────────────────────┐
│         Model & Repository               │
│      Freezed Data Models               │
│   - データモデル                          │
│   - データアクセス抽象化                   │
│   - ビジネスエンティティ                   │
└─────────────────┬───────────────────────┘
                  │ データ取得/更新
                  ▼
┌─────────────────────────────────────────┐
│            Services                     │
│        実装詳細層                        │
│   - API 通信                            │
│   - ローカルストレージ                     │
│   - 外部サービス連携                      │
└─────────────────────────────────────────┘
```

## ディレクトリ構造

### 機能ベース構造

```
lib/
├── app.dart                    # メインアプリケーション設定
├── main.dart                   # エントリーポイント
├── shared/                     # 共有コンポーネント
│   ├── constants/             # 定数・設定
│   ├── models/                # 共有データモデル
│   ├── providers/             # グローバルプロバイダー
│   ├── routing/               # ナビゲーション設定
│   ├── services/              # 共有サービス
│   ├── utils/                 # ユーティリティ関数
│   └── widgets/               # 再利用可能ウィジェット
└── features/                  # 機能別モジュール
    └── <feature_name>/
        ├── models/            # フィーチャー固有のデータモデル
        ├── view_models/       # ViewModels (Riverpod StateNotifier)
        ├── views/             # UI コンポーネント (Pages & Widgets)
        ├── repositories/      # データアクセス抽象化
        └── services/          # 外部サービス・API連携
```

### 各フィーチャーの責務

#### models/
- **Freezed** を使用したイミュータブルなデータモデル
- **JSON serialization** 対応
- バリデーション付きビジネスエンティティ

```dart
@freezed
class EventCreationState with _$EventCreationState {
  const factory EventCreationState({
    @Default('') String eventName,
    @Default(0.0) double totalAmount,
    @Default(false) bool isLoading,
    String? error,
  }) = _EventCreationState;
}
```

#### view_models/
- **Riverpod Code Generation** を使用した状態管理
- ビジネスロジックの実装
- UIの状態制御

```dart
@riverpod
class EventCreationViewModel extends _$EventCreationViewModel {
  @override
  EventCreationState build() {
    return const EventCreationState();
  }

  void updateEventName(String name) {
    state = state.copyWith(eventName: name);
  }

  Future<bool> createEvent() async {
    // ビジネスロジック実装
  }
}
```

#### views/
- **HookConsumerWidget** を使用したUIコンポーネント
- **Flutter Hooks** による副作用管理
- ViewModelとの連携

```dart
class EventCreationPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(eventCreationViewModelProvider.notifier);
    final state = ref.watch(eventCreationViewModelProvider);
    
    // Flutter Hooks使用例
    useEffect(() {
      // 副作用処理
      return null;
    }, []);
    
    return Scaffold(/* UI実装 */);
  }
}
```

#### repositories/
- データソースの抽象化
- テスト可能な設計
- 複数データソースの統合

```dart
abstract class EventRepository {
  Future<List<EventModel>> getEvents();
  Future<EventModel?> createEvent(EventModel event);
}

class EventRepositoryImpl implements EventRepository {
  // 実装詳細
}
```

#### services/
- 外部API通信
- ローカルストレージ
- サードパーティサービス連携

```dart
class EventApiService {
  Future<EventModel> createEvent(EventModel event) async {
    // API通信実装
  }
}
```

## 技術スタック

### コア技術

- **Flutter SDK**: ^3.8.1
- **Dart**: 最新安定版

### 状態管理

- **flutter_riverpod**: ^2.4.9 - メイン状態管理
- **hooks_riverpod**: ^2.4.9 - Hooks統合
- **riverpod_annotation**: ^2.3.3 - コード生成アノテーション
- **riverpod_generator**: ^2.3.9 - プロバイダー自動生成

### データモデル

- **freezed**: ^2.4.6 - イミュータブルデータクラス
- **json_annotation**: ^4.8.1 - JSON シリアライゼーション
- **json_serializable**: ^6.7.1 - JSON コード生成

### UI・副作用管理

- **flutter_hooks**: ^0.20.3 - React-like フック
- **go_router**: ^12.1.3 - 宣言的ルーティング

### 開発ツール

- **build_runner**: ^2.4.7 - コード生成
- **flutter_lints**: ^5.0.0 - 静的解析

## 開発フロー

### 1. 新機能開発手順

1. **機能設計**
   ```bash
   mkdir lib/features/new_feature/{models,view_models,views,repositories,services}
   ```

2. **データモデル作成**
   ```dart
   // models/new_feature_state.dart
   @freezed
   class NewFeatureState with _$NewFeatureState {
     // モデル定義
   }
   ```

3. **ViewModel実装**
   ```dart
   // view_models/new_feature_view_model.dart
   @riverpod
   class NewFeatureViewModel extends _$NewFeatureViewModel {
     // ロジック実装
   }
   ```

4. **View実装**
   ```dart
   // views/new_feature_page.dart
   class NewFeaturePage extends HookConsumerWidget {
     // UI実装
   }
   ```

5. **コード生成**
   ```bash
   flutter packages pub run build_runner build
   ```

### 2. 状態管理パターン

#### ローカル状態
```dart
// useState（コンポーネントレベル）
final counter = useState(0);
```

#### グローバル状態
```dart
// Riverpod プロバイダー
@riverpod
class GlobalCounter extends _$GlobalCounter {
  @override
  int build() => 0;
  
  void increment() => state++;
}
```

#### 副作用管理
```dart
// useEffect（ライフサイクル管理）
useEffect(() {
  final subscription = stream.listen((data) {
    // データ処理
  });
  
  return subscription.cancel; // クリーンアップ
}, [dependency]);
```

### 3. テスト戦略

#### ViewModel テスト
```dart
void main() {
  group('EventCreationViewModel', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer();
    });
    
    test('should create event successfully', () async {
      final viewModel = container.read(eventCreationViewModelProvider.notifier);
      // テスト実装
    });
  });
}
```

## 設計原則

### 1. 責務の分離
- **View**: UIの表示とユーザーインタラクション
- **ViewModel**: ビジネスロジックと状態管理
- **Model**: データ構造とビジネスルール
- **Repository**: データアクセスの抽象化
- **Service**: 外部システムとの連携

### 2. 依存性の方向
```
View → ViewModel → Repository → Service
 ↓        ↓           ↓
Model ←  Model  ←  Model
```

### 3. テスト可能性
- 各層でのモック・スタブ対応
- 依存性注入によるテスト容易性
- ピュア関数の活用

### 4. パフォーマンス最適化
- **Riverpod**: 効率的な状態更新とリビルド制御
- **Freezed**: イミュータブルデータによる最適化
- **Hooks**: メモ化とライフサイクル最適化

## ベストプラクティス

### 1. コード組織化
- フィーチャー単位でのモジュラー設計
- 適切なファイル分割とネーミング
- インポート文の整理

### 2. 状態管理
- 単一責任原則に基づくプロバイダー設計
- イミュータブルな状態更新
- 適切な粒度でのプロバイダー分割

### 3. エラーハンドリング
- **AsyncValue** による非同期処理の状態管理
- ユーザーフレンドリーなエラー表示
- 適切なログ出力

### 4. コード生成活用
- **Freezed** によるボイラープレート削減
- **Riverpod Generator** による型安全なプロバイダー
- **JSON Serializable** による安全なデータ変換

## まとめ

このアーキテクチャにより以下を実現します：

- **保守性**: 明確な責務分離と適切な抽象化
- **テスト性**: 依存性注入とモック対応
- **スケーラビリティ**: モジュラー設計と機能分離
- **型安全性**: Dart型システムとコード生成の活用
- **開発効率**: ホットリロードと宣言的UI
- **パフォーマンス**: 効率的な状態管理とリビルド制御

これらの設計により、品質の高いFlutterアプリケーションの開発と保守を可能にします。