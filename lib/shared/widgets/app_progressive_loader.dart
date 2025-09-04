import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/app_skeleton_loader.dart';

/// プログレッシブローディングシステム
/// 
/// コンテンツを段階的に表示することで体感的な読み込み速度を向上させる
/// 優先度の高い要素から順番にフェードインアニメーションで表示
class AppProgressiveLoader extends HookWidget {
  final List<ProgressiveLoadItem> items;
  final Duration staggerDelay;
  final Duration animationDuration;
  final bool isLoading;
  final Widget? skeleton;

  const AppProgressiveLoader({
    super.key,
    required this.items,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.animationDuration = const Duration(milliseconds: 300),
    this.isLoading = false,
    this.skeleton,
  });

  @override
  Widget build(BuildContext context) {
    final List<AnimationController> controllers = [];
    
    // 各アイテムのアニメーションコントローラーを作成
    for (int i = 0; i < items.length; i++) {
      final controller = useAnimationController(
        duration: animationDuration,
      );
      controllers.add(controller);
    }

    useEffect(() {
      if (!isLoading) {
        // 段階的にアニメーションを開始
        for (int i = 0; i < controllers.length; i++) {
          Future.delayed(staggerDelay * i, () {
            if (context.mounted) {
              controllers[i].forward();
            }
          });
        }
      } else {
        // ローディング中はすべてリセット
        for (final controller in controllers) {
          controller.reset();
        }
      }
      return null;
    }, [isLoading]);

    if (isLoading && skeleton != null) {
      return skeleton!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final controller = controllers[index];

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: controller,
                curve: Curves.easeOut,
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: controller,
                  curve: Curves.easeOut,
                )),
                child: item.child,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

/// プログレッシブローディング用のアイテム定義
class ProgressiveLoadItem {
  final Widget child;
  final int priority;
  final Duration? delay;

  const ProgressiveLoadItem({
    required this.child,
    this.priority = 0,
    this.delay,
  });
}

/// ページレイアウト用のプログレッシブローダー
/// 
/// ナビゲーション → メインコンテンツ → サイドコンテンツの順で表示
class AppPageProgressiveLoader extends HookWidget {
  final Widget? navigation;
  final Widget mainContent;
  final Widget? sideContent;
  final bool isLoading;

