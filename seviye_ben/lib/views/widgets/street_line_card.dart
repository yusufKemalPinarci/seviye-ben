import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';

class StreetLineCard extends StatelessWidget {
  const StreetLineCard({super.key, required this.line});

  final String line;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.street.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.street.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sokak notu',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.street,
                  letterSpacing: 0.3,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            line,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.35,
                ),
          ),
        ],
      ),
    );
  }
}
