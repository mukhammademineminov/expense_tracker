import 'package:expense_tracker/data/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:intl/intl.dart';

class StatsScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const StatsScreen({required this.transactions, super.key});

  double _categoryTotal(Category category) {
    return transactions
        .where((t) => t.category == category.name && !t.isIncome)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  List<Transaction> _last7Days() {
    final now = DateTime.now();
    final week = now.subtract(Duration(days: 7));
    return transactions
        .where((t) => !t.isIncome && formatter.parse(t.date).isAfter(week))
        .toList();
  }

  List<BarChartGroupData> _last7DaysData() {
    return List.generate(7, (index) {
      final day = DateTime.now().subtract(Duration(days: 6 - index));
      final total = _last7Days()
          .where((t) => formatter.parse(t.date).day == day.day)
          .fold<double>(0.0, (sum, t) => sum + t.amount);
      return BarChartGroupData(
        x: index,
        barRods: [BarChartRodData(toY: total)],
      );
    });
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

              Container(
                height: 350,
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  //color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
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
              Text(
                'Spending over time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              Container(
                height: 350,
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  //color: Colors.primaries[0].shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final day = DateTime.now().subtract(
                              Duration(days: 6 - value.toInt()),
                            );
                            return Text(DateFormat('EEE').format(day));
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    alignment: BarChartAlignment.spaceAround,
                    maxY:
                        _last7DaysData()
                            .map((g) => g.barRods.first.toY)
                            .reduce(max) + 100,
                    barGroups: [
                      for (var group in _last7DaysData())
                        BarChartGroupData(x: group.x, barRods: group.barRods),
                    ],
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
