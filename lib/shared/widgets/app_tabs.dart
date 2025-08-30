import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class AppTabItem {
  final String label;
  final IconData? icon;
  final Widget content;

  const AppTabItem({
    required this.label,
    this.icon,
    required this.content,
  });
}

class AppTabs extends StatefulWidget {
  final List<AppTabItem> items;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;

  const AppTabs({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.onTabChanged,
  });

  @override
  State<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.items.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.onTabChanged != null) {
      widget.onTabChanged!(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          decoration: const BoxDecoration(
            color: AppTheme.mutedColor,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: widget.items.map((item) => _buildTab(item)).toList(),
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            indicatorPadding: const EdgeInsets.all(2),
            labelColor: Colors.black87,
            unselectedLabelColor: AppTheme.mutedForeground,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            dividerColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.items.map((item) => item.content).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(AppTabItem item) {
    return Tab(
      height: 36,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null) ...[
            Icon(item.icon, size: 16),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              item.label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}