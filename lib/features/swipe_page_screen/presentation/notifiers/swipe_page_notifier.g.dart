// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swipe_page_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SwipePageNotifier)
final swipePageProvider = SwipePageNotifierProvider._();

final class SwipePageNotifierProvider
    extends $AsyncNotifierProvider<SwipePageNotifier, SwipePageState> {
  SwipePageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swipePageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swipePageNotifierHash();

  @$internal
  @override
  SwipePageNotifier create() => SwipePageNotifier();
}

String _$swipePageNotifierHash() => r'26d0b932f3b4491f320b58d2b8b18bf770fd4d18';

abstract class _$SwipePageNotifier extends $AsyncNotifier<SwipePageState> {
  FutureOr<SwipePageState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SwipePageState>, SwipePageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SwipePageState>, SwipePageState>,
              AsyncValue<SwipePageState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
