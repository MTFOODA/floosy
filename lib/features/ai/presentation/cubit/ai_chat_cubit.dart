import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/salary_plan.dart';
import '../../../../domain/repositories/salary_plan_repository.dart';
import '../../../../domain/usecases/get_financial_overview.dart';

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

/// Evidence-only local advisor. Ledger data never leaves the encrypted device.
class AIChatCubit extends Cubit<FinancialChatState> {
  final GetFinancialOverview _overview;
  final SalaryPlanRepository _salary;
  final String? Function() _userId;
  int _generation = 0;

  AIChatCubit(this._overview, this._salary, this._userId)
    : super(const FinancialChatState());

  void greet(String text) {
    if (state.messages.isEmpty) {
      emit(
        FinancialChatState(
          messages: List.unmodifiable([ChatMessage(text: text, isUser: false)]),
        ),
      );
    }
  }

  void reset() {
    _generation++;
    emit(const FinancialChatState());
  }

  Future<void> send(
    String text, {
    required String errorText,
    bool arabic = false,
  }) async {
    final userId = _userId();
    if (userId == null || text.trim().isEmpty || state.typing) return;
    final generation = ++_generation;
    emit(
      FinancialChatState(
        messages: List.unmodifiable([
          ...state.messages,
          ChatMessage(text: text, isUser: true),
        ]),
        typing: true,
      ),
    );
    String reply;
    try {
      final facts = await _overview(userId);
      final cycle = await _salary.summaryFor(
        userId,
        reference: _monthInQuestion(text) ?? DateTime.now(),
      );
      reply = _answer(text, facts, cycle, arabic);
    } catch (_) {
      reply = errorText;
    }
    if (isClosed || generation != _generation || userId != _userId()) return;
    emit(
      FinancialChatState(
        messages: List.unmodifiable([
          ...state.messages,
          ChatMessage(text: reply, isUser: false),
        ]),
      ),
    );
  }

  String _answer(
    String question,
    FinancialOverview facts,
    SalaryCycleSummary cycle,
    bool ar,
  ) {
    final q = question.toLowerCase();
    final savings = _has(q, const [
      'ادخار',
      'وفر',
      'خطة',
      'راتب',
      'مرتب',
      'saving',
      'save',
      'salary',
      'plan',
    ]);
    final balance = _has(q, const [
      'رصيد',
      'balance',
      'bank',
      'بنك',
      'cash',
      'كاش',
      'نقد',
      'pocket',
    ]);
    final items = _has(q, const ['عنصر', 'items', 'item']);
    if (balance && !savings) {
      return '${_evidence(cycle, ar)}\n${ar ? 'رصيد حساباتك الحالي' : 'Your current bank balance'}: ${_money(facts.summary.myBalanceMinor, ar)}. ${ar ? 'والكاش المتاح' : 'Pocket cash'}: ${_money(facts.summary.pocketCashMinor, ar)}. ${ar ? 'هذه الأرصدة لا تُصفّر مع بداية الدورة.' : 'These balances do not reset at the start of a salary cycle.'}';
    }
    if (items) {
      return '${_evidence(cycle, ar)}\n${ar ? 'لديك' : 'You have'} ${facts.itemCount} ${ar ? 'عنصرًا نشطًا للتسجيل السريع. تُؤخذ العناصر في الاعتبار مع معاملات الدورة، ولا تُعدَّل أي حركة تلقائيًا.' : 'active quick-entry items. They are considered alongside cycle transactions, and no transaction is changed automatically.'}';
    }
    if (savings ||
        _has(q, const [
          'سحب',
          'شراء',
          'تحويل',
          'صرف',
          'مصروف',
          'withdraw',
          'purchase',
          'transfer',
          'spend',
          'expense',
        ])) {
      return _plan(cycle, facts.itemCount, ar);
    }
    return '${_evidence(cycle, ar)}\n${ar ? 'يمكنك أن تسأل عن الراتب والشراء والسحب والتحويل والكاش لأي شهر، مثل: «خطة ادخار نوفمبر 2026». كل رد يُعاد حسابه من معاملاتك المحلية المحدثة.' : 'Ask about salary, purchases, withdrawals, transfers, cash, or a specific month, for example: “Build a savings plan for November 2026.” Every answer is recalculated from your updated local transactions.'}';
  }

