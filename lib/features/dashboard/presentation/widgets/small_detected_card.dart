import 'package:flutter/material.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../data/models/detected_card_model.dart';

/// A small, compact bank card widget for the Dashboard.
///
/// Shows only:
/// - Bank name
/// - Last 4 digits of the card
///
/// The card design (gradient, colors) comes from the card's persisted
/// [CardAppearance], shared with the large Detected Card screen.
///
/// Tapping selects this card as the active financial context.
class SmallDetectedCard extends StatelessWidget {
  final DetectedCard card;
  final bool isSelected;
  final VoidCallback onTap;

  const SmallDetectedCard({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = card.appearance.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avgLum = colors.map((c) => c.computeLuminance()).reduce((a, b) => a + b) / colors.length;
    final fg = avgLum > 0.45 ? const Color(0xFF1A1A2E) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        // Height is fixed by the caller (see [CardSelectorSection]); the
        // width flexes via Expanded in the Row, so the card scales to 1, 2,
        // 3 or 4-per-row layouts without overflow.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
          boxShadow: [
            ...glowShadow(colors.last, radius: 10, opacity: 0.25),
            if (isSelected)
              BoxShadow(
                color: FloosyDesign.primaryPurple.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: isSelected
              ? Border.all(color: FloosyDesign.primaryPurple, width: 2.5)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
          child: Stack(
            children: [
              // Subtle decorative elements (reuse from large card)
              Positioned(
                top: -15,
                right: -15,
                child: _DecorCircle(
                  color: fg.withValues(alpha: 0.08),
                  size: 60,
                ),
              ),
              Positioned(
                bottom: -20,
                left: -10,
                child: _DecorCircle(
                  color: fg.withValues(alpha: 0.05),
                  size: 80,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13, top: 12, bottom: 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bank name
                    Text(
                      card.bankName?.isNotEmpty == true
                          ? card.bankName!
                          : 'Bank',
                      style: TextStyle(
                        color: fg,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Last 4 digits
                    Text(
                      '•••• ${card.last4}',
                      style: TextStyle(
                        color: fg,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _DecorCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}