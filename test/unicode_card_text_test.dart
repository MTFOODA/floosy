import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/core/providers.dart';
import 'package:floosy/data/models/detected_card_model.dart';
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/repositories/detected_card_repository.dart';
import 'package:floosy/features/settings/presentation/widgets/detected_bank_card.dart';
import 'package:floosy/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Regression tests for the corrupted Unicode text on Detected Cards.
///
/// The screenshot corruption (`â€¢â€¢â€¢â€¢ 2307` instead of `•••• 2307`) was
/// mojibake baked into the widget source (UTF-8 bullet chars mis-saved as
/// CP1252/Latin-1). These tests pin down that:
///   1. the card widget renders REAL Unicode bullets + last4 (no mojibake),
///   2. Arabic bank names survive the full persistence path
///      (model → jsonEncode → SharedPreferences → jsonDecode → model)
///      with correct Unicode end-to-end.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const arabicBank = 'بنك فيصل';
  const last4 = '2307';

  DetectedCard card() => DetectedCard(
        id: 'card-1',
        userId: 'u1',
        last4: last4,
        bankName: arabicBank,
        transactionCount: 3,
      );

  group('DetectedCard Unicode persistence (source → model → storage)', () {
    test('Arabic bank name survives jsonEncode/jsonDecode round-trip', () {
      final encoded = jsonEncode(card().toJson());
      final restored =
          DetectedCard.fromJson(Map<String, dynamic>.from(jsonDecode(encoded)));

      expect(restored.bankName, arabicBank);
      expect(restored.last4, last4);
      expect(restored.bankName!.contains('\u0628\u0646\u0643'), isTrue,
          reason: 'bank name must be real Arabic, not mojibake');
      // Mojibake markers must never appear in persisted data.
      expect(encoded.contains('\u00E2'), isFalse);
      expect(encoded.contains('\u00C3'), isFalse);
    });

    test('Arabic bank name survives the SharedPreferences storage path',
        () async {
      SharedPreferences.setMockInitialValues({});
      final datasource = DetectedCardLocalDataSource();

      await datasource.saveCards('u1', [card()]);
      final loaded = await datasource.getCards('u1');

      expect(loaded, hasLength(1));
      expect(loaded.single.bankName, arabicBank);
      expect(loaded.single.last4, last4);
    });
  });

  group('DetectedBankCard rendering (UI Unicode regression)', () {
    testWidgets('renders real bullets + last4 and the Arabic bank name',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'floosy_detected_cards_u1': jsonEncode([card().toJson()]),
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserIdProvider.overrideWithValue('u1'),
            detectedCardRepositoryProvider.overrideWithValue(
              DetectedCardRepository(local: DetectedCardLocalDataSource()),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: DetectedBankCard(
                card: DetectedCard(
                  id: 'card-1',
                  userId: 'u1',
                  last4: last4,
                  bankName: arabicBank,
                  transactionCount: 3,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The card's masked number line: REAL bullets + correct digits —
      // exactly the line that rendered as `â€¢â€¢â€¢â€¢ 2307` in the bug.
      expect(find.text('•••• $last4'), findsOneWidget);
      // Bank name renders as normal Arabic Unicode.
      expect(find.text(arabicBank), findsOneWidget);

      // NO Text widget anywhere in the card may contain mojibake markers
      // (â, Ã, ¨, © — the CP1252/Latin-1 residue characters).
      final allTexts = tester
          .widgetList<Text>(find.byType(Text))
          .map((w) => w.data ?? '')
          .join('\n');
      for (final marker in ['\u00E2', '\u00C3', '\u00A8', '\u00A9']) {
        expect(allTexts.contains(marker), isFalse,
            reason: 'mojibake marker $marker found in card text:\n$allTexts');
      }
    });
  });
}
