import "package:drift/drift.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/database/db.dart";

class TransactionCategory extends Classifier {
  TransactionCategory({
    required this.id,
    required this.name,
    required this.iconCodepoint,
    required this.color,
    required this.order,
    required this.isArchived,
  });

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
  TransactionCategory copyWith({
    String? name,
    int? iconCodepoint,
    int? color,
    int? order,
    bool? isArchived,
  }) {
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
    final List<TransactionCategory> allCategories =
        await db.select(db.categoriesTable).get();
    allCategories.sort((a, b) => a.order.compareTo(b.order));
    state = allCategories;
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

  Future<void> add(TransactionCategory newCategory) async {
    state = [...state, newCategory];
    await db.into(db.categoriesTable).insert(
          CategoriesTableCompanion.insert(
            id: newCategory.id,
            name: newCategory.name,
            iconCodepoint: newCategory.iconCodepoint,
            color: newCategory.color,
            order: newCategory.order,
            isArchived: newCategory.isArchived,
          ),
        );
  }

  Future<void> delete(String categoryID) async {
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
    ref.read(MyDatabase.provider),
  );
});

abstract class Classifier {
  String get id;
  String get name;
  int get iconCodepoint;
  int get color;
  int get order;
  bool get isArchived;

  Classifier copyWith({
    String? name,
    int? iconCodepoint,
    int? color,
    int? order,
    bool? isArchived,
  });
}
