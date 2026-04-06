import 'package:expense_tracker/data/models/transaction.dart';


List<double> totalBalance(List<Transaction> transactions) {
    double total = 0;
    double totalIncome = 0;
    double totalExpense = 0;

    //total income
    totalIncome = transactions
        .where((t) => t.isIncome == true)
        .fold(0.0, (sum, t) => sum + t.amount);
    //total expense
    totalExpense = transactions
        .where((t) => t.isIncome == false)
        .fold(0.0, (sum, t) => sum + t.amount);

    total = totalIncome - totalExpense;
    return [totalIncome, totalExpense, total];
  }