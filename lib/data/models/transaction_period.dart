
enum TransactionPeriod {
  last7Days(7),
  last30Days(30),
  last90Days(90),
  allTime(null);

  final int? days;
  const TransactionPeriod(this.days);
}

extension DayPeriodX on TransactionPeriod {
  String get label {
    switch (this) {
      case TransactionPeriod.last7Days:
        return 'Last 7 Days';
      case TransactionPeriod.last30Days:
        return 'Last 30 Days';
      case TransactionPeriod.last90Days:
        return 'Last 90 Days';
      case TransactionPeriod.allTime:
        return 'All Time';
    }
  }
}