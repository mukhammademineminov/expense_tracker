import 'package:isar/isar.dart';
part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;
  late String title;
  late double amount;
  late bool isIncome;
  DateTime date = DateTime.now();

}