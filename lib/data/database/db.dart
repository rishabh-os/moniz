import "dart:io";
import "package:drift/drift.dart";
import "package:drift/native.dart";
import "package:file_picker/file_picker.dart";
// ? This prevents everything conflicting Table imports in db.g.dart
import "package:flutter/material.dart" show Colors, Icons;
import "package:moniz/data/account.dart";
import "package:moniz/data/api/response.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/database/db.steps.dart";
import "package:moniz/data/transactions.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";
import "package:share_plus/share_plus.dart";

part "db.g.dart";

@UseRowClass(Transaction)
class TransactionTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get additionalInfo => text().nullable()();
  TextColumn get categoryID => text()();
  TextColumn get accountID => text()();
  IntColumn get amount => integer()();
  DateTimeColumn get recorded => dateTime()();
  TextColumn get location =>
      text().map(const LocationFeatureConverter()).nullable()();
}

@UseRowClass(TransactionCategory)
class CategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get iconCodepoint => integer()();
  IntColumn get color => integer()();
  IntColumn get order => integer()();
  BoolColumn get isArchived => boolean()();
}

@UseRowClass(Account)
class AccountsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  // ? Use Icons.name.codepoint and Icon(codepoint)
  IntColumn get iconCodepoint => integer()();
  // ? Use Colors.blue.value and Color(value)
  IntColumn get color => integer()();
  // ? Real means double
  IntColumn get balance => integer()();
  IntColumn get order => integer()();
  BoolColumn get isArchived => boolean()();
}

@DriftDatabase(tables: [TransactionTable, CategoriesTable, AccountsTable])
class MyDatabase extends _$MyDatabase {
  MyDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  Future<List<TransactionCategory>> findAnimalsByLegs(int legCount) {
    return (select(categoriesTable)
          ..where(
            (a) =>
                a.name.contains("Default") |
                a.name.contains("Food") |
                a.name.contains("Rent") |
                a.name.contains("Shopping") |
                a.name.contains("Utility"),
          ))
        .get();
  }

  Future<void> initCategories() async {
    final allCategories = await select(categoriesTable).get();
    if (allCategories.isEmpty) {
      await batch(
        (batch) => batch.insertAll(categoriesTable, [
          CategoriesTableCompanion.insert(
            id: "id1",
            name: "Default",
            iconCodepoint: Icons.account_circle_rounded.codePoint,
            color: Colors.blue.toARGB32(),
            order: 0,
            isArchived: false,
          ),
          CategoriesTableCompanion.insert(
            id: "id2",
            name: "Food",
            iconCodepoint: Icons.wine_bar.codePoint,
            color: Colors.orange.toARGB32(),
            order: 1,
            isArchived: false,
          ),
          CategoriesTableCompanion.insert(
            id: "id3",
            name: "Rent",
            iconCodepoint: Icons.house_rounded.codePoint,
            color: Colors.green.toARGB32(),
            order: 2,
            isArchived: false,
          ),
          CategoriesTableCompanion.insert(
            id: "id4",
            name: "Shopping",
            iconCodepoint: Icons.shopping_bag_rounded.codePoint,
            color: Colors.lime.toARGB32(),
            order: 3,
            isArchived: false,
          ),
          CategoriesTableCompanion.insert(
            id: "id5",
            name: "Utility",
            iconCodepoint: Icons.electrical_services_rounded.codePoint,
            color: Colors.pink.toARGB32(),
            order: 4,
            isArchived: false,
          ),
        ]),
      );
    }
  }

  Future<void> initAccounts() async {
    // ? This part is debug code that adds accounts if they are empty
    final allAccounts = await select(accountsTable).get();
    if (allAccounts.isEmpty) {
      await batch(
        (batch) => batch.insertAll(accountsTable, [
          AccountsTableCompanion.insert(
            id: "accId1",
            name: "Cash",
            iconCodepoint: Icons.monetization_on.codePoint,
            color: Colors.green.toARGB32(),
            order: 0,
            isArchived: false,
            balance: 0,
          ),
        ]),
      );
    }
    // ? Use batch to perform inserts as there is an inbuilt unique checker (happy little discovery)
    // await delete(accountsTable).go();

    // print('Accounts in database: $allAccounts');
  }

  Future updateAccount(Account target) {
    return (update(accountsTable)..where((t) => t.id.equals(target.id))).write(
      AccountsTableCompanion(
        name: Value(target.name),
        iconCodepoint: Value(target.iconCodepoint),
        color: Value(target.color),
        balance: Value(target.balance),
        order: Value(target.order),
        isArchived: Value(target.isArchived),
      ),
    );
  }

  Future updateCategory(TransactionCategory target) {
    return (update(categoriesTable)..where((t) => t.id.equals(target.id)))
        .write(
      CategoriesTableCompanion(
        name: Value(target.name),
        iconCodepoint: Value(target.iconCodepoint),
        color: Value(target.color),
        order: Value(target.order),
        isArchived: Value(target.isArchived),
      ),
    );
  }

  Future updateTransaction(Transaction target) {
    return (update(transactionTable)..where((t) => t.id.equals(target.id)))
        .write(
      TransactionTableCompanion(
        title: Value(target.title),
        additionalInfo: Value(target.additionalInfo),
        categoryID: Value(target.categoryID),
        accountID: Value(target.accountID),
        amount: Value(target.amount),
        recorded: Value(target.recorded),
        location: Value(target.location),
      ),
    );
  }

  // you should bump this number whenever you change or add a table definition
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onUpgrade: stepByStep(from1To2: (m, schema) async {
        await m.alterTable(TableMigration(transactionTable, columnTransformer: {
          transactionTable.amount:
              const CustomExpression<int>("(amount * 100)").cast<int>(),
        }));
        await m.alterTable(TableMigration(accountsTable, columnTransformer: {
          accountsTable.balance:
              const CustomExpression<int>("(balance * 100)").cast<int>(),
        }));
      }));

  Future<void> shareDB() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbXFile = XFile(p.join(dbFolder.path, "db.sqlite"));
    SharePlus.instance.share(
      ShareParams(files: [dbXFile]),
    );
  }

  Future<bool> importDB() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
        // type: FileType.custom,
        // allowedExtensions: ["sqlite"],
        );

    if (result != null) {
      final File file = File(result.files.single.path!);
      final dbFolder = await getApplicationDocumentsDirectory();
      final oldFile = File(p.join(dbFolder.path, "db.sqlite"));
      await oldFile.delete();
      await file.copy(p.join(dbFolder.path, "db.sqlite"));
      return true;
    } else {
      return false;
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "db.sqlite"));
    return NativeDatabase.createInBackground(file);
  });
}
