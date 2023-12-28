import "dart:convert";
import "dart:math";

import "package:drift/drift.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:get_storage/get_storage.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/database/db.dart";

class TransactionCategory extends Classifier {
  TransactionCategory(
      {required this.id,
      required this.name,
      required this.iconCodepoint,
      required this.color,
      required this.order,
      required this.isArchived});

  @override
  final String id;
  @override
  final String name;
  @override
  final int iconCodepoint;
  @override
  final int color;
  @override
  final int order;
  @override
  final bool isArchived;

  @override
  TransactionCategory copyWith(
      {String? name,
      int? iconCodepoint,
      int? color,
      int? order,
      bool? isArchived}) {
    return TransactionCategory(
      id: id,
      name: name ?? this.name,
      iconCodepoint: iconCodepoint ?? this.iconCodepoint,
      color: color ?? this.color,
      order: order ?? this.order,
      isArchived: isArchived ?? this.isArchived,
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
            color: e.color,
            order: e.order,
            isArchived: e.isArchived))
        .toList();
    state = loadedCategories;
  }

  void edit(TransactionCategory editedCategory) {
    db.updateCategory(editedCategory);
    state = [
      for (final trans in state)
        if (trans.id == editedCategory.id)
          trans.copyWith(
            name: editedCategory.name,
            iconCodepoint: editedCategory.iconCodepoint,
            color: editedCategory.color,
            order: editedCategory.order,
            isArchived: editedCategory.isArchived,
          )
        else
          trans,
    ];
  }

  void add(TransactionCategory newCategory) async {
    state = [...state, newCategory];
    await db.into(db.categoriesTable).insert(CategoriesTableCompanion.insert(
        id: newCategory.id,
        name: newCategory.name,
        iconCodepoint: newCategory.iconCodepoint,
        color: newCategory.color,
        order: newCategory.order,
        isArchived: newCategory.isArchived));
  }

  void delete(String categoryID) async {
    state = [
      for (final category in state)
        if (category.id != categoryID) category,
    ];
    await db.categoriesTable.deleteWhere((tbl) => tbl.id.equals(categoryID));
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoryNotifier, List<TransactionCategory>>((ref) {
  return CategoryNotifier(
    ref.read(dbProvider),
  );
});

abstract class Classifier {
  String get id;
  String get name;
  int get iconCodepoint;
  int get color;
  int get order;
  bool get isArchived;

  Classifier copyWith(
      {String? name,
      int? iconCodepoint,
      int? color,
      int? order,
      bool? isArchived});
}

class CatOrderNotifier extends StateNotifier<List<int>> {
  CatOrderNotifier(this.catLen) : super([]);
  final int catLen;
  Future<void> loadOrder() async {
    GetStorage().writeIfNull(
        "order", <int>[for (var i = 0; i <= catLen; i++) i].toString());
    String x = GetStorage().read("order");
    List<int> test = (jsonDecode(x) as List).cast<int>();
    state = test;
  }

  void updateOrder(List<int> order) {
    state = order;
    GetStorage().write("order", order.toString());
  }

  void handleCatChange() {
    String x = GetStorage().read("order");
    List<int> oldState = (jsonDecode(x) as List).cast<int>();
    try {
      assert(oldState.length == catLen);
    } catch (e) {
      // ? Handles adding and removing of categories
      if (oldState.length < catLen) {
        while (oldState.length < catLen) {
          oldState.add(oldState.reduce(max) + 1);
        }
      } else if (oldState.length > catLen) {
        while (oldState.length > catLen) {
          oldState.removeWhere((element) => element == oldState.reduce(max));
        }
      }
    }
    state = oldState;
    GetStorage().write("order", oldState.toString());
  }
}

final catOrderProvider =
    StateNotifierProvider<CatOrderNotifier, List<int>>((ref) {
  return CatOrderNotifier(ref.watch(categoriesProvider).length);
});
