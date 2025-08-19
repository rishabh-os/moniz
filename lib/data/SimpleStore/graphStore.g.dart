// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphStore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(GraphData)
const graphDataProvider = GraphDataProvider._();

final class GraphDataProvider extends $AsyncNotifierProvider<GraphData,
    (List<SpendsByDay>, List<SpendsByCat>)> {
  const GraphDataProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'graphDataProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$graphDataHash();

  @$internal
  @override
  GraphData create() => GraphData();
}

String _$graphDataHash() => r'695e8fe503f28f60f6c98d75e326cdac6e2b987c';

abstract class _$GraphData
    extends $AsyncNotifier<(List<SpendsByDay>, List<SpendsByCat>)> {
  FutureOr<(List<SpendsByDay>, List<SpendsByCat>)> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<
        AsyncValue<(List<SpendsByDay>, List<SpendsByCat>)>,
        (List<SpendsByDay>, List<SpendsByCat>)>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<(List<SpendsByDay>, List<SpendsByCat>)>,
            (List<SpendsByDay>, List<SpendsByCat>)>,
        AsyncValue<(List<SpendsByDay>, List<SpendsByCat>)>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
