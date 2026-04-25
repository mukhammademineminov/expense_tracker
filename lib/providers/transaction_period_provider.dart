import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/data/models/transaction_period.dart';

final dayPeriodProvider = StateProvider<TransactionPeriod>(
  (ref) => TransactionPeriod.last7Days,
);