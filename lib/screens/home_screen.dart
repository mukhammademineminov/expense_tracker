import 'package:expense_tracker/data/models/transaction.dart';
import 'package:expense_tracker/screens/add_expense_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/screens/pdf_service.dart';
import 'package:expense_tracker/data/models/calculation.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';

class HomeScreen extends ConsumerWidget {
  final Function? onTransactionAdded;

  const HomeScreen({
    super.key,
    this.onTransactionAdded,
  });

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
        ..isIncome = result['isInCome']
        ..category = result['category'];

      await ref.read(transactionProvider.notifier).addTransaction(transaction);
      onTransactionAdded?.call();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final balance = totalBalance(transactions);
    
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
        children: [
          SizedBox(height: 5),

          //Balance Card
          Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Balance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${balance[2]}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(color: Colors.grey, thickness: 1, height: 1),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('Income'),
                          SizedBox(height: 5),
                          Text(
                            '\$${balance[0]}',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(height: 40, width: 0.5, color: Colors.grey),

                      Column(
                        children: [
                          Text('Expense'),
                          SizedBox(height: 5),
                          Text(
                            '\$${balance[1]}',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          for (var transation in transactions)
            //Swipe Right to left to delete
            Dismissible(
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              key: ValueKey(transation.id),
              onDismissed: (direction) async {
                await ref.read(transactionProvider.notifier).deleteTransaction(transation);
              },
              child: (Card(
                child: ListTile(
                  title: Text(transation.title),
                  subtitle: Text('\$${transation.amount}'),
                  trailing: Icon(
                    transation.isIncome
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: transation.isIncome
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),
                ),
              )),
            ),
        ],
      ),
    );
  }
}
