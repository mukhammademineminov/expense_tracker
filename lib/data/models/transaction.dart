import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
part 'transaction.g.dart';
final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');

@collection
class Transaction {
  Id id = Isar.autoIncrement;
  late String title;
  late double amount;
  late bool isIncome;
  late String date = formatter.format(DateTime.now());
}