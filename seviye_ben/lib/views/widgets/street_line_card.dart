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
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            AppTheme.street.withValues(alpha: 0.1),
            AppTheme.signal.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: AppTheme.street.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 18, color: AppTheme.street),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sokak notu',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.street,
                        letterSpacing: 0.4,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  line,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
