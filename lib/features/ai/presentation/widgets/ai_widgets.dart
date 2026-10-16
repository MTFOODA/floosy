import 'package:flutter/material.dart';
import '../../../../core/theme/app_design_system.dart';

class AIMessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const AIMessageBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    // AlignmentDirectional flips automatically in RTL (Arabic) layouts.
    return Align(
      alignment: isUser
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color:
              isUser ? FloosyDesign.primaryPurple : context.fc.chatBubbleUser,
          borderRadius: BorderRadiusDirectional.only(
              topStart: const Radius.circular(18),
              topEnd: const Radius.circular(18),
              bottomStart: Radius.circular(isUser ? 18 : 4),
              bottomEnd: Radius.circular(isUser ? 4 : 18)),
          border: isUser ? null : Border.all(color: context.fc.borderSubtle),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 14, color: context.fc.textPrimary, height: 1.4)),
      ),
    );
  }
}

class AITypingIndicator extends StatelessWidget {
  const AITypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
            color: context.fc.chatBubbleUser,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.fc.borderSubtle)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _dot(context, 0),
          const SizedBox(width: 4),
          _dot(context, 1),
          const SizedBox(width: 4),
          _dot(context, 2),
        ]),
      ),
    );
  }

  static Widget _dot(BuildContext context, int i) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: Duration(milliseconds: 600 + (i * 200)),
      builder: (context, value, _) {
        return Opacity(
            opacity: value,
            child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: context.fc.textMuted, shape: BoxShape.circle)));
      },
    );
  }
}
