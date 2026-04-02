import 'add_expense_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showBotttomSheetPressed() async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (ctx) => AddExpenseView(
        onInvalidAmount: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Invalid Amount')));
        },
      ),
    );
    if (result != null) {
      setState(() => transactions.add(result));
    }
  }
  
  final List<Map<String, dynamic>> transactions = [
    {'title': 'Salary', 'amount': 5000.0, 'isInCome': true},
    {'title': 'Groceries', 'amount': 200.0, 'isInCome': false},
    {'title': 'Rent', 'amount': 1000.0, 'isInCome': false},
    {'title': 'Shopping', 'amount': 50.0, 'isInCome': false},
  ];

  totalBalance() {
    double total = 0;
    double totalIncome = 0;
    double totalExpense = 0;

    //total income
    totalIncome = transactions
        .where((t) => t['isInCome'] == true)
        .fold(0.0, (sum, t) => sum + t['amount']);
    //total expense
    totalExpense = transactions
        .where((t) => t['isInCome'] == false)
        .fold(0.0, (sum, t) => sum + t['amount']);

    total = totalIncome - totalExpense;
    return [totalIncome, totalExpense, total];
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalBalance();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showBotttomSheetPressed,
        child: Icon(Icons.add),
      ),

      appBar: AppBar(title: Text('Expense Tracker')),
      body: ListView(
        children: [
          (Card(
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Balance'),
                    subtitle: Text('\$' + balance[2].toString()),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Income'),
                    subtitle: Text('\$' + balance[0].toString()),
                    trailing: Icon(Icons.arrow_upward,
                    color: Colors.greenAccent,),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Expense'),
                    subtitle: Text('\$' + balance[1].toString()),
                    trailing: Icon(Icons.arrow_downward,
                    color: Colors.redAccent,),
                  ),
                ),
              ],
            ),
          )),

          for (var transation in transactions)
            (Card(
              child: ListTile(
                title: Text(transation['title']),
                subtitle: Text('\$' + transation['amount'].toString()),
                trailing: Icon(
                  transation['isInCome']
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: transation['isInCome']
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
              ),
            )),
        ],
      ),
    );
  }
}
