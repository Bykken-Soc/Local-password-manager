// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $DbpasswordTable extends Dbpassword
    with TableInfo<$DbpasswordTable, DbpasswordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbpasswordTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userkeyMeta = const VerificationMeta(
    'userkey',
  );
  @override
  late final GeneratedColumn<String> userkey = GeneratedColumn<String>(
    'userkey',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteMeta = const VerificationMeta('site');
  @override
  late final GeneratedColumn<String> site = GeneratedColumn<String>(
    'site',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _CategoryMeta = const VerificationMeta(
    'Category',
  );
  @override
  late final GeneratedColumn<String> Category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userkey, password, site, Category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dbpassword';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbpasswordData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('userkey')) {
      context.handle(
        _userkeyMeta,
        userkey.isAcceptableOrUnknown(data['userkey']!, _userkeyMeta),
      );
    } else if (isInserting) {
      context.missing(_userkeyMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('site')) {
      context.handle(
        _siteMeta,
        site.isAcceptableOrUnknown(data['site']!, _siteMeta),
      );
    } else if (isInserting) {
      context.missing(_siteMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _CategoryMeta,
        Category.isAcceptableOrUnknown(data['category']!, _CategoryMeta),
      );
    } else if (isInserting) {
      context.missing(_CategoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbpasswordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbpasswordData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userkey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}userkey'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      site: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site'],
      )!,
      Category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $DbpasswordTable createAlias(String alias) {
    return $DbpasswordTable(attachedDatabase, alias);
  }
}

