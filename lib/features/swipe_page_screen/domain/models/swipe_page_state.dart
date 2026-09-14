import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';

part 'swipe_page_state.freezed.dart';

@freezed
abstract class SwipePageState with _$SwipePageState {
  const SwipePageState._();

  const factory SwipePageState({
    required List<AssetEntity> photos,
    required int currentIndex,
    @Default(<String>{}) Set<String> pendingDeletionIds,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
  }) = _SwipePageState;

  AssetEntity? get currentPhoto =>
      currentIndex < photos.length ? photos[currentIndex] : null;

  bool get isFinished => currentIndex >= photos.length;

  bool get isDateFiltered => filterStartDate != null || filterEndDate != null;

  int get pendingDeletionCount => pendingDeletionIds.length;

  List<AssetEntity> get pendingDeletionPhotos => photos
      .where((photo) => pendingDeletionIds.contains(photo.id))
      .toList();
}
