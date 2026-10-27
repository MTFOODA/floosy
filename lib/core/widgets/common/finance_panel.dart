import 'package:flutter/material.dart';

/// Coloured money panels share the same subtle highlights and geometry.
class FinancePanel extends StatelessWidget {
  const FinancePanel(
      {super.key,
      required this.colors,
      required this.child,
      this.height,
      this.padding = const EdgeInsets.all(20),
      this.radius = 20});
  final List<Color> colors;
  final Widget child;
  final double? height;
  final EdgeInsets padding;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                  color: colors.last.withValues(alpha: .14),
                  blurRadius: 22,
                  offset: const Offset(0, 8))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: Stack(children: [
                Positioned.fill(child: CustomPaint(painter: _Highlights())),
                Padding(padding: padding, child: child),
              ])),
        ),
      );
}

class _Highlights extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .08);
    canvas.drawCircle(Offset(size.width * .95, 0), size.height * .65, paint);
    paint.color = Colors.white.withValues(alpha: .035);
    canvas.drawCircle(
        Offset(size.width * .1, size.height), size.height * .42, paint);
  }

  @override
  bool shouldRepaint(_Highlights oldDelegate) => false;
}
