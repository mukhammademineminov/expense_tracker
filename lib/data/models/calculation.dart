import 'package:expense_tracker/data/models/transaction.dart';

  
class BalanceSummary {
  final double income;
  final double expense;
  final double balance;

  BalanceSummary({
    required this.income,
    required this.expense,
    required this.balance,
  });

  factory BalanceSummary.fromTransactions(List<Transaction> transactions) {
    double totalIncome = transactions
        .where((t) => t.isIncome == true)
        .fold(0.0, (sum, t) => sum + t.amount);

    double totalExpense = transactions
        .where((t) => t.isIncome == false)
        .fold(0.0, (sum, t) => sum + t.amount);

    double total = totalIncome - totalExpense;

    return BalanceSummary(
      income: totalIncome,
      expense: totalExpense,
      balance: total,
    );
  }
}