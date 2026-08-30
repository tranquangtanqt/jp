import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../../app/routes/app_routes.dart';

class MainScreen extends ConsumerWidget {
  final Widget child;

  const MainScreen({
    super.key,
    required this.child,
  });

  static const _tabs = <_TabItem>[
    _TabItem(AppRouteConst.home, Icons.home_outlined, Icons.home, 'Trang chủ'),
    _TabItem(AppRouteConst.vocabulary, Icons.menu_book_outlined, Icons.menu_book, 'Từ vựng'),
    _TabItem(AppRouteConst.kanji, Icons.brush_outlined, Icons.brush, 'Kanji'),
    _TabItem(AppRouteConst.exam, Icons.quiz_outlined, Icons.quiz, 'Đề thi'),
    _TabItem(AppRouteConst.setting, Icons.settings_outlined, Icons.settings, 'Cài đặt'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(appRoutesProvider).router;
    final location = router.state.uri.path;
    final currentIndex = _indexForLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => router.go(_tabs[index].path),
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }

  int _indexForLocation(String location) {
    final index = _tabs.indexWhere((tab) => location.startsWith(tab.path));

    return index < 0 ? 0 : index;
  }
}

class _TabItem {
  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _TabItem(this.path, this.icon, this.selectedIcon, this.label);
}
