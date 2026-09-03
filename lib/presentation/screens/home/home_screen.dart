import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/themes/app_sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _entries = <({String title, String subtitle, IconData icon, String route})>[
    (
      title: 'Từ vựng tiếng Nhật',
      subtitle: 'Minna no Nihongo Sơ cấp I - 25 bài',
      icon: Icons.menu_book,
      route: AppRouteConst.vocabulary,
    ),
    (
      title: 'Kanji tiếng Nhật',
      subtitle: 'Bộ thủ Khang Hy và Kanji JLPT N5',
      icon: Icons.brush,
      route: AppRouteConst.kanji,
    ),
    (
      title: 'Đề thi thử JLPT N5',
      subtitle: '25 bài trắc nghiệm theo giáo trình',
      icon: Icons.quiz,
      route: AppRouteConst.exam,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Học tiếng Nhật N5')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.padding),
        itemCount: _entries.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSizes.padding),
        itemBuilder: (context, index) {
          final entry = _entries[index];

          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(entry.icon, size: 32, color: Theme.of(context).colorScheme.primary),
              title: Text(entry.title, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(entry.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(entry.route),
            ),
          );
        },
      ),
    );
  }
}
