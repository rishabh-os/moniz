import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moniz/data/SimpleStore/basicStore.dart';
import 'package:moniz/data/database/db.dart';

class TransactionCategory {
  const TransactionCategory(
      {required this.id,
      required this.name,
      required this.iconCodepoint,
      required this.color});

  final String id;
  final String name;
  final int iconCodepoint;
  final int color;

  TransactionCategory copyWith({String? name, int? iconCodepoint, int? color}) {
    return TransactionCategory(
      id: id,
      name: name ?? this.name,
      iconCodepoint: iconCodepoint ?? this.iconCodepoint,
      color: color ?? this.color,
    );
  }
}

class CategoryNotifier extends StateNotifier<List<TransactionCategory>> {
  CategoryNotifier(this.db)
      : super(
          [],
        );
  final MyDatabase db;
  Future<void> loadCategories() async {
    final allCategories = await db.select(db.categoriesTable).get();

    List<TransactionCategory> loadedCategories = allCategories
        .map((e) => TransactionCategory(
            id: e.id,
            name: e.name,
            iconCodepoint: e.iconCodepoint,
            color: e.color))
        .toList();
    state = loadedCategories;
  }

  void editCategory(TransactionCategory editedCategory) {
    db.updateCategory(editedCategory);
    state = [
      for (final trans in state)
        if (trans.id == editedCategory.id)
          trans.copyWith(
            name: editedCategory.name,
            iconCodepoint: editedCategory.iconCodepoint,
            color: editedCategory.color,
          )
        else
          trans,
    ];
  }

  void addCategory(TransactionCategory newCategory) async {
    state = [...state, newCategory];
    await db.into(db.categoriesTable).insert(CategoriesTableCompanion.insert(
        id: newCategory.id,
        name: newCategory.name,
        iconCodepoint: newCategory.iconCodepoint,
        color: newCategory.color));
  }

  void deleteCategory(String categoryID) async {
    state = [
      for (final category in state)
        if (category.id != categoryID) category,
    ];
    await db.categoriesTable.deleteWhere((tbl) => tbl.name.equals(categoryID));
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoryNotifier, List<TransactionCategory>>((ref) {
  return CategoryNotifier(ref.read(dbProvider));
});
