import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/data/models/transaction.dart';
import 'package:expense_tracker/data/models/calculation.dart';
import 'package:expense_tracker/data/models/transaction_period.dart';

import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/providers/transaction_period_provider.dart';

import 'package:expense_tracker/screens/add_expense_view.dart';

import 'package:expense_tracker/widgets/balance_card.dart';
import 'package:expense_tracker/widgets/transaction_card.dart';
import 'package:expense_tracker/widgets/popup_menu.dart';

import 'package:expense_tracker/services/pdf_service.dart';


class HomeScreen extends ConsumerStatefulWidget {
  final Function? onTransactionAdded;

  const HomeScreen({super.key, this.onTransactionAdded});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  //String _dayPeriod = 'All Time';
  //Add expense bottom sheet
  void _showBotttomSheetPressed(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => AddExpenseView(
        onInvalidAmount: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Invalid Amount')));
        },
      ),
    );
    if (result != null) {
      final transaction = Transaction()
        ..title = result['title']
        ..amount = result['amount']
        ..isIncome = result['isIncome']
        ..category = result['category']
        ..date = DateTime.now();

      await ref.read(transactionProvider.notifier).addTransaction(transaction);
      widget.onTransactionAdded?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider).toList();
    final calculated = BalanceSummary.fromTransactions(transactions);
    final allTranactions = ref.read(transactionProvider.notifier).allTransactions;
    final globalBalance = BalanceSummary.fromTransactions(allTranactions);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBotttomSheetPressed(context, ref),
        child: Icon(Icons.add),
      ),

      appBar: AppBar(
        title: Text(
          'Expense Tracker',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () => PdfService.generateReport(transactions),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        children: [
          // filter transactions by date
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenu(
                  items: TransactionPeriod.values
                      .map((period) => PopupMenuItem(
                            value: period,
                            child: Text(period.label),
                          ))
                      .toList(),
                  onSelected: (value) {
                    // state update
                    ref.read(dayPeriodProvider.notifier).state = value;
                    // filter transactions
                    ref.read(transactionProvider.notifier)
                        .loadTransactions(filterDays: value.days);
                  },
                  child: Consumer(
                    builder: (context, ref, _) {
                      final period = ref.watch(dayPeriodProvider);

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(period.label, style: TextStyle(fontSize: 14)),
                          Icon(Icons.arrow_drop_down, size: 20),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          //Balance Card
          BalanceCard(
            total: globalBalance.balance,
            income: calculated.income,
            expense: calculated.expense,
          ),

          //Transactions List
          for (var transaction in transactions)
            //Swipe Right to left to delete
            Dismissible(
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              key: ValueKey(transaction.id),
              onDismissed: (direction) async {
                await ref
                    .read(transactionProvider.notifier)
                    .deleteTransaction(transaction);
              },
              //Transaction Card
              child: TransactionCard(transaction: transaction),
            ),
        ],
      ),
    );
  }
}
