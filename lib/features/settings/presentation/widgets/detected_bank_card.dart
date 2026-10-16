import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/display_text_guard.dart';
import '../../../../data/models/detected_card_model.dart';
import 'credit_card_config_dialog.dart';
import 'card_customization_sheet.dart';

/// A realistic premium bank card with per-card gradient, EMV chip, last-4,
/// bank name, subtle decorative patterns, per-card eye (balance visibility)
/// toggle, and a credit-card config icon.
///
/// - Tapping the **pencil icon** opens card styling customization
///   (requirement #11 - per-card look).
/// - Tapping the **eye icon** toggles per-card balance visibility
///   (requirement #11, part of credit card integration).
/// - Tapping the **credit card icon** (only shown when card is a credit card)
///   opens the credit card configuration dialog (requirement #13, #17).
class DetectedBankCard extends ConsumerStatefulWidget {
  final DetectedCard card;

  /// Optional callback invoked when the user taps the pencil icon. When null
  /// the built-in customization sheet is opened.
  final VoidCallback? onEdit;

  /// Whether to show the eye (balance visibility) toggle button.
  /// When false, the eye button is hidden (used on Detected Cards page).
  /// When true, the eye button is shown (used in My Balance dashboard).
  final bool showEye;

  const DetectedBankCard({
    super.key,
    required this.card,
    this.onEdit,
    this.showEye = true,
  });

  @override
  ConsumerState createState() => _DetectedBankCardState();
}

class _DetectedBankCardState extends ConsumerState<DetectedBankCard> {
  bool? _eyeVisible;

  String? get _userId => ref.read(currentUserIdProvider);

  @override
  void initState() {
    super.initState();
    _loadEyeState();
  }

  Future<void> _loadEyeState() async {
    final userId = _userId;
    if (userId == null) return;
    final repo = ref.read(detectedCardRepositoryProvider);
    final visible = await repo.getCardEyeVisible(userId, widget.card.id);
    if (mounted) {
      setState(() => _eyeVisible = visible);
    }
  }

  Future<void> _toggleEye() async {
    final userId = _userId;
    if (userId == null) return;
    final repo = ref.read(detectedCardRepositoryProvider);
    final newVisible = await repo.toggleCardEye(userId, widget.card.id);
    if (mounted) {
      setState(() => _eyeVisible = newVisible);
      // Refresh the card list so card-scoped balance visuals stay in sync.
      ref.invalidate(detectedCardsProvider);
    }
  }

  Future<void> _openCreditConfig() async {
    final userId = _userId;
    if (userId == null) return;
    final repo = ref.read(detectedCardRepositoryProvider);

    // ALWAYS resolve the card FRESH from the store before opening the
    // dialog. A stale build-time snapshot would pre-fill the dialog with an
    // OLD Fixed Amount, and saving it back would silently rewrite the
    // Fixed Amount â€” the Fixed-Amount clamp would then drag My Balance down
    // to that old value ("enabling cash withdrawal resets My Balance" bug).
    final freshCard =
        await repo.getCardById(userId, widget.card.id) ?? widget.card;
    if (!mounted) return;

    final result = await showDialog<CreditCardConfigResult>(
      context: context,
      builder: (_) => CreditCardConfigDialog(
        cardId: freshCard.id,
        currentConfig: CreditCardConfig(
          cardId: freshCard.id,
          isCreditCard: freshCard.isCreditCard,
          creditLimitMinor: freshCard.creditLimitMinor,
          currentBalanceMinor: freshCard.currentBalanceMinor,
          cashWithdrawalEnabled: freshCard.cashWithdrawalEnabled,
          updatedAt: freshCard.updatedAt,
        ),
      ),
    );

    if (result != null) {
      if (result.isCreditCard) {
        // The Fixed Amount text was pre-filled from the FRESH card, so an
        // unchanged limit means the user ONLY toggled the cash-withdrawal
        // switch. In that case apply ONLY that flag (requirement #12): the
        // Fixed-Amount/clamp flow below must never be triggered by an
        // eligibility toggle, because a clamp rewrites the opening balance.
        if (freshCard.isCreditCard &&
            result.creditLimitMinor == freshCard.creditLimitMinor) {
          await repo.setCashWithdrawalEnabled(
              userId, freshCard.id, result.cashWithdrawalEnabled);
        } else {
          // Fixed Amount changes go through the money business layer so the
          // card's financial state stays valid: My Balance is clamped to the
          // new Fixed Amount when the limit is reduced, and the extra
          // headroom becomes addable when the limit is raised (requirement
          // #4). A newly configured credit card always starts with
          // My Balance = 0.
          await ref.read(moneyRepositoryProvider).setFixedAmountForCard(
                userId: userId,
                cardLast4: freshCard.last4,
                bankName: freshCard.bankName,
                fixedAmountMinor: result.creditLimitMinor,
                cashWithdrawalEnabled: result.cashWithdrawalEnabled,
              );
        }
      } else {
        // Switched back to a debit card: clear every credit-card field.
        await repo.setCreditCardConfig(
          userId: userId,
          cardId: freshCard.id,
          isCreditCard: false,
          creditLimitMinor: 0,
          currentBalanceMinor: 0,
          cashWithdrawalEnabled: false,
          updatedAt: DateTime.now(),
        );
      }
      ref.invalidate(detectedCardsProvider);
      ref.invalidate(selectedCardMoneySummaryProvider);
      ref.invalidate(cardPocketCashVisibleProvider(freshCard.last4));
    }
    ref.invalidate(detectedCardsProvider);
  }

