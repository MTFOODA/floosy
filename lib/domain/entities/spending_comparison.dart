class SpendingComparison {
  final int month1Spending;
  final int month2Spending;
  final int difference;
  final double percentageChange;
  final bool isIncreased;

  SpendingComparison({
    required this.month1Spending,
    required this.month2Spending,
    required this.difference,
    required this.percentageChange,
    required this.isIncreased,
  });
}
