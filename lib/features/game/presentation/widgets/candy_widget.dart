import 'package:canddy/features/game/domain/entities/candy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CandyWidget extends StatelessWidget {
  final Candy candy;
  final bool isSelected;
  final double candySize;

  const CandyWidget({
    super.key,
    required this.candy,
    this.isSelected = false,
    required this.candySize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(isSelected ? 4.0 : 8.0),
      decoration: BoxDecoration(
        border: isSelected
            ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
            : null,
        borderRadius: BorderRadius.circular(isSelected ? 8.0 : 0.0),
      ),
      child: Center(
        child: Icon(
          candy.type.icon,
          color: candy.type.color,
          size: candySize * 0.7,
        ).animate(
          onPlay: (controller) {
            if (isSelected) {
              controller.repeat(reverse: true);
            } else {
              controller.stop();
            }
          },
        ).scale(
          duration: 500.ms,
          begin: 1.0,
          end: 1.1,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
