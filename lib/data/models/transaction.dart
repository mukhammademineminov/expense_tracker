import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
part 'transaction.g.dart';

final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');

enum Category {
  income,
  bills,
  food,
  transport,
  shopping,
  health,
  education,
  entertainment,
  other,
}

@collection
class Transaction {
  Id id = Isar.autoIncrement;
  late String title;
  late double amount;
  late bool isIncome;
  late String category;
  late String date = formatter.format(DateTime.now());
}
