import 'package:flutter/material.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../data/models/detected_card_model.dart';
import '../../../../data/repositories/detected_card_repository.dart';
import 'detected_bank_card.dart';

/// Bottom sheet for customizing one card's appearance (requirement #11).
class CardCustomizationSheet extends StatefulWidget {
  final DetectedCard card;
  final DetectedCardRepository repository;

  const CardCustomizationSheet({
    super.key,
    required this.card,
    required this.repository,
  });

  @override
  State<CardCustomizationSheet> createState() => _CardCustomizationSheetState();
}

class _CardCustomizationSheetState extends State<CardCustomizationSheet> {
  late int _presetIndex;
  late int? _colorA;
  late int? _colorB;

  @override
  void initState() {
    super.initState();
    _presetIndex = widget.card.appearance.presetIndex;
    _colorA = widget.card.appearance.colorA;
    _colorB = widget.card.appearance.colorB;
  }

  List<Color> get _previewColors {
    if (_colorA != null && _colorB != null) {
      return [Color(_colorA!), Color(_colorB!)];
    }
    return CardPresets
        .presets[_presetIndex.clamp(0, CardPresets.presets.length - 1)];
  }

  Future<void> _save() async {
    final appearance = CardAppearance(
      presetIndex: _presetIndex,
      colorA: _colorA,
      colorB: _colorB,
    );
    await widget.repository
        .updateAppearance(widget.card.userId, widget.card.id, appearance);
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _pickColor({required bool isFirst}) async {
    const palette = [
      Color(0xFF6F5BD3),
      Color(0xFF0EA5E9),
      Color(0xFFF05B9A),
      Color(0xFFFFB84D),
      Color(0xFF10B981),
      Color(0xFF1E293B),
      Color(0xFFEC4899),
      Color(0xFF4F46E5),
      Color(0xFF8B5CF6),
      Color(0xFF55AFFF),
      Color(0xFF34D399),
      Color(0xFFF59E1A),
    ];
    final current = isFirst ? _colorA : _colorB;
    final idx = current == null
        ? -1
        : palette.indexWhere((c) => c.toARGB32() == current);
    final next = palette[(idx + 1) % palette.length].toARGB32();
    setState(() {
      if (isFirst) {
        _colorA = next;
      } else {
        _colorB = next;
        _colorA ??= CardPresets.presets[_presetIndex].first.toARGB32();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height -
              MediaQuery.viewInsetsOf(context).bottom,
        ),
        decoration: BoxDecoration(
          color: context.fc.primarySurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: FloosyDesign.horizontalPadding(context)
                .copyWith(top: 18, bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: context.fc.textMuted.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l['customizeCard'], style: context.fc.sectionTitle),
                const SizedBox(height: 4),
                Text(l['selectStyle'], style: context.fc.bodyTextSmall),
                const SizedBox(height: 16),
                DetectedBankCard(
                  card: widget.card.copyWith(
                    appearance: CardAppearance(
                        presetIndex: _presetIndex,
                        colorA: _colorA,
                        colorB: _colorB),
                  ),
                  onEdit: () {},
                ),
                const SizedBox(height: 20),
                Text(l['cardPreset'], style: context.fc.cardTitle),
                const SizedBox(height: 10),
                SizedBox(
                  height: 64,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: CardPresets.presets.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final selected = _presetIndex == i && _colorA == null;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _presetIndex = i;
                          _colorA = null;
                          _colorB = null;
                        }),
                        child: Container(
                          width: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: CardPresets.presets[i],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected
                                  ? FloosyDesign.primaryPurple
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: selected
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 22)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _ColorSwatch(
                        label: 'Color 1',
                        color: _previewColors[0],
                        onTap: () => _pickColor(isFirst: true),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _ColorSwatch(
                        label: 'Color 2',
                        color: _previewColors[1],
                        onTap: () => _pickColor(isFirst: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _save,
                  child: Container(
                    height: 54,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: FloosyDesign.purpleGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: glowShadow(FloosyDesign.primaryPurple,
                          radius: 16, opacity: 0.35),
                    ),
                    child: Center(
                      child: Text(
                        l['saveChanges'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ColorSwatch(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: context.fc.elevatedSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.fc.borderSubtle),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
            ),
            const SizedBox(width: 12),
            Text(label, style: context.fc.bodyText),
          ],
        ),
      ),
    );
  }
}
