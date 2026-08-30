import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/theme/theme_notifier.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = ref.watch(themeNotifierProvider.select((s) => s.isLight));

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Giao diện sáng'),
            subtitle: Text(isLight ? 'Đang dùng giao diện sáng' : 'Đang dùng giao diện tối'),
            value: isLight,
            onChanged: (value) => ref.read(themeNotifierProvider.notifier).changeBrightness(value),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Giới thiệu'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/setting/about'),
          ),
        ],
      ),
    );
  }
}
