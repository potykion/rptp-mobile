import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'models.dart';

part 'db.g.dart';

@DataClassName("DbActress")
class DbActresses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  TextColumn get ptgId => text().withLength(min: 1, max: 60)();
  TextColumn get ptgLink => text().withLength(min: 1, max: 400)();
  TextColumn get ptgThumbnail => text().withLength(min: 1, max: 400)();
}

LazyDatabase _openConnection() => LazyDatabase(
      () async {
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'db.sqlite'));
        return VmDatabase(file);
      },
    );

@UseMoor(tables: [DbActresses])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> bulkInsert(List<DbActressesCompanion> actresses) async =>
      await batch((batch) => batch.insertAll(dbActresses, actresses));

  Future<List<DbActress>> get list => select(dbActresses).get();

  String get dbActressesTable => $DbActressesTable(null).actualTableName;

  Future<DbActress> get getRandom async {
    var query =
        "SELECT * FROM ${dbActressesTable} WHERE id IN (SELECT id FROM ${dbActressesTable} ORDER BY RANDOM() LIMIT 1)";
    var row = await customSelect(query).getSingle();
    return DbActress.fromData(row.data, this);
  }
}

class ActressRepo {
  final MyDatabase db;

  ActressRepo(this.db);

  bulkInsert(List<Actress> actresses) async => await db.bulkInsert(
        actresses.map((actress) => _actressToInsertCompanion(actress)).toList(),
      );

  Future<List<Actress>> list() async =>
      (await db.list).map((actress) => _dbActressToActress(actress)).toList();

  Future<Actress> getRandom() async => _dbActressToActress(await db.getRandom);

  DbActressesCompanion _actressToInsertCompanion(Actress actress) =>
      DbActressesCompanion.insert(
        name: actress.name,
        ptgId: actress.ptgId,
        ptgLink: actress.ptgLink,
        ptgThumbnail: actress.ptgThumbnail,
      );

  Actress _dbActressToActress(DbActress actress) => Actress(
      name: actress.name,
      ptgId: actress.ptgId,
      ptgLink: actress.ptgLink,
      ptgThumbnail: actress.ptgThumbnail);
}
