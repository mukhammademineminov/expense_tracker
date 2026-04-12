import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/stats_screen.dart';
import 'package:isar/isar.dart';
import 'package:expense_tracker/data/models/transaction.dart';

class MainScreen extends StatefulWidget {
  final Isar isar;
  const MainScreen({super.key, required this.isar});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    final result = await widget.isar.transactions.where().findAll();
    setState(() => _transactions = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(isar: widget.isar,
          onTransactionAdded: _loadTransactions,),
          StatsScreen(transactions: _transactions),
        ],
      ),
      bottomNavigationBar: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        gap:20,
        tabs: [
          
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.pie_chart,
            text: 'Stats',
          ),
        ],
        
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
      
  
    );
  }
}