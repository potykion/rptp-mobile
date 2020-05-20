// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class DbActress extends DataClass implements Insertable<DbActress> {
  final int id;
  final String name;
  final String ptgId;
  final String ptgLink;
  final String ptgThumbnail;
  DbActress(
      {@required this.id,
      @required this.name,
      @required this.ptgId,
      @required this.ptgLink,
      @required this.ptgThumbnail});
  factory DbActress.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return DbActress(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      ptgId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}ptg_id']),
      ptgLink: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}ptg_link']),
      ptgThumbnail: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}ptg_thumbnail']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || ptgId != null) {
      map['ptg_id'] = Variable<String>(ptgId);
    }
    if (!nullToAbsent || ptgLink != null) {
      map['ptg_link'] = Variable<String>(ptgLink);
    }
    if (!nullToAbsent || ptgThumbnail != null) {
      map['ptg_thumbnail'] = Variable<String>(ptgThumbnail);
    }
    return map;
  }

  DbActressesCompanion toCompanion(bool nullToAbsent) {
    return DbActressesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      ptgId:
          ptgId == null && nullToAbsent ? const Value.absent() : Value(ptgId),
      ptgLink: ptgLink == null && nullToAbsent
          ? const Value.absent()
          : Value(ptgLink),
      ptgThumbnail: ptgThumbnail == null && nullToAbsent
          ? const Value.absent()
          : Value(ptgThumbnail),
    );
  }

  factory DbActress.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DbActress(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ptgId: serializer.fromJson<String>(json['ptgId']),
      ptgLink: serializer.fromJson<String>(json['ptgLink']),
      ptgThumbnail: serializer.fromJson<String>(json['ptgThumbnail']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ptgId': serializer.toJson<String>(ptgId),
      'ptgLink': serializer.toJson<String>(ptgLink),
      'ptgThumbnail': serializer.toJson<String>(ptgThumbnail),
    };
  }

  DbActress copyWith(
          {int id,
          String name,
          String ptgId,
          String ptgLink,
          String ptgThumbnail}) =>
      DbActress(
        id: id ?? this.id,
        name: name ?? this.name,
        ptgId: ptgId ?? this.ptgId,
        ptgLink: ptgLink ?? this.ptgLink,
        ptgThumbnail: ptgThumbnail ?? this.ptgThumbnail,
      );
  @override
  String toString() {
    return (StringBuffer('DbActress(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ptgId: $ptgId, ')
          ..write('ptgLink: $ptgLink, ')
          ..write('ptgThumbnail: $ptgThumbnail')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(ptgId.hashCode,
              $mrjc(ptgLink.hashCode, ptgThumbnail.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DbActress &&
          other.id == this.id &&
          other.name == this.name &&
          other.ptgId == this.ptgId &&
          other.ptgLink == this.ptgLink &&
          other.ptgThumbnail == this.ptgThumbnail);
}

class DbActressesCompanion extends UpdateCompanion<DbActress> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> ptgId;
  final Value<String> ptgLink;
  final Value<String> ptgThumbnail;
  const DbActressesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ptgId = const Value.absent(),
    this.ptgLink = const Value.absent(),
    this.ptgThumbnail = const Value.absent(),
  });
  DbActressesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String ptgId,
    @required String ptgLink,
    @required String ptgThumbnail,
  })  : name = Value(name),
        ptgId = Value(ptgId),
        ptgLink = Value(ptgLink),
        ptgThumbnail = Value(ptgThumbnail);
  static Insertable<DbActress> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> ptgId,
    Expression<String> ptgLink,
    Expression<String> ptgThumbnail,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ptgId != null) 'ptg_id': ptgId,
      if (ptgLink != null) 'ptg_link': ptgLink,
      if (ptgThumbnail != null) 'ptg_thumbnail': ptgThumbnail,
    });
  }

  DbActressesCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> ptgId,
      Value<String> ptgLink,
      Value<String> ptgThumbnail}) {
    return DbActressesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ptgId: ptgId ?? this.ptgId,
      ptgLink: ptgLink ?? this.ptgLink,
      ptgThumbnail: ptgThumbnail ?? this.ptgThumbnail,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ptgId.present) {
      map['ptg_id'] = Variable<String>(ptgId.value);
    }
    if (ptgLink.present) {
      map['ptg_link'] = Variable<String>(ptgLink.value);
    }
    if (ptgThumbnail.present) {
      map['ptg_thumbnail'] = Variable<String>(ptgThumbnail.value);
    }
    return map;
  }
}

class $DbActressesTable extends DbActresses
    with TableInfo<$DbActressesTable, DbActress> {
  final GeneratedDatabase _db;
  final String _alias;
  $DbActressesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 60);
  }

  final VerificationMeta _ptgIdMeta = const VerificationMeta('ptgId');
  GeneratedTextColumn _ptgId;
  @override
  GeneratedTextColumn get ptgId => _ptgId ??= _constructPtgId();
  GeneratedTextColumn _constructPtgId() {
    return GeneratedTextColumn('ptg_id', $tableName, false,
        minTextLength: 1, maxTextLength: 60);
  }

  final VerificationMeta _ptgLinkMeta = const VerificationMeta('ptgLink');
  GeneratedTextColumn _ptgLink;
  @override
  GeneratedTextColumn get ptgLink => _ptgLink ??= _constructPtgLink();
  GeneratedTextColumn _constructPtgLink() {
    return GeneratedTextColumn('ptg_link', $tableName, false,
        minTextLength: 1, maxTextLength: 400);
  }

  final VerificationMeta _ptgThumbnailMeta =
      const VerificationMeta('ptgThumbnail');
  GeneratedTextColumn _ptgThumbnail;
  @override
  GeneratedTextColumn get ptgThumbnail =>
      _ptgThumbnail ??= _constructPtgThumbnail();
  GeneratedTextColumn _constructPtgThumbnail() {
    return GeneratedTextColumn('ptg_thumbnail', $tableName, false,
        minTextLength: 1, maxTextLength: 400);
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, ptgId, ptgLink, ptgThumbnail];
  @override
  $DbActressesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'db_actresses';
  @override
  final String actualTableName = 'db_actresses';
  @override
  VerificationContext validateIntegrity(Insertable<DbActress> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ptg_id')) {
      context.handle(
          _ptgIdMeta, ptgId.isAcceptableOrUnknown(data['ptg_id'], _ptgIdMeta));
    } else if (isInserting) {
      context.missing(_ptgIdMeta);
    }
    if (data.containsKey('ptg_link')) {
      context.handle(_ptgLinkMeta,
          ptgLink.isAcceptableOrUnknown(data['ptg_link'], _ptgLinkMeta));
    } else if (isInserting) {
      context.missing(_ptgLinkMeta);
    }
    if (data.containsKey('ptg_thumbnail')) {
      context.handle(
          _ptgThumbnailMeta,
          ptgThumbnail.isAcceptableOrUnknown(
              data['ptg_thumbnail'], _ptgThumbnailMeta));
    } else if (isInserting) {
      context.missing(_ptgThumbnailMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbActress map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DbActress.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $DbActressesTable createAlias(String alias) {
    return $DbActressesTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $DbActressesTable _dbActresses;
  $DbActressesTable get dbActresses => _dbActresses ??= $DbActressesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dbActresses];
}
