import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../data/models/transaction.dart';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final Isar isar;
  
  TransactionNotifier(this.isar) : super([]) {
    loadTransactions();
  }
  
  Future<void> loadTransactions() async {
    try {
    final result = await isar.transactions.where().findAll();
    state = result;
    } catch (e) {
      debugPrint('Error loading transactions: $e');
     
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
    await isar.writeTxn(() async {
        await isar.transactions.put(transaction);
      });

      loadTransactions();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
    }
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    try {
    await isar.writeTxn(() async {
        await isar.transactions.delete(transaction.id);
      });

      loadTransactions();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
    }
  }
}
final isarProvider = Provider<Isar>((ref) => throw UnimplementedError());

final transactionProvider = StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  final isar = ref.watch(isarProvider);
  return TransactionNotifier(isar);
});


  