  void _openCustomization() {
    // When the parent supplies an onEdit callback (e.g. Detected Cards screen
    // opens its own sheet), defer to it; otherwise open the built-in sheet.
    final onEdit = widget.onEdit;
    if (onEdit != null) {
      onEdit();
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CardCustomizationSheet(
        card: widget.card,
        repository: ref.read(detectedCardRepositoryProvider),
      ),
    ).then((_) => ref.invalidate(detectedCardsProvider));
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.card.appearance.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avgLum =
        colors.map((c) => c.computeLuminance()).reduce((a, b) => a + b) /
            colors.length;
    final fg = avgLum > 0.45 ? const Color(0xFF1A1A2E) : Colors.white;

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
        boxShadow: [
          ...glowShadow(colors.last, radius: 18, opacity: 0.35),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -40,
              child: _DecorCircle(color: fg.withValues(alpha: 0.10), size: 150),
            ),
            Positioned(
              bottom: -60,
              left: -30,
              child: _DecorCircle(color: fg.withValues(alpha: 0.07), size: 180),
            ),
            Positioned(
              top: 20,
              right: 80,
              child: _DecorRing(color: fg.withValues(alpha: 0.08)),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          DisplayTextGuard.label(
                            widget.card.bankName?.isNotEmpty == true
                                ? widget.card.bankName!
                                : 'Bank',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: fg,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      // Right-side action buttons: eye (if shown), credit config, styling
                      if (widget.showEye) ...[
                        GestureDetector(
                          onTap: _toggleEye,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: fg.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _eyeVisible == true
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: fg,
                              size: 17,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      // Credit card config icon (only for credit cards)
                      ...[
                        GestureDetector(
                          onTap: _openCreditConfig,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: fg.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.credit_card,
                              color: fg,
                              size: 17,
                            ),
                          ),
                        ),
                      ],
                      // Styling customization
                      GestureDetector(
                        onTap: _openCustomization,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: fg.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child:
                              Icon(Icons.brush_outlined, color: fg, size: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _EmvChip(color: fg),
                  const Spacer(),
                  Text(
                    '•••• ${widget.card.last4}',
                    style: TextStyle(
                      color: fg,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.card.transactionCount} transactions',
                    style: TextStyle(
                      color: fg.withValues(alpha: 0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmvChip extends StatelessWidget {
  final Color color;
  const _EmvChip({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.85),
            color.withValues(alpha: 0.55)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: CustomPaint(painter: _ChipLines(color: color)),
    );
  }
}

class _ChipLines extends CustomPainter {
  final Color color;
  _ChipLines({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _ChipLines oldDelegate) => false;
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

class _DecorRing extends StatelessWidget {
  final Color color;
  const _DecorRing({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
    );
  }
}
