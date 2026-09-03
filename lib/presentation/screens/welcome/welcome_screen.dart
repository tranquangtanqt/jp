import 'package:flutter/material.dart';

import '../../../core/assets/assets.dart';
import '../../../core/themes/app_sizes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 270),
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Assets.welcome, width: 160, errorBuilder: (_, _, _) => const SizedBox.shrink()),
          const SizedBox(height: AppSizes.padding),
          Text(
            'Chào mừng!',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Học tiếng Nhật JLPT N5',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
