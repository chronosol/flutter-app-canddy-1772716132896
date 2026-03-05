import 'package:flutter/material.dart';
import 'package:canddy_app/core/constants/app_constants.dart';

class GameStatusWidget extends StatelessWidget {
  final int score;
  final int movesLeft;

  const GameStatusWidget({
    super.key,
    required this.score,
    required this.movesLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.spacingMedium)),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatusItem(
              context,
              icon: Icons.star_border,
              label: 'Score',
              value: '$score',
              color: Theme.of(context).colorScheme.primary,
            ),
            _buildStatusItem(
              context,
              icon: Icons.swap_horiz,
              label: 'Moves',
              value: '$movesLeft',
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(BuildContext context, {required IconData icon, required String label, required String value, required Color color}) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: AppConstants.spacingSmall / 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
