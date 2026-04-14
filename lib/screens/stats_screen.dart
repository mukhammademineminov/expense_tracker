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

              Container(
                height: 300,
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
                          title:
                              '${(_categoryTotal(category) * 100 / transactions
                                .fold<double>(0.0, (sum, t) => sum + (t.isIncome ? 0 : t.amount))).toStringAsFixed(2)}%',
                          radius: 80,
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                    ],
                    centerSpaceRadius: 50,
                  ),
                ),
              ),

              //pie chart legend
              for (var category in Category.values)
                if (_categoryTotal(category) > 0.0)
                  Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.primaries[category.index],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                      Text(
                        category.name[0].toUpperCase() +
                            category.name.substring(1),
                      ),
                      SizedBox(width: 10),
                      Text('\$${_categoryTotal(category).toStringAsFixed(2)}'),
                    ],
                  ),
              SizedBox(height: 20),

              //Spending over time bar chart
              Text(
                'Last 7 Days Spending',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              Container(
                height: 260,
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  //color: Colors.primaries[0].shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            final day = DateTime.now().subtract(
                              Duration(days: 6 - value.toInt()),
                            );
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 12,
                              child: Text(DateFormat('EEE').format(day)),
                            );
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

                    // Style bars
                    barGroups: [
                      for (var group in _last7DaysData())
                        BarChartGroupData(
                          x: group.x,
                          barRods: group.barRods.map((rod) {
                            return rod.copyWith(
                              width: 20,
                              borderRadius: BorderRadius.circular(6),
                            );
                          }).toList(),
                        ),
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
