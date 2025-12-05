import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Applications tab - shows pending and confirmed applications by event
class ApplicationsTab extends StatelessWidget {
  final String userId;

  const ApplicationsTab({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: AppColors.grey.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Applications',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Review musician applications for your events.\nComing in next update!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}