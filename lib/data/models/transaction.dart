
import 'package:isar/isar.dart';
part 'transaction.g.dart';


enum Category {
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
  late DateTime date;
}
