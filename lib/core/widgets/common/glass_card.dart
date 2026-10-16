import 'package:flutter/material.dart';
import '../../theme/app_design_system.dart';

/// A reusable premium card with dark surface, rounded corners and subtle border.
class FloosyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Color? color;
  final Color? borderColor;

  const FloosyCard({
    super.key,
    required this.child,
    this.padding,
    this.radius,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(FloosyDesign.cardPadding(context)),
      decoration: BoxDecoration(
        color: color ?? context.fc.primarySurface,
        borderRadius:
            BorderRadius.circular(radius ?? FloosyDesign.radiusMedium),
        border: Border.all(
          color: borderColor ?? context.fc.borderSubtle,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

/// Gradient card used for the balance hero card and profile card.
class FloosyGradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Gradient? gradient;

  const FloosyGradientCard({
    super.key,
    required this.child,
    this.padding,
    this.radius,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(FloosyDesign.cardPadding(context)),
      decoration: BoxDecoration(
        gradient: gradient ?? context.fc.balanceGradient,
        borderRadius: BorderRadius.circular(radius ?? FloosyDesign.radiusXL),
        border: Border.all(color: context.fc.borderSubtle, width: 1),
      ),
      child: child,
    );
  }
}

/// Animated progress bar for budget items.
class FloosyProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color color;
  final double height;
  final Duration duration;

  const FloosyProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.height = 6,
    this.duration = FloosyDesign.chartAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: context.fc.elevatedSurface,
        borderRadius: BorderRadius.circular(FloosyDesign.radiusPill),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(FloosyDesign.radiusPill),
              ),
            ),
          );
        },
      ),
    );
  }
}
