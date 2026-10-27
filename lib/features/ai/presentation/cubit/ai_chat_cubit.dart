import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_financial_overview.dart';
import '../../../../core/utils/money_formatter.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  const ChatMessage({required this.text, required this.isUser});
}

class FinancialChatState {
  final List<ChatMessage> messages;
  final bool typing;
  const FinancialChatState({this.messages = const [], this.typing = false});
}

class AIChatCubit extends Cubit<FinancialChatState> {
  final GetFinancialOverview _overview;
  final String? Function() _userId;
  int _generation = 0;
  AIChatCubit(this._overview, this._userId) : super(const FinancialChatState());
  void greet(String text) {
    if (state.messages.isEmpty) {
      emit(FinancialChatState(
          messages:
              List.unmodifiable([ChatMessage(text: text, isUser: false)])));
    }
  }

  void reset() {
    _generation++;
    emit(const FinancialChatState());
  }

  Future<void> send(String text, {required String errorText}) async {
    final userId = _userId();
    if (userId == null || text.trim().isEmpty || state.typing) return;
    final generation = ++_generation;
    emit(FinancialChatState(
        messages: List.unmodifiable(
            [...state.messages, ChatMessage(text: text, isUser: true)]),
        typing: true));
    String reply;
    try {
      reply = _answer(text, await _overview(userId));
    } catch (_) {
      reply = errorText;
    }
    if (isClosed || generation != _generation || userId != _userId()) return;
    emit(FinancialChatState(
        messages: List.unmodifiable(
            [...state.messages, ChatMessage(text: reply, isUser: false)])));
  }

  String _answer(String question, FinancialOverview overview) {
    final q = question.toLowerCase();
    final summary = overview.summary;
    if (q.contains('spending') || q.contains('spend') || q.contains('total')) {
      return 'Your total spending this month is ${formatMoney(summary.deductedMinor)}. You have ${overview.transactionCount} transactions recorded.';
    }
    if (q.contains('cash') || q.contains('pocket')) {
      return 'Your pocket cash balance is ${formatMoney(summary.pocketCashMinor)}. This is your physical cash available after ATM withdrawals.';
    }
    if (q.contains('balance') || q.contains('bank')) {
      return 'Your total bank balance across all accounts is ${formatMoney(summary.myBalanceMinor)}. This includes all your bank accounts.';
    }
    if (q.contains('category') || q.contains('most')) {
      return 'Based on your transactions, your spending is distributed across different categories. Keep tracking your expenses to get detailed category insights.';
    }
    if (q.contains('top') || q.contains('expense')) {
      return 'I can see ${overview.transactionCount} transactions in your account. The largest transaction this period was ${formatMoney(overview.largestTransactionMinor)}.';
    }
    if (q.contains('budget')) {
      return 'You have ${overview.budgetCount} active budgets. Keep monitoring your spending to stay within budget limits.';
    }
    if (q.contains('item')) {
      return 'You have ${overview.itemCount} active items for quick expense tracking. These help you record cash expenses with a single tap.';
    }
    return 'I can help you understand your finances. Try asking about your total spending, cash balance, bank balance, budgets, or items. I read from your real financial data to give accurate answers.';
  }
}
