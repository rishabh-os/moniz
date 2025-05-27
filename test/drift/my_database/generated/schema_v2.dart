// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class TransactionTable extends Table
    with TableInfo<TransactionTable, TransactionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TransactionTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> additionalInfo = GeneratedColumn<String>(
      'additional_info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> categoryID = GeneratedColumn<String>(
      'category_i_d', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> accountID = GeneratedColumn<String>(
      'account_i_d', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> recorded = GeneratedColumn<DateTime>(
      'recorded', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        additionalInfo,
        categoryID,
        accountID,
        amount,
        recorded,
        location
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_table';
  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TransactionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      additionalInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}additional_info']),
      categoryID: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_i_d'])!,
      accountID: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_i_d'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      recorded: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
    );
  }

  @override
  TransactionTable createAlias(String alias) {
    return TransactionTable(attachedDatabase, alias);
  }
}

class TransactionTableData extends DataClass
    implements Insertable<TransactionTableData> {
  final String id;
  final String title;
  final String? additionalInfo;
  final String categoryID;
  final String accountID;
  final int amount;
  final DateTime recorded;
  final String? location;
  const TransactionTableData(
      {required this.id,
      required this.title,
      this.additionalInfo,
      required this.categoryID,
      required this.accountID,
      required this.amount,
      required this.recorded,
      this.location});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || additionalInfo != null) {
      map['additional_info'] = Variable<String>(additionalInfo);
    }
    map['category_i_d'] = Variable<String>(categoryID);
    map['account_i_d'] = Variable<String>(accountID);
    map['amount'] = Variable<int>(amount);
    map['recorded'] = Variable<DateTime>(recorded);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    return map;
  }

  TransactionTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionTableCompanion(
      id: Value(id),
      title: Value(title),
      additionalInfo: additionalInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalInfo),
      categoryID: Value(categoryID),
      accountID: Value(accountID),
      amount: Value(amount),
      recorded: Value(recorded),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
    );
  }

  factory TransactionTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      additionalInfo: serializer.fromJson<String?>(json['additionalInfo']),
      categoryID: serializer.fromJson<String>(json['categoryID']),
      accountID: serializer.fromJson<String>(json['accountID']),
      amount: serializer.fromJson<int>(json['amount']),
      recorded: serializer.fromJson<DateTime>(json['recorded']),
      location: serializer.fromJson<String?>(json['location']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'additionalInfo': serializer.toJson<String?>(additionalInfo),
      'categoryID': serializer.toJson<String>(categoryID),
      'accountID': serializer.toJson<String>(accountID),
      'amount': serializer.toJson<int>(amount),
      'recorded': serializer.toJson<DateTime>(recorded),
      'location': serializer.toJson<String?>(location),
    };
  }

  TransactionTableData copyWith(
          {String? id,
          String? title,
          Value<String?> additionalInfo = const Value.absent(),
          String? categoryID,
          String? accountID,
          int? amount,
          DateTime? recorded,
          Value<String?> location = const Value.absent()}) =>
      TransactionTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        additionalInfo:
            additionalInfo.present ? additionalInfo.value : this.additionalInfo,
        categoryID: categoryID ?? this.categoryID,
        accountID: accountID ?? this.accountID,
        amount: amount ?? this.amount,
        recorded: recorded ?? this.recorded,
        location: location.present ? location.value : this.location,
      );
  TransactionTableData copyWithCompanion(TransactionTableCompanion data) {
    return TransactionTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      additionalInfo: data.additionalInfo.present
          ? data.additionalInfo.value
          : this.additionalInfo,
      categoryID:
          data.categoryID.present ? data.categoryID.value : this.categoryID,
      accountID: data.accountID.present ? data.accountID.value : this.accountID,
      amount: data.amount.present ? data.amount.value : this.amount,
      recorded: data.recorded.present ? data.recorded.value : this.recorded,
      location: data.location.present ? data.location.value : this.location,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('categoryID: $categoryID, ')
          ..write('accountID: $accountID, ')
          ..write('amount: $amount, ')
          ..write('recorded: $recorded, ')
          ..write('location: $location')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, additionalInfo, categoryID,
      accountID, amount, recorded, location);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.additionalInfo == this.additionalInfo &&
          other.categoryID == this.categoryID &&
          other.accountID == this.accountID &&
          other.amount == this.amount &&
          other.recorded == this.recorded &&
          other.location == this.location);
}

