// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphStore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$graphDataHash() => r'695e8fe503f28f60f6c98d75e326cdac6e2b987c';

/// See also [GraphData].
@ProviderFor(GraphData)
final graphDataProvider = AsyncNotifierProvider<GraphData,
    (List<SpendsByDay>, List<SpendsByCat>)>.internal(
  GraphData.new,
  name: r'graphDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$graphDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GraphData = AsyncNotifier<(List<SpendsByDay>, List<SpendsByCat>)>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
