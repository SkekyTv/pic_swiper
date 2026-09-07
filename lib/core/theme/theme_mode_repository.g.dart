// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_mode_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(themeModeRepository)
final themeModeRepositoryProvider = ThemeModeRepositoryProvider._();

final class ThemeModeRepositoryProvider
    extends
        $FunctionalProvider<
          ThemeModeRepository,
          ThemeModeRepository,
          ThemeModeRepository
        >
    with $Provider<ThemeModeRepository> {
  ThemeModeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeRepositoryHash();

  @$internal
  @override
  $ProviderElement<ThemeModeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ThemeModeRepository create(Ref ref) {
    return themeModeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeModeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeModeRepository>(value),
    );
  }
}

String _$themeModeRepositoryHash() =>
    r'8a6d68870fedc5282ed17191bc5840e7b0e8f3b5';
