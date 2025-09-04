import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

/// スケルトンローディングシステム
/// 
/// コンテンツが読み込まれる前にレイアウトの構造を示すプレースホルダー
/// 体感的な読み込み速度向上とUX改善を提供します。
class AppSkeletonLoader extends HookWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool isLoading;
  final Widget? child;
  final Duration animationDuration;
  final Color baseColor;
  final Color highlightColor;

  const AppSkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.isLoading = true,
    this.child,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFF3F3F5),
    this.highlightColor = const Color(0xFFFFFFFF),
  });

  /// 円形スケルトンローディング（アバター用）
  AppSkeletonLoader.circle({
    super.key,
    required double size,
    this.isLoading = true,
    this.child,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFF3F3F5),
    this.highlightColor = const Color(0xFFFFFFFF),
  })  : width = size,
        height = size,
        borderRadius = BorderRadius.circular(size / 2);

  /// テキスト行用スケルトンローディング
  AppSkeletonLoader.text({
    super.key,
    required this.width,
    this.height = 16,
    this.isLoading = true,
    this.child,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFF3F3F5),
    this.highlightColor = const Color(0xFFFFFFFF),
  }) : borderRadius = BorderRadius.circular(8);

  /// カード用スケルトンローディング
  AppSkeletonLoader.card({
    super.key,
    this.width = double.infinity,
    this.height = 120,
    this.isLoading = true,
    this.child,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFF3F3F5),
    this.highlightColor = const Color(0xFFFFFFFF),
  }) : borderRadius = BorderRadius.circular(AppTheme.radiusLarge);

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: animationDuration,
    );

    final shimmerAnimation = useAnimation(
      Tween<double>(begin: -2.0, end: 2.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    useEffect(() {
      if (isLoading) {
        animationController.repeat();
      } else {
        animationController.stop();
      }
      return () => animationController.dispose();
    }, [isLoading]);

    if (!isLoading && child != null) {
      return child!;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor.withValues(alpha: 0.6),
                baseColor,
              ],
              stops: [
                (shimmerAnimation - 1.0).clamp(0.0, 1.0),
                shimmerAnimation.clamp(0.0, 1.0),
                (shimmerAnimation + 1.0).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: Container(
            width: width,
            height: height,
            color: baseColor,
          ),
        ),
      ),
    );
  }
}

/// リスト用のスケルトンローダー
/// 
/// リストアイテムのスケルトン表示を提供
class AppListSkeleton extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets itemPadding;
  final Widget Function(int index)? itemBuilder;

  const AppListSkeleton({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.itemPadding = const EdgeInsets.symmetric(
      horizontal: AppTheme.spacing16,
      vertical: AppTheme.spacing8,
    ),
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (itemBuilder != null) {
          return itemBuilder!(index);
        }
        
        return Container(
          padding: itemPadding,
          child: _buildDefaultListItemSkeleton(),
        );
      },
    );
  }

  Widget _buildDefaultListItemSkeleton() {
    return Row(
      children: [
        AppSkeletonLoader.circle(size: 48),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeletonLoader.text(
                width: double.infinity,
                height: 16,
              ),
              const SizedBox(height: AppTheme.spacing8),
              AppSkeletonLoader.text(
                width: 200,
                height: 14,
              ),
              const SizedBox(height: AppTheme.spacing4),
              AppSkeletonLoader.text(
                width: 120,
                height: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// カードグリッド用のスケルトンローダー
class AppGridSkeleton extends StatelessWidget {
  final int itemCount;
  final double childAspectRatio;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsets padding;

  const AppGridSkeleton({
    super.key,
    this.itemCount = 6,
    this.childAspectRatio = 1.2,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = AppTheme.spacing12,
    this.mainAxisSpacing = AppTheme.spacing12,
    this.padding = const EdgeInsets.all(AppTheme.spacing16),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => _buildGridItemSkeleton(),
    );
  }

  Widget _buildGridItemSkeleton() {
    return AppSkeletonLoader.card();
  }
}

/// イベントカード専用のスケルトンローダー
class AppEventCardSkeleton extends StatelessWidget {
  const AppEventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.mutedColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSkeletonLoader.circle(size: 40),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeletonLoader.text(
                      width: double.infinity,
                      height: 18,
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    AppSkeletonLoader.text(
                      width: 150,
                      height: 14,
                    ),
                  ],
                ),
              ),
              const AppSkeletonLoader(
                width: 60,
                height: 24,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          AppSkeletonLoader.text(
            width: double.infinity,
            height: 16,
          ),
          const SizedBox(height: AppTheme.spacing8),
          AppSkeletonLoader.text(
            width: 250,
            height: 14,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSkeletonLoader.text(
                width: 80,
                height: 14,
              ),
              const AppSkeletonLoader(
                width: 100,
                height: 32,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 通知アイテム専用のスケルトンローダー
class AppNotificationSkeleton extends StatelessWidget {
  const AppNotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.inputBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Row(
        children: [
          AppSkeletonLoader.circle(size: 36),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeletonLoader.text(
                  width: double.infinity,
                  height: 16,
                ),
                const SizedBox(height: AppTheme.spacing8),
                AppSkeletonLoader.text(
                  width: 180,
                  height: 14,
                ),
                const SizedBox(height: AppTheme.spacing4),
                AppSkeletonLoader.text(
                  width: 100,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// プロフィール情報専用のスケルトンローダー
class AppProfileSkeleton extends StatelessWidget {
  const AppProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSkeletonLoader.circle(size: 80),
        const SizedBox(height: AppTheme.spacing16),
        AppSkeletonLoader.text(
          width: 150,
          height: 20,
        ),
        const SizedBox(height: AppTheme.spacing8),
        AppSkeletonLoader.text(
          width: 120,
          height: 16,
        ),
        const SizedBox(height: AppTheme.spacing24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatSkeleton(),
            _buildStatSkeleton(),
            _buildStatSkeleton(),
          ],
        ),
      ],
    );
  }

  Widget _buildStatSkeleton() {
    return Column(
      children: [
        AppSkeletonLoader.text(
          width: 40,
          height: 24,
        ),
        const SizedBox(height: AppTheme.spacing4),
        AppSkeletonLoader.text(
          width: 60,
          height: 14,
        ),
      ],
    );
  }
}

/// 検索結果用のスケルトンローダー
class AppSearchResultsSkeleton extends StatelessWidget {
  final int itemCount;
  
  const AppSearchResultsSkeleton({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeletonLoader.text(
          width: 120,
          height: 16,
        ),
        const SizedBox(height: AppTheme.spacing16),
        ...List.generate(itemCount, (index) => 
          Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
            child: _buildSearchItemSkeleton(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchItemSkeleton() {
    return Row(
      children: [
        const AppSkeletonLoader(
          width: 60,
          height: 60,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeletonLoader.text(
                width: double.infinity,
                height: 16,
              ),
              const SizedBox(height: AppTheme.spacing8),
              AppSkeletonLoader.text(
                width: 200,
                height: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}