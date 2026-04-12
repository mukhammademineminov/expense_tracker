import 'package:expense_tracker/data/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const StatsScreen({required this.transactions, super.key});

  double _categoryTotal(Category category) {
    return transactions
        .where((t) => t.category == category.name && !t.isIncome)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              //pie chart
              Text(
                'Expenses by Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: [
                      for (var category in Category.values)
                        PieChartSectionData(
                          value: _categoryTotal(category),
                          color: Colors.primaries[category.index],
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              //pie chart legend
              for (var category in Category.values)
                if (_categoryTotal(category) > 0.0)
                  Row(
                    children: [
                      Icon(
                        Icons.square,
                        color: Colors.primaries[category.index],
                      ),
                      SizedBox(width: 10),
                      Text(
                        category.name[0].toUpperCase() +
                            category.name.substring(1),
                      ),
                      SizedBox(width: 10),
                      Text(_categoryTotal(category).toString()),
                    ],
                  ),
              SizedBox(height: 20),

              //Spending over time bar chart

              Text('Spending over time',
                style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Here will be the bar chart'),
              SizedBox(
                height: 300,
                
                child: BarChart(
                  BarChartData(
                    
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
