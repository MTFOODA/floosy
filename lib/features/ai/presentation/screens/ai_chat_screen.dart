import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/money_formatter.dart';
import '../widgets/ai_widgets.dart';

class AIChatScreen extends ConsumerStatefulWidget {
  const AIChatScreen({super.key});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  final List<_ChatMessage> _messages = [];
  final _inputController = TextEditingController();
  bool _isTyping = false;

  static const _suggestions = [
    "What's my total spending this month?",
    "Which category did I spend most on?",
    "How much cash do I have?",
    "Show me my top 3 expenses",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l = AppLocalizations.s(context);
      setState(() {
        _messages.add(_ChatMessage(text: l['askQuestion'], isUser: false));
      });
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    final l = AppLocalizations.s(context);

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isTyping = true;
    });
    _inputController.clear();

    String reply;
    try {
      reply = await _answer(text, userId);
    } catch (e) {
      reply = l['aiError'];
    }

    if (mounted) {
      setState(() {
        _messages.add(_ChatMessage(text: reply, isUser: false));
        _isTyping = false;
      });
    }
  }

  Future<String> _answer(String question, String userId) async {
    final transactionRepo = ref.read(transactionRepositoryProvider);
    final moneyRepo = ref.read(moneyRepositoryProvider);
    final itemRepo = ref.read(itemRepositoryProvider);
    final budgetRepo = ref.read(budgetRepositoryProvider);

    final transactions =
        await transactionRepo.getTransactions(userId: userId, limit: 200);
    final summary = await moneyRepo.getMoneySummary(userId);
    final items = await itemRepo.getActiveItems(userId);
    final budgets = await budgetRepo.getActiveBudgets(userId);

    final q = question.toLowerCase();

    if (q.contains('spending') || q.contains('spend') || q.contains('total')) {
      return 'Your total spending this month is ${formatMoney(summary.deductedMinor)}. You have ${transactions.length} transactions recorded.';
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
      return 'I can see ${transactions.length} transactions in your account. The largest transaction this period was ${formatMoney(transactions.isNotEmpty ? transactions.first.amountMinor : 0)}.';
    }
    if (q.contains('budget')) {
      return 'You have ${budgets.length} active budgets. Keep monitoring your spending to stay within budget limits.';
    }
    if (q.contains('item') || q.contains('items')) {
      return 'You have ${items.length} active items for quick expense tracking. These help you record cash expenses with a single tap.';
    }

    return 'I can help you understand your finances. Try asking about your total spending, cash balance, bank balance, budgets, or items. I read from your real financial data to give accurate answers.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.fc.background,
      body: SafeArea(
        child: Padding(
          padding: FloosyDesign.horizontalPadding(context).copyWith(top: 16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Expanded(child: _buildChatArea()),
              const SizedBox(height: 12),
              _buildSuggestions(),
              const SizedBox(height: 12),
              _buildInput(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                gradient: FloosyDesign.purpleGradient, shape: BoxShape.circle),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 24)),
        const SizedBox(width: 12),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello! I'm Floosy AI",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.fc.textPrimary)),
            const SizedBox(height: 2),
            Text('Ask me anything about your finances',
                style:
                    TextStyle(fontSize: 13, color: context.fc.textSecondary)),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: FloosyDesign.positive.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(FloosyDesign.radiusPill)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                    color: FloosyDesign.positive, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const Text('Online',
                style: TextStyle(fontSize: 12, color: FloosyDesign.positive)),
          ]),
        ),
      ],
    );
  }

  Widget _buildChatArea() {
    if (_messages.isEmpty) {
      return Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline,
              size: 48, color: context.fc.textMuted),
          const SizedBox(height: 12),
          Text('Ask me about your finances',
              style: TextStyle(color: context.fc.textMuted)),
        ],
      ));
    }
    return ListView.builder(
      reverse: true,
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (_, i) {
        if (_isTyping && i == 0) return const AITypingIndicator();
        final msgIndex = _isTyping ? i - 1 : i;
        if (msgIndex < 0 || msgIndex >= _messages.length) {
          return const SizedBox();
        }
        final msg = _messages[_messages.length - 1 - msgIndex];
        return AIMessageBubble(text: msg.text, isUser: msg.isUser);
      },
    );
  }

  Widget _buildSuggestions() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          return GestureDetector(
            onTap: () => _sendMessage(_suggestions[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: context.fc.chatBubbleUser,
                  borderRadius: BorderRadius.circular(FloosyDesign.radiusPill),
                  border: Border.all(color: context.fc.borderSubtle)),
              child: Center(
                  child: Text(_suggestions[i],
                      style: TextStyle(
                          fontSize: 13, color: context.fc.textSecondary))),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
          color: context.fc.primarySurface,
          borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
          border: Border.all(color: context.fc.borderSubtle)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              style: TextStyle(color: context.fc.textPrimary),
              decoration: InputDecoration(
                  hintText: 'Ask about your spending...',
                  hintStyle: TextStyle(color: context.fc.textMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18)),
              onSubmitted: _sendMessage,
            ),
          ),
          GestureDetector(
            onTap: () => _sendMessage(_inputController.text),
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  gradient: FloosyDesign.purpleGradient,
                  shape: BoxShape.circle),
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}
