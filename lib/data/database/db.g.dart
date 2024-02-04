// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $TransactionTableTable extends TransactionTable
    with TableInfo<$TransactionTableTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _additionalInfoMeta =
      const VerificationMeta('additionalInfo');
  @override
  late final GeneratedColumn<String> additionalInfo = GeneratedColumn<String>(
      'additional_info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIDMeta =
      const VerificationMeta('categoryID');
  @override
  late final GeneratedColumn<String> categoryID = GeneratedColumn<String>(
      'category_i_d', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIDMeta =
      const VerificationMeta('accountID');
  @override
  late final GeneratedColumn<String> accountID = GeneratedColumn<String>(
      'account_i_d', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _recordedMeta =
      const VerificationMeta('recorded');
  @override
  late final GeneratedColumn<DateTime> recorded = GeneratedColumn<DateTime>(
      'recorded', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumnWithTypeConverter<LocationFeature?, String>
      location = GeneratedColumn<String>('location', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<LocationFeature?>(
              $TransactionTableTable.$converterlocationn);
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
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('additional_info')) {
      context.handle(
          _additionalInfoMeta,
          additionalInfo.isAcceptableOrUnknown(
              data['additional_info']!, _additionalInfoMeta));
    }
    if (data.containsKey('category_i_d')) {
      context.handle(
          _categoryIDMeta,
          categoryID.isAcceptableOrUnknown(
              data['category_i_d']!, _categoryIDMeta));
    } else if (isInserting) {
      context.missing(_categoryIDMeta);
    }
    if (data.containsKey('account_i_d')) {
      context.handle(
          _accountIDMeta,
          accountID.isAcceptableOrUnknown(
              data['account_i_d']!, _accountIDMeta));
    } else if (isInserting) {
      context.missing(_accountIDMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('recorded')) {
      context.handle(_recordedMeta,
          recorded.isAcceptableOrUnknown(data['recorded']!, _recordedMeta));
    } else if (isInserting) {
      context.missing(_recordedMeta);
    }
    context.handle(_locationMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
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
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      recorded: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded'])!,
      location: $TransactionTableTable.$converterlocationn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}location'])),
    );
  }

  @override
  $TransactionTableTable createAlias(String alias) {
    return $TransactionTableTable(attachedDatabase, alias);
  }

  static TypeConverter<LocationFeature, String> $converterlocation =
      const LocationFeatureConverter();
  static TypeConverter<LocationFeature?, String?> $converterlocationn =
      NullAwareTypeConverter.wrap($converterlocation);
}

class TransactionTableCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> additionalInfo;
  final Value<String> categoryID;
  final Value<String> accountID;
  final Value<double> amount;
  final Value<DateTime> recorded;
  final Value<LocationFeature?> location;
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
    required double amount,
    required DateTime recorded,
    this.location = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        categoryID = Value(categoryID),
        accountID = Value(accountID),
        amount = Value(amount),
        recorded = Value(recorded);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? additionalInfo,
    Expression<String>? categoryID,
    Expression<String>? accountID,
    Expression<double>? amount,
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
      Value<double>? amount,
      Value<DateTime>? recorded,
      Value<LocationFeature?>? location,
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
      map['amount'] = Variable<double>(amount.value);
    }
    if (recorded.present) {
      map['recorded'] = Variable<DateTime>(recorded.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(
          $TransactionTableTable.$converterlocationn.toSql(location.value));
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

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, TransactionCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconCodepointMeta =
      const VerificationMeta('iconCodepoint');
  @override
  late final GeneratedColumn<int> iconCodepoint = GeneratedColumn<int>(
      'icon_codepoint', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
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
  VerificationContext validateIntegrity(
      Insertable<TransactionCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_codepoint')) {
      context.handle(
          _iconCodepointMeta,
          iconCodepoint.isAcceptableOrUnknown(
              data['icon_codepoint']!, _iconCodepointMeta));
    } else if (isInserting) {
      context.missing(_iconCodepointMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    } else if (isInserting) {
      context.missing(_isArchivedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TransactionCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionCategory(
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
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableCompanion extends UpdateCompanion<TransactionCategory> {
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
  static Insertable<TransactionCategory> custom({
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

class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconCodepointMeta =
      const VerificationMeta('iconCodepoint');
  @override
  late final GeneratedColumn<int> iconCodepoint = GeneratedColumn<int>(
      'icon_codepoint', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
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
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_codepoint')) {
      context.handle(
          _iconCodepointMeta,
          iconCodepoint.isAcceptableOrUnknown(
              data['icon_codepoint']!, _iconCodepointMeta));
    } else if (isInserting) {
      context.missing(_iconCodepointMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    } else if (isInserting) {
      context.missing(_isArchivedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iconCodepoint: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_codepoint'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }
}

class AccountsTableCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> iconCodepoint;
  final Value<int> color;
  final Value<double> balance;
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
    required double balance,
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
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? iconCodepoint,
    Expression<int>? color,
    Expression<double>? balance,
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
      Value<double>? balance,
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
      map['balance'] = Variable<double>(balance.value);
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

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $TransactionTableTable transactionTable =
      $TransactionTableTable(this);
  late final $CategoriesTableTable categoriesTable =
      $CategoriesTableTable(this);
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [transactionTable, categoriesTable, accountsTable];
}
