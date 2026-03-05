import 'package:flutter/material.dart';
import 'package:canddy_app/features/game/domain/entities/candy.dart';

class CandyWidget extends StatelessWidget {
  final Candy? candy;
  final bool isSelected;

  const CandyWidget({
    super.key,
    required this.candy,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: candy?.type.color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(isSelected ? 12 : 8),
        border: isSelected
            ? Border.all(color: Theme.of(context).colorScheme.onPrimaryContainer, width: 4)
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: candy == null
          ? null
          : Center(
              child: Icon(
                _getIconForCandyType(candy!.type),
                color: Colors.white,
                size: isSelected ? 36 : 30,
              ),
            ),
    );
  }

  IconData _getIconForCandyType(CandyType type) {
    switch (type) {
      case CandyType.red: return Icons.favorite;
      case CandyType.blue: return Icons.star;
      case CandyType.green: return Icons.circle;
      case CandyType.yellow: return Icons.diamond;
      case CandyType.purple: return Icons.square;
      case CandyType.orange: return Icons.hexagon;
    }
  }
}