  String _plan(SalaryCycleSummary c, int itemCount, bool ar) {
    if (!c.isConfigured) {
      return '${_evidence(c, ar)}\n${ar ? 'لإنشاء خطة ادخار دقيقة، أضف الراتب الشهري ويوم بداية دورتك من «الراتب ودورة الإنفاق» في الإعدادات. رصيد الحساب الذي تضبطه هناك هو رصيد البطاقة الحقيقي؛ والحركات اللاحقة تُحدّثه تلقائيًا.' : 'For a reliable saving plan, add your monthly salary and cycle start day in “Salary & spending cycle”. The account balance set there is the card’s real balance, and later movements update it automatically.'}';
    }
    final advice = <String>[];
    if (c.withdrawalRatio >= .20)
      advice.add(
        ar
            ? 'السحب النقدي وصل إلى ${_percent(c.withdrawalRatio)} من الراتب؛ جرّب حدًا نقديًا قدره 15% أسبوعيًا.'
            : 'Cash withdrawals are ${_percent(c.withdrawalRatio)} of salary; try a 15% cash cap with a weekly allowance.',
      );
    if (c.purchaseMinor > c.salaryMinor * .60)
      advice.add(
        ar
            ? 'المشتريات تتجاوز 60% من الراتب؛ ضع سقفًا أسبوعيًا للمشتريات قبل نهاية الدورة.'
            : 'Purchases use over 60% of salary; set a weekly purchase ceiling before the cycle ends.',
      );
    if (c.transferMinor > c.salaryMinor * .20)
      advice.add(
        ar
            ? 'التحويلات الصادرة كبيرة مقارنة بالراتب؛ راجع المتكرر منها قبل التحويل القادم.'
            : 'Outgoing transfers are high relative to salary; review recurring ones before the next transfer.',
      );
    final target = (c.remainingMinor * .10).floor();
    advice.add(
      target > 0
          ? (ar
                ? 'الادخار المقترح الآن: ${_money(target, ar)} (10% من الجزء غير الموزع من الراتب).'
                : 'Suggested saving now: ${_money(target, ar)} (10% of the salary still unallocated).')
          : (ar
                ? 'الراتب المخطط موزع بالكامل لهذه الدورة؛ أوقف الإنفاق الاختياري حتى الدورة التالية أو دخل جديد.'
                : 'The planned salary is fully allocated this cycle; pause optional spending until the next cycle or new income.'),
    );
    if (c.hasSalaryEvidence)
      advice.add(
        ar
            ? 'تم رصد ${c.salaryMessageCount} رسالة مرتب بإجمالي ${_money(c.salaryMessageMinor, ar)}.'
            : '${c.salaryMessageCount} salary message(s) were detected, totaling ${_money(c.salaryMessageMinor, ar)}.',
      );
    advice.add(
      ar
          ? 'عناصر التسجيل النشطة: $itemCount.'
          : 'Active quick-entry items: $itemCount.',
    );
    return '${_evidence(c, ar)}\n• ${advice.join('\n• ')}';
  }

  String _evidence(SalaryCycleSummary c, bool ar) {
    final period = _period(c, ar);
    if (ar)
      return 'الدليل — الفترة $period: ${c.purchaseCount} شراء بإجمالي ${_money(c.purchaseMinor, true)}، ${c.withdrawalCount} سحب بإجمالي ${_money(c.withdrawalMinor, true)}، و${c.transferCount} تحويل صادر بإجمالي ${_money(c.transferMinor, true)}. تم تسجيل ${c.trackedItemCount} من العناصر السريعة. ${c.cashExpenseCount} مصروف كاش (${_money(c.cashExpenseMinor, true)}) محفوظ منفصلًا كي لا يُحسب سحب الـATM مرتين.';
    return 'Evidence — $period: ${c.purchaseCount} purchase(s) totaling ${_money(c.purchaseMinor, false)}, ${c.withdrawalCount} withdrawal(s) totaling ${_money(c.withdrawalMinor, false)}, and ${c.transferCount} outgoing transfer(s) totaling ${_money(c.transferMinor, false)}. ${c.trackedItemCount} quick-entry item(s) were recorded. ${c.cashExpenseCount} cash expense(s) (${_money(c.cashExpenseMinor, false)}) stay separate so an ATM withdrawal is not counted twice.';
  }

  String _period(SalaryCycleSummary c, bool ar) {
    const arMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    const enMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final end = c.endExclusive.subtract(const Duration(days: 1));
    final names = ar ? arMonths : enMonths;
    return ar
        ? '${c.start.day} ${names[c.start.month - 1]} ${c.start.year} – ${end.day} ${names[end.month - 1]} ${end.year}'
        : '${names[c.start.month - 1]} ${c.start.day}, ${c.start.year} – ${names[end.month - 1]} ${end.day}, ${end.year}';
  }

  String _money(int amount, bool ar) =>
      formatMoney(amount, symbol: ar ? 'ج.م.' : 'EGP');
  String _percent(double ratio) => '${(ratio * 100).round()}%';
  bool _has(String value, List<String> terms) => terms.any(value.contains);

  DateTime? _monthInQuestion(String question) {
    final q = question.toLowerCase();
    const months = <String, int>{
      'january': 1,
      'jan': 1,
      'يناير': 1,
      'february': 2,
      'feb': 2,
      'فبراير': 2,
      'march': 3,
      'mar': 3,
      'مارس': 3,
      'april': 4,
      'apr': 4,
      'أبريل': 4,
      'ابريل': 4,
      'may': 5,
      'مايو': 5,
      'june': 6,
      'jun': 6,
      'يونيو': 6,
      'july': 7,
      'jul': 7,
      'يوليو': 7,
      'august': 8,
      'aug': 8,
      'أغسطس': 8,
      'اغسطس': 8,
      'september': 9,
      'sep': 9,
      'sept': 9,
      'سبتمبر': 9,
      'october': 10,
      'oct': 10,
      'أكتوبر': 10,
      'اكتوبر': 10,
      'november': 11,
      'nov': 11,
      'نوفمبر': 11,
      'december': 12,
      'dec': 12,
      'ديسمبر': 12,
    };
    for (final entry in months.entries) {
      if (!q.contains(entry.key)) continue;
      final match = RegExp(r'\b(20\d{2})\b').firstMatch(q);
      return DateTime(
        int.tryParse(match?.group(1) ?? '') ?? DateTime.now().year,
        entry.value,
        1,
      );
    }
    return null;
  }
}
