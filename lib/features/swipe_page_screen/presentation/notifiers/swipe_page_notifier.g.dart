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

String _$swipePageNotifierHash() => r'ae98cef673d02b4daa120fe09175b254b610fcff';

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
