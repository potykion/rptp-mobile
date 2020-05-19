import 'package:moor/moor.dart';

class DbActresses extends Table {
  IntColumn get id => integer().autoIncrement()();
}