class DbpasswordData extends DataClass implements Insertable<DbpasswordData> {
  final int id;
  final String userkey;
  final String password;
  final String site;
  final String Category;
  const DbpasswordData({
    required this.id,
    required this.userkey,
    required this.password,
    required this.site,
    required this.Category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['userkey'] = Variable<String>(userkey);
    map['password'] = Variable<String>(password);
    map['site'] = Variable<String>(site);
    map['category'] = Variable<String>(Category);
    return map;
  }

  DbpasswordCompanion toCompanion(bool nullToAbsent) {
    return DbpasswordCompanion(
      id: Value(id),
      userkey: Value(userkey),
      password: Value(password),
      site: Value(site),
      Category: Value(Category),
    );
  }

  factory DbpasswordData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbpasswordData(
      id: serializer.fromJson<int>(json['id']),
      userkey: serializer.fromJson<String>(json['userkey']),
      password: serializer.fromJson<String>(json['password']),
      site: serializer.fromJson<String>(json['site']),
      Category: serializer.fromJson<String>(json['Category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userkey': serializer.toJson<String>(userkey),
      'password': serializer.toJson<String>(password),
      'site': serializer.toJson<String>(site),
      'Category': serializer.toJson<String>(Category),
    };
  }

  DbpasswordData copyWith({
    int? id,
    String? userkey,
    String? password,
    String? site,
    String? Category,
  }) => DbpasswordData(
    id: id ?? this.id,
    userkey: userkey ?? this.userkey,
    password: password ?? this.password,
    site: site ?? this.site,
    Category: Category ?? this.Category,
  );
  DbpasswordData copyWithCompanion(DbpasswordCompanion data) {
    return DbpasswordData(
      id: data.id.present ? data.id.value : this.id,
      userkey: data.userkey.present ? data.userkey.value : this.userkey,
      password: data.password.present ? data.password.value : this.password,
      site: data.site.present ? data.site.value : this.site,
      Category: data.Category.present ? data.Category.value : this.Category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbpasswordData(')
          ..write('id: $id, ')
          ..write('userkey: $userkey, ')
          ..write('password: $password, ')
          ..write('site: $site, ')
          ..write('Category: $Category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userkey, password, site, Category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbpasswordData &&
          other.id == this.id &&
          other.userkey == this.userkey &&
          other.password == this.password &&
          other.site == this.site &&
          other.Category == this.Category);
}

class DbpasswordCompanion extends UpdateCompanion<DbpasswordData> {
  final Value<int> id;
  final Value<String> userkey;
  final Value<String> password;
  final Value<String> site;
  final Value<String> Category;
  const DbpasswordCompanion({
    this.id = const Value.absent(),
    this.userkey = const Value.absent(),
    this.password = const Value.absent(),
    this.site = const Value.absent(),
    this.Category = const Value.absent(),
  });
  DbpasswordCompanion.insert({
    this.id = const Value.absent(),
    required String userkey,
    required String password,
    required String site,
    required String Category,
  }) : userkey = Value(userkey),
       password = Value(password),
       site = Value(site),
       Category = Value(Category);
  static Insertable<DbpasswordData> custom({
    Expression<int>? id,
    Expression<String>? userkey,
    Expression<String>? password,
    Expression<String>? site,
    Expression<String>? Category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userkey != null) 'userkey': userkey,
      if (password != null) 'password': password,
      if (site != null) 'site': site,
      if (Category != null) 'category': Category,
    });
  }

  DbpasswordCompanion copyWith({
    Value<int>? id,
    Value<String>? userkey,
    Value<String>? password,
    Value<String>? site,
    Value<String>? Category,
  }) {
    return DbpasswordCompanion(
      id: id ?? this.id,
      userkey: userkey ?? this.userkey,
      password: password ?? this.password,
      site: site ?? this.site,
      Category: Category ?? this.Category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userkey.present) {
      map['userkey'] = Variable<String>(userkey.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (site.present) {
      map['site'] = Variable<String>(site.value);
    }
    if (Category.present) {
      map['category'] = Variable<String>(Category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbpasswordCompanion(')
          ..write('id: $id, ')
          ..write('userkey: $userkey, ')
          ..write('password: $password, ')
          ..write('site: $site, ')
          ..write('Category: $Category')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DbpasswordTable dbpassword = $DbpasswordTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dbpassword];
}

typedef $$DbpasswordTableCreateCompanionBuilder =
    DbpasswordCompanion Function({
      Value<int> id,
      required String userkey,
      required String password,
      required String site,
      required String Category,
    });
typedef $$DbpasswordTableUpdateCompanionBuilder =
    DbpasswordCompanion Function({
      Value<int> id,
      Value<String> userkey,
      Value<String> password,
      Value<String> site,
      Value<String> Category,
    });

class $$DbpasswordTableFilterComposer
    extends Composer<_$AppDatabase, $DbpasswordTable> {
  $$DbpasswordTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userkey => $composableBuilder(
    column: $table.userkey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get site => $composableBuilder(
    column: $table.site,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get Category => $composableBuilder(
    column: $table.Category,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DbpasswordTableOrderingComposer
    extends Composer<_$AppDatabase, $DbpasswordTable> {
  $$DbpasswordTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userkey => $composableBuilder(
    column: $table.userkey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get site => $composableBuilder(
    column: $table.site,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get Category => $composableBuilder(
    column: $table.Category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbpasswordTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbpasswordTable> {
  $$DbpasswordTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userkey =>
      $composableBuilder(column: $table.userkey, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get site =>
      $composableBuilder(column: $table.site, builder: (column) => column);

  GeneratedColumn<String> get Category =>
      $composableBuilder(column: $table.Category, builder: (column) => column);
}

class $$DbpasswordTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DbpasswordTable,
          DbpasswordData,
          $$DbpasswordTableFilterComposer,
          $$DbpasswordTableOrderingComposer,
          $$DbpasswordTableAnnotationComposer,
          $$DbpasswordTableCreateCompanionBuilder,
          $$DbpasswordTableUpdateCompanionBuilder,
          (
            DbpasswordData,
            BaseReferences<_$AppDatabase, $DbpasswordTable, DbpasswordData>,
          ),
          DbpasswordData,
          PrefetchHooks Function()
        > {
  $$DbpasswordTableTableManager(_$AppDatabase db, $DbpasswordTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbpasswordTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbpasswordTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbpasswordTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userkey = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> site = const Value.absent(),
                Value<String> Category = const Value.absent(),
              }) => DbpasswordCompanion(
                id: id,
                userkey: userkey,
                password: password,
                site: site,
                Category: Category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userkey,
                required String password,
                required String site,
                required String Category,
              }) => DbpasswordCompanion.insert(
                id: id,
                userkey: userkey,
                password: password,
                site: site,
                Category: Category,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbpasswordTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DbpasswordTable,
      DbpasswordData,
      $$DbpasswordTableFilterComposer,
      $$DbpasswordTableOrderingComposer,
      $$DbpasswordTableAnnotationComposer,
      $$DbpasswordTableCreateCompanionBuilder,
      $$DbpasswordTableUpdateCompanionBuilder,
      (
        DbpasswordData,
        BaseReferences<_$AppDatabase, $DbpasswordTable, DbpasswordData>,
      ),
      DbpasswordData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DbpasswordTableTableManager get dbpassword =>
      $$DbpasswordTableTableManager(_db, _db.dbpassword);
}
