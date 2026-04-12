import 'package:expense_tracker/data/models/transaction.dart';
import 'package:expense_tracker/screens/add_expense_view.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:expense_tracker/screens/pdf_service.dart';
import 'package:expense_tracker/data/models/calculation.dart';

class HomeScreen extends StatefulWidget {
  final Isar isar;
  final Function onTransactionAdded;

  const HomeScreen({super.key, required this.isar, required this.onTransactionAdded});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //Add expense bottom sheet
  void _showBotttomSheetPressed() async {
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

      await widget.isar.writeTxn(() async {
        await widget.isar.transactions.put(transaction);
      });

      _loadTransactions();
    }
  }

  List<Transaction> transactions = [];
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  //Loads transactions from isar database
  void _loadTransactions() async {
    final result = await widget.isar.transactions.where().findAll();
    setState(() => transactions = result);
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalBalance(transactions);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showBotttomSheetPressed,
        child: Icon(Icons.add),
      ),

      appBar: AppBar(
        title: Text('Expense Tracker',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        )),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () => PdfService.generateReport(transactions),
          ),
        ],
      ),
      body: ListView(
        children: [
          
          //Balance Card
           Card(
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Balance'),
                      subtitle: Text('\$${balance[2]}'),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Income'),
                      subtitle: Text('\$${balance[0]}'),
                      trailing: Icon(
                        Icons.arrow_upward,
                        color: Colors.greenAccent,

                      ),
                      
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Expense'),
                      subtitle: Text('\$${balance[1]}'),
                      trailing: Icon(
                        Icons.arrow_downward,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
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
                await widget.isar.writeTxn(() async {
                  await widget.isar.transactions.delete(transation.id);
                });
                _loadTransactions();
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
