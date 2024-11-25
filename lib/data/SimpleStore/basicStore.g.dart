// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basicStore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dbHash() => r'd98dd30cbc3273c05b6fefbb550c3c9b2b7a4620';

/// See also [db].
@ProviderFor(db)
final dbProvider = AutoDisposeProvider<MyDatabase>.internal(
  db,
  name: r'dbProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dbHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DbRef = AutoDisposeProviderRef<MyDatabase>;
String _$graphByCatHash() => r'd2aba88d0c166776770a6e8933328ac64ef9b42b';

/// See also [GraphByCat].
@ProviderFor(GraphByCat)
final graphByCatProvider =
    AutoDisposeNotifierProvider<GraphByCat, bool>.internal(
  GraphByCat.new,
  name: r'graphByCatProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$graphByCatHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GraphByCat = AutoDisposeNotifier<bool>;
String _$chartScrollHash() => r'30c5cd572d780bcc1a06e22e9ac78d9a2b80b074';

/// See also [ChartScroll].
@ProviderFor(ChartScroll)
final chartScrollProvider =
    AutoDisposeNotifierProvider<ChartScroll, bool>.internal(
  ChartScroll.new,
  name: r'chartScrollProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chartScrollHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChartScroll = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