class TransactionTableCompanion extends UpdateCompanion<TransactionTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> additionalInfo;
  final Value<String> categoryID;
  final Value<String> accountID;
  final Value<int> amount;
  final Value<DateTime> recorded;
  final Value<String?> location;
  final Value<int> rowid;
  const TransactionTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.categoryID = const Value.absent(),
    this.accountID = const Value.absent(),
    this.amount = const Value.absent(),
    this.recorded = const Value.absent(),
    this.location = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionTableCompanion.insert({
    required String id,
    required String title,
    this.additionalInfo = const Value.absent(),
    required String categoryID,
    required String accountID,
    required int amount,
    required DateTime recorded,
    this.location = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        categoryID = Value(categoryID),
        accountID = Value(accountID),
        amount = Value(amount),
        recorded = Value(recorded);
  static Insertable<TransactionTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? additionalInfo,
    Expression<String>? categoryID,
    Expression<String>? accountID,
    Expression<int>? amount,
    Expression<DateTime>? recorded,
    Expression<String>? location,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (additionalInfo != null) 'additional_info': additionalInfo,
      if (categoryID != null) 'category_i_d': categoryID,
      if (accountID != null) 'account_i_d': accountID,
      if (amount != null) 'amount': amount,
      if (recorded != null) 'recorded': recorded,
      if (location != null) 'location': location,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? additionalInfo,
      Value<String>? categoryID,
      Value<String>? accountID,
      Value<int>? amount,
      Value<DateTime>? recorded,
      Value<String?>? location,
      Value<int>? rowid}) {
    return TransactionTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      categoryID: categoryID ?? this.categoryID,
      accountID: accountID ?? this.accountID,
      amount: amount ?? this.amount,
      recorded: recorded ?? this.recorded,
      location: location ?? this.location,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (additionalInfo.present) {
      map['additional_info'] = Variable<String>(additionalInfo.value);
    }
    if (categoryID.present) {
      map['category_i_d'] = Variable<String>(categoryID.value);
    }
    if (accountID.present) {
      map['account_i_d'] = Variable<String>(accountID.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (recorded.present) {
      map['recorded'] = Variable<DateTime>(recorded.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('categoryID: $categoryID, ')
          ..write('accountID: $accountID, ')
          ..write('amount: $amount, ')
          ..write('recorded: $recorded, ')
          ..write('location: $location, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class CategoriesTable extends Table
    with TableInfo<CategoriesTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CategoriesTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> iconCodepoint = GeneratedColumn<int>(
      'icon_codepoint', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_archived" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, iconCodepoint, color, order, isArchived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iconCodepoint: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_codepoint'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
    );
  }

  @override
  CategoriesTable createAlias(String alias) {
    return CategoriesTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final String id;
  final String name;
  final int iconCodepoint;
  final int color;
  final int order;
  final bool isArchived;
  const CategoriesTableData(
      {required this.id,
      required this.name,
      required this.iconCodepoint,
      required this.color,
      required this.order,
      required this.isArchived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon_codepoint'] = Variable<int>(iconCodepoint);
    map['color'] = Variable<int>(color);
    map['order'] = Variable<int>(order);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      iconCodepoint: Value(iconCodepoint),
      color: Value(color),
      order: Value(order),
      isArchived: Value(isArchived),
    );
  }

  factory CategoriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconCodepoint: serializer.fromJson<int>(json['iconCodepoint']),
      color: serializer.fromJson<int>(json['color']),
      order: serializer.fromJson<int>(json['order']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'iconCodepoint': serializer.toJson<int>(iconCodepoint),
      'color': serializer.toJson<int>(color),
      'order': serializer.toJson<int>(order),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  CategoriesTableData copyWith(
          {String? id,
          String? name,
          int? iconCodepoint,
          int? color,
          int? order,
          bool? isArchived}) =>
      CategoriesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        iconCodepoint: iconCodepoint ?? this.iconCodepoint,
        color: color ?? this.color,
        order: order ?? this.order,
        isArchived: isArchived ?? this.isArchived,
      );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconCodepoint: data.iconCodepoint.present
          ? data.iconCodepoint.value
          : this.iconCodepoint,
      color: data.color.present ? data.color.value : this.color,
      order: data.order.present ? data.order.value : this.order,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCodepoint: $iconCodepoint, ')
          ..write('color: $color, ')
          ..write('order: $order, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, iconCodepoint, color, order, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconCodepoint == this.iconCodepoint &&
          other.color == this.color &&
          other.order == this.order &&
          other.isArchived == this.isArchived);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> iconCodepoint;
  final Value<int> color;
  final Value<int> order;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconCodepoint = const Value.absent(),
    this.color = const Value.absent(),
    this.order = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    required int iconCodepoint,
    required int color,
    required int order,
    required bool isArchived,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        iconCodepoint = Value(iconCodepoint),
        color = Value(color),
        order = Value(order),
        isArchived = Value(isArchived);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? iconCodepoint,
    Expression<int>? color,
    Expression<int>? order,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconCodepoint != null) 'icon_codepoint': iconCodepoint,
      if (color != null) 'color': color,
      if (order != null) 'order': order,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? iconCodepoint,
      Value<int>? color,
      Value<int>? order,
      Value<bool>? isArchived,
      Value<int>? rowid}) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodepoint: iconCodepoint ?? this.iconCodepoint,
      color: color ?? this.color,
      order: order ?? this.order,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconCodepoint.present) {
      map['icon_codepoint'] = Variable<int>(iconCodepoint.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCodepoint: $iconCodepoint, ')
          ..write('color: $color, ')
          ..write('order: $order, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AccountsTable extends Table
    with TableInfo<AccountsTable, AccountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AccountsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> iconCodepoint = GeneratedColumn<int>(
      'icon_codepoint', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> balance = GeneratedColumn<int>(
      'balance', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_archived" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, iconCodepoint, color, balance, order, isArchived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts_table';
  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AccountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iconCodepoint: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_codepoint'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}balance'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
    );
  }

  @override
  AccountsTable createAlias(String alias) {
    return AccountsTable(attachedDatabase, alias);
  }
}

class AccountsTableData extends DataClass
    implements Insertable<AccountsTableData> {
  final String id;
  final String name;
  final int iconCodepoint;
  final int color;
  final int balance;
  final int order;
  final bool isArchived;
  const AccountsTableData(
      {required this.id,
      required this.name,
      required this.iconCodepoint,
      required this.color,
      required this.balance,
      required this.order,
      required this.isArchived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon_codepoint'] = Variable<int>(iconCodepoint);
    map['color'] = Variable<int>(color);
    map['balance'] = Variable<int>(balance);
    map['order'] = Variable<int>(order);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      id: Value(id),
      name: Value(name),
      iconCodepoint: Value(iconCodepoint),
      color: Value(color),
      balance: Value(balance),
      order: Value(order),
      isArchived: Value(isArchived),
    );
  }

  factory AccountsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconCodepoint: serializer.fromJson<int>(json['iconCodepoint']),
      color: serializer.fromJson<int>(json['color']),
      balance: serializer.fromJson<int>(json['balance']),
      order: serializer.fromJson<int>(json['order']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'iconCodepoint': serializer.toJson<int>(iconCodepoint),
      'color': serializer.toJson<int>(color),
      'balance': serializer.toJson<int>(balance),
      'order': serializer.toJson<int>(order),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  AccountsTableData copyWith(
          {String? id,
          String? name,
          int? iconCodepoint,
          int? color,
          int? balance,
          int? order,
          bool? isArchived}) =>
      AccountsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        iconCodepoint: iconCodepoint ?? this.iconCodepoint,
        color: color ?? this.color,
        balance: balance ?? this.balance,
        order: order ?? this.order,
        isArchived: isArchived ?? this.isArchived,
      );
  AccountsTableData copyWithCompanion(AccountsTableCompanion data) {
    return AccountsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconCodepoint: data.iconCodepoint.present
          ? data.iconCodepoint.value
          : this.iconCodepoint,
      color: data.color.present ? data.color.value : this.color,
      balance: data.balance.present ? data.balance.value : this.balance,
      order: data.order.present ? data.order.value : this.order,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCodepoint: $iconCodepoint, ')
          ..write('color: $color, ')
          ..write('balance: $balance, ')
          ..write('order: $order, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, iconCodepoint, color, balance, order, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconCodepoint == this.iconCodepoint &&
          other.color == this.color &&
          other.balance == this.balance &&
          other.order == this.order &&
          other.isArchived == this.isArchived);
}

class AccountsTableCompanion extends UpdateCompanion<AccountsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> iconCodepoint;
  final Value<int> color;
  final Value<int> balance;
  final Value<int> order;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const AccountsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconCodepoint = const Value.absent(),
    this.color = const Value.absent(),
    this.balance = const Value.absent(),
    this.order = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    required String id,
    required String name,
    required int iconCodepoint,
    required int color,
    required int balance,
    required int order,
    required bool isArchived,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        iconCodepoint = Value(iconCodepoint),
        color = Value(color),
        balance = Value(balance),
        order = Value(order),
        isArchived = Value(isArchived);
  static Insertable<AccountsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? iconCodepoint,
    Expression<int>? color,
    Expression<int>? balance,
    Expression<int>? order,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconCodepoint != null) 'icon_codepoint': iconCodepoint,
      if (color != null) 'color': color,
      if (balance != null) 'balance': balance,
      if (order != null) 'order': order,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? iconCodepoint,
      Value<int>? color,
      Value<int>? balance,
      Value<int>? order,
      Value<bool>? isArchived,
      Value<int>? rowid}) {
    return AccountsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodepoint: iconCodepoint ?? this.iconCodepoint,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      order: order ?? this.order,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconCodepoint.present) {
      map['icon_codepoint'] = Variable<int>(iconCodepoint.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (balance.present) {
      map['balance'] = Variable<int>(balance.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCodepoint: $iconCodepoint, ')
          ..write('color: $color, ')
          ..write('balance: $balance, ')
          ..write('order: $order, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final TransactionTable transactionTable = TransactionTable(this);
  late final CategoriesTable categoriesTable = CategoriesTable(this);
  late final AccountsTable accountsTable = AccountsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [transactionTable, categoriesTable, accountsTable];
  @override
  int get schemaVersion => 2;
}
