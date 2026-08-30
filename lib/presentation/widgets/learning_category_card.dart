import 'package:flutter/material.dart';

import '../../core/themes/app_sizes.dart';

class LearningCategoryCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailingInfo;
  final bool disabled;
  final VoidCallback? onTap;

  const LearningCategoryCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingInfo,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        onTap: disabled ? null : onTap,
        child: Opacity(
          opacity: disabled ? 0.5 : 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
                    if (disabled)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Sắp có', style: theme.textTheme.labelSmall),
                      )
                    else if (!disabled && onTap != null)
                      const Icon(Icons.chevron_right),
                  ],
                ),
                if (trailingInfo != null) ...[
                  const SizedBox(height: 4),
                  Text(trailingInfo!, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                ],
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(subtitle!, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
