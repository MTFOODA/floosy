import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/theme/card_appearance_view.dart';
import '../../../../core/widgets/common/bank_logo.dart';
import '../../../../domain/entities/bank_directory.dart';
import '../../../../domain/entities/detected_card_model.dart';

/// A compact, physical-card-shaped selector. Selected state is a teal rim and
/// lift only; there is intentionally no check icon competing with bank data.
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
    final foreground =
        colors.map((e) => e.computeLuminance()).reduce((a, b) => a + b) /
                colors.length >
            .46
        ? const Color(0xFF072035)
        : Colors.white;
    final bank = card.bankName?.isNotEmpty == true
        ? BankCatalog.displayName(
            card.bankName,
            arabic: AppLocalizations.s(context).isArabic,
          )
        : AppLocalizations.s(context)['bankUnknown'];
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$bank ${card.last4}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          duration: FloosyDesign.normal,
          curve: Curves.easeOutCubic,
          scale: isSelected ? 1.015 : 1,
          child: AspectRatio(
            aspectRatio: 1.586,
            child: AnimatedContainer(
              duration: FloosyDesign.normal,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6AF5DF)
                      : Colors.white.withValues(alpha: .20),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .24),
                    blurRadius: 11,
                    offset: const Offset(0, 6),
                  ),
                  if (isSelected)
                    BoxShadow(
                      color: FloosyDesign.primaryPurple.withValues(alpha: .42),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -32,
                    right: -24,
                    child: _Orb(
                      color: foreground.withValues(alpha: .12),
                      size: 100,
                    ),
                  ),
                  Positioned(
                    bottom: -38,
                    left: -22,
                    child: _Orb(
                      color: foreground.withValues(alpha: .07),
                      size: 110,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            BankLogo(bankName: card.bankName, size: 26),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                bank,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: foreground,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.contactless_rounded,
                              color: foreground.withValues(alpha: .78),
                              size: 19,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          width: 25,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8C86A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFC99E2B)),
                          ),
                          child: const _ChipLines(),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '•••• ${card.last4}',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: foreground,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final Color color;
  final double size;
  const _Orb({required this.color, required this.size});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

class _ChipLines extends StatelessWidget {
  const _ChipLines();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _ChipPainter());
}

class _ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF89651E)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
