import 'package:flutter/material.dart';

import '../../../core/themes/app_sizes.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giới thiệu')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Học tiếng Nhật N5', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'Ứng dụng học từ vựng, Kanji và luyện đề thi thử JLPT N5 theo giáo trình '
              'Minna no Nihongo Sơ cấp I. Toàn bộ dữ liệu chạy offline trên máy.',
            ),
          ],
        ),
      ),
    );
  }
}