  const AppPageProgressiveLoader({
    super.key,
    this.navigation,
    required this.mainContent,
    this.sideContent,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = <ProgressiveLoadItem>[
      if (navigation != null)
        ProgressiveLoadItem(
          child: navigation!,
          priority: 1,
        ),
      ProgressiveLoadItem(
        child: mainContent,
        priority: 2,
      ),
      if (sideContent != null)
        ProgressiveLoadItem(
          child: sideContent!,
          priority: 3,
        ),
    ];

    return AppProgressiveLoader(
      items: items,
      isLoading: isLoading,
      staggerDelay: const Duration(milliseconds: 150),
      skeleton: _buildPageSkeleton(),
    );
  }

  Widget _buildPageSkeleton() {
    return Row(
      children: [
        if (navigation != null)
          Container(
            width: 200,
            height: double.infinity,
            color: AppTheme.inputBackground,
            child: Column(
              children: List.generate(
                5,
                (index) => Container(
                  margin: const EdgeInsets.all(AppTheme.spacing8),
                  child: AppSkeletonLoader.text(
                    width: double.infinity,
                    height: 40,
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: AppListSkeleton(itemCount: 3),
          ),
        ),
        if (sideContent != null)
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                children: [
                  AppSkeletonLoader.card(height: 120),
                  const SizedBox(height: AppTheme.spacing16),
                  AppSkeletonLoader.card(height: 80),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// リスト用のプログレッシブローダー
/// 
/// リストアイテムを段階的に表示
class AppListProgressiveLoader extends HookWidget {
  final List<Widget> items;
  final bool isLoading;
  final int skeletonCount;
  final ScrollController? scrollController;

  const AppListProgressiveLoader({
    super.key,
    required this.items,
    this.isLoading = false,
    this.skeletonCount = 5,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppListSkeleton(itemCount: skeletonCount);
    }

    final progressiveItems = items.asMap().entries.map((entry) {
      return ProgressiveLoadItem(
        child: entry.value,
        priority: entry.key,
      );
    }).toList();

    return ListView(
      controller: scrollController,
      children: [
        AppProgressiveLoader(
          items: progressiveItems,
          staggerDelay: const Duration(milliseconds: 80),
        ),
      ],
    );
  }
}

/// グリッド用のプログレッシブローダー
class AppGridProgressiveLoader extends HookWidget {
  final List<Widget> items;
  final bool isLoading;
  final int crossAxisCount;
  final double childAspectRatio;
  final int skeletonCount;

  const AppGridProgressiveLoader({
    super.key,
    required this.items,
    this.isLoading = false,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.2,
    this.skeletonCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppGridSkeleton(
        itemCount: skeletonCount,
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      );
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      padding: const EdgeInsets.all(AppTheme.spacing16),
      crossAxisSpacing: AppTheme.spacing12,
      mainAxisSpacing: AppTheme.spacing12,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        
        return AppProgressiveLoadingSingleItem(
          delay: Duration(milliseconds: index * 80),
          child: item,
        );
      }).toList(),
    );
  }
}

/// 単一アイテムのプログレッシブローディング
class AppProgressiveLoadingSingleItem extends HookWidget {
  final Widget child;
  final Duration delay;
  final Duration animationDuration;

  const AppProgressiveLoadingSingleItem({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: animationDuration,
    );

    final opacityAnimation = useMemoized(() =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
      ), [animationController]);

    final slideAnimation = useMemoized(() =>
      Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
      ), [animationController]);

    useEffect(() {
      Future.delayed(delay, () {
        if (context.mounted) {
          animationController.forward();
        }
      });
      return null;
    }, []);

    return FadeTransition(
      opacity: opacityAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}

/// カード専用のプログレッシブローダー
class AppCardProgressiveLoader extends StatelessWidget {
  final List<Widget> cards;
  final bool isLoading;
  final int skeletonCount;

  const AppCardProgressiveLoader({
    super.key,
    required this.cards,
    this.isLoading = false,
    this.skeletonCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        children: List.generate(
          skeletonCount,
          (index) => const AppEventCardSkeleton(),
        ),
      );
    }

    return Column(
      children: cards.asMap().entries.map((entry) {
        final index = entry.key;
        final card = entry.value;

        return AppProgressiveLoadingSingleItem(
          delay: Duration(milliseconds: index * 100),
          child: card,
        );
      }).toList(),
    );
  }
}

/// プルリフレッシュ対応のプログレッシブローダー
class AppRefreshableProgressiveLoader extends HookWidget {
  final List<Widget> items;
  final bool isLoading;
  final bool isRefreshing;
  final Future<void> Function() onRefresh;
  final int skeletonCount;

  const AppRefreshableProgressiveLoader({
    super.key,
    required this.items,
    required this.onRefresh,
    this.isLoading = false,
    this.isRefreshing = false,
    this.skeletonCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppListSkeleton(itemCount: skeletonCount);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppTheme.primaryColor,
      child: AppListProgressiveLoader(
        items: items,
        isLoading: isRefreshing,
        skeletonCount: skeletonCount,
      ),
    );
  }
}

/// セクション別のプログレッシブローダー
/// 
/// 異なる種類のコンテンツを段階的に表示
class AppSectionProgressiveLoader extends HookWidget {
  final List<ProgressiveSection> sections;
  final bool isLoading;
  final Widget? skeleton;

  const AppSectionProgressiveLoader({
    super.key,
    required this.sections,
    this.isLoading = false,
    this.skeleton,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && skeleton != null) {
      return skeleton!;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections.asMap().entries.map((entry) {
          final index = entry.key;
          final section = entry.value;

          return AppProgressiveLoadingSingleItem(
            delay: Duration(milliseconds: index * 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (section.title != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing16,
                      vertical: AppTheme.spacing8,
                    ),
                    child: Text(
                      section.title!,
                      style: AppTheme.headlineSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                section.content,
                const SizedBox(height: AppTheme.spacing16),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// プログレッシブローディング用のセクション定義
class ProgressiveSection {
  final String? title;
  final Widget content;
  final int priority;

  const ProgressiveSection({
    this.title,
    required this.content,
    this.priority = 0,
  });
}