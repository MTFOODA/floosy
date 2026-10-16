import 'package:flutter/material.dart';
import '../../theme/app_design_system.dart';

/// Animated segmented control for Login | Register toggle.
class AuthSegmentedControl extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  const AuthSegmentedControl({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.labels = const ['Login', 'Register'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.fc.toggleBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isActive = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: FloosyDesign.slow,
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: isActive ? FloosyDesign.purpleGradient : null,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: isActive
                      ? glowShadow(FloosyDesign.primaryPurple,
                          radius: 8, opacity: 0.2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? context.fc.textPrimary
                          : context.fc.textInactive,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
