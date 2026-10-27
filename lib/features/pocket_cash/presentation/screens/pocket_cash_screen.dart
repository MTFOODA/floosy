import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:floosy/features/pocket_cash/presentation/cubit/pocket_cash_cubit.dart';
import 'package:floosy/core/state/load_state.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../domain/entities/item_model.dart';
import '../../../../theme/app_theme.dart';

/// Pocket Cash ledger view: current balance derived from cash_movements
/// plus the movement history. Balances are never mutated directly.
class PocketCashScreen extends StatefulWidget {
  const PocketCashScreen({super.key});

  @override
  State<PocketCashScreen> createState() => _PocketCashScreenState();
}

class _PocketCashScreenState extends State<PocketCashScreen> {
  String _formatMinor(int minor) {
    final value = minor / 100;
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
  }

  IconData _movementIcon(String type) {
    switch (type) {
      case 'atm_withdrawal':
        return Icons.local_atm_outlined;
      case 'cash_expense':
        return Icons.shopping_bag_outlined;
      case 'income':
        return Icons.add_circle_outline;
      case 'adjustment':
        return Icons.tune;
      default:
        return Icons.swap_vert;
    }
  }

  bool _isInflow(String type) =>
      type == 'atm_withdrawal' || type == 'income' || type == 'adjustment_in';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return Scaffold(
      appBar: AppBar(title: Text(l['pocketCash'])),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCash,
        icon: const Icon(Icons.add),
        label: Text(l['addCash']),
      ),
      body: BlocBuilder<PocketCashCubit, LoadState<(int, List<CashMovement>)>>(
        builder: (context, snapshot) {
          if (snapshot.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l['error']));
          }
          final (balance, movements) = snapshot.value ?? (0, <CashMovement>[]);
          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(l['currentBalance'],
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatMinor(balance)} EGP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(l['cashMovements'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(child: _buildMovements(movements)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMovements(List<CashMovement> movements) {
    final l = AppLocalizations.s(context);
    if (movements.isEmpty) {
      return Center(child: Text(l['noMovements']));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: movements.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final m = movements[index];
        final inflow = _isInflow(m.type);
        return Card(
          child: ListTile(
            leading: Icon(_movementIcon(m.type)),
            title: Text(m.description ?? m.type),
            subtitle:
                Text(m.movementDate.toLocal().toString().substring(0, 16)),
            trailing: Text(
              '${inflow ? '+' : '-'}${_formatMinor(m.amountMinor)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: inflow ? AppTheme.successColor : AppTheme.errorColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addCash() async {
    final l = AppLocalizations.s(context);
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l['addCash']),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l['amountEGP'],
            hintText: l['amountHint'],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l['cancel']),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l['add']),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final amount = double.tryParse(controller.text);
    if (amount == null || amount <= 0) return;

    final userId = context.read<AuthCubit>().state.userId;
    if (userId == null) return;
    final repo = context.read<PocketCashCubit>();
    final wallet = await repo.getOrCreateWallet(userId, 'EGP');
    await repo.addCash(
      userId: userId,
      walletId: wallet.id,
      amountMinor: (amount * 100).round(),
      description: l['manualCash'],
    );
    if (mounted) context.read<PocketCashCubit>().reload();
  }
}
