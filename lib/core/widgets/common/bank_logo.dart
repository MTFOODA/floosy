import 'package:flutter/material.dart';
import '../../../domain/entities/bank_directory.dart';

/// Bundled website brand icons remain available while the device is offline.
class BankLogo extends StatelessWidget {
  final String? bankName;
  final double size;
  const BankLogo({super.key, this.bankName, this.size = 28});

  @override
  Widget build(BuildContext context) {
    final bank = BankCatalog.byIdentity(bankName);
    final fallback = Icon(
      bank?.isWallet == true
          ? Icons.account_balance_wallet_outlined
          : Icons.account_balance_outlined,
      size: size * .65,
      color: const Color(0xFF475569),
    );
    return Semantics(
      label: BankCatalog.displayName(
        bankName,
        arabic: Localizations.localeOf(context).languageCode == 'ar',
      ),
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * .1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size * .22),
        ),
        child: bank == null
            ? fallback
            : Image.asset(
                bank.logoAsset,
                fit: BoxFit.contain,
                excludeFromSemantics: true,
                errorBuilder: (_, __, ___) => fallback,
              ),
      ),
    );
  }
}
