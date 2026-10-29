import 'package:flutter/material.dart';

/// Lightweight, fluid animated number counter widget.
/// Animates smoothly from 0 to the target value when mounted or when target changes.
class AnimatedCount extends StatelessWidget {
  final int count;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final String? suffix;
  final TextStyle? suffixStyle;

  const AnimatedCount({
    super.key,
    required this.count,
    this.style,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeOutCubic,
    this.suffix,
    this.suffixStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: count.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        final currentInt = value.round();
        if (suffix == null) {
          return Text('$currentInt', style: style);
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('$currentInt', style: style),
            const SizedBox(width: 4),
            Text(suffix!, style: suffixStyle ?? style),
          ],
        );
      },
    );
  }
}
