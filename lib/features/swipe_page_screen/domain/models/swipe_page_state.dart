import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';

part 'swipe_page_state.freezed.dart';

@freezed
abstract class SwipePageState with _$SwipePageState {
  const SwipePageState._();

  const factory SwipePageState({
    required List<AssetEntity> photos,
    required int currentIndex,
  }) = _SwipePageState;

  AssetEntity? get currentPhoto =>
      currentIndex < photos.length ? photos[currentIndex] : null;

  bool get isFinished => currentIndex >= photos.length;
}
