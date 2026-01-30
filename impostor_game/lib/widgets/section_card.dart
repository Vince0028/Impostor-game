import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const SectionCard({super.key, required this.child, this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.backgroundCard,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String emoji;
  final String title;
  final bool showChevron;
  final VoidCallback? onTap;

  const SectionHeader({
    super.key,
    required this.emoji,
    required this.title,
    this.showChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTheme.labelLarge.copyWith(
            color: AppTheme.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        if (showChevron) ...[
          const Spacer(),
          Icon(Icons.chevron_right, color: AppTheme.textHint),
        ],
      ],
    );
  }
}
