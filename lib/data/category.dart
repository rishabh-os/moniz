import "package:drift/drift.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/database/db.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "category.g.dart";

final class TransactionCategory extends Classifier {
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

@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  @override
  List<TransactionCategory> build() => [];

  Future<void> loadCategories() async {
    final db = ref.read(dBProvider);
    final List<TransactionCategory> allCategories =
        await db.select(db.categoriesTable).get();
    allCategories.sort((a, b) => a.order.compareTo(b.order));
    state = allCategories;
  }

  void edit(TransactionCategory editedCategory) {
    final db = ref.read(dBProvider);
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
    final db = ref.read(dBProvider);
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
    final db = ref.read(dBProvider);
    await db.categoriesTable.deleteWhere((tbl) => tbl.id.equals(categoryID));
  }
}

abstract base class Classifier {
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
