import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/gallery_repository.dart';
import '../../domain/models/gallery_permission_denied_exception.dart';
import '../../domain/models/swipe_page_state.dart';

part 'swipe_page_notifier.g.dart';

@riverpod
class SwipePageNotifier extends _$SwipePageNotifier {
  @override
  Future<SwipePageState> build() async {
    final repository = ref.watch(galleryRepositoryProvider);

    final hasPermission = await repository.requestPermission();
    if (!hasPermission) {
      throw const GalleryPermissionDeniedException();
    }

    final photos = await repository.fetchPhotos();
    return SwipePageState(photos: photos, currentIndex: 0);
  }

  Future<void> applyDateFilter({DateTime? startDate, DateTime? endDate}) {
    return _refetchWithFilter(startDate: startDate, endDate: endDate);
  }

  Future<List<DateTime>> fetchAvailableMonths() {
    final repository = ref.read(galleryRepositoryProvider);
    return repository.fetchAvailableMonths();
  }

  Future<void> clearDateFilter() => _refetchWithFilter();

  Future<void> _refetchWithFilter({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final repository = ref.read(galleryRepositoryProvider);
    final photos = await repository.fetchPhotos(
      startDate: startDate,
      endDate: endDate,
    );

    state = AsyncData(
      SwipePageState(
        photos: photos,
        currentIndex: 0,
        filterStartDate: startDate,
        filterEndDate: endDate,
      ),
    );
  }

  void keepCurrent() {
    final current = state.value;
    if (current == null || current.isFinished) return;

    state = AsyncData(current.copyWith(currentIndex: current.currentIndex + 1));
  }

  void markCurrentForDeletion() {
    final current = state.value;
    if (current == null || current.isFinished) return;

    final photo = current.currentPhoto;
    if (photo == null) return;

    state = AsyncData(
      current.copyWith(
        currentIndex: current.currentIndex + 1,
        pendingDeletionIds: {...current.pendingDeletionIds, photo.id},
      ),
    );
  }

  void toggleDeletionMark(String photoId) {
    final current = state.value;
    if (current == null) return;

    final updatedIds = {...current.pendingDeletionIds};
    if (!updatedIds.remove(photoId)) {
      updatedIds.add(photoId);
    }

    state = AsyncData(current.copyWith(pendingDeletionIds: updatedIds));
  }

  Future<void> confirmPendingDeletions() async {
    final current = state.value;
    if (current == null || current.pendingDeletionIds.isEmpty) return;

    final toDelete = current.photos
        .where((photo) => current.pendingDeletionIds.contains(photo.id))
        .toList();

    final repository = ref.read(galleryRepositoryProvider);
    await repository.deletePhotos(toDelete);

    final removedBeforeCurrent = current.photos
        .take(current.currentIndex)
        .where((photo) => current.pendingDeletionIds.contains(photo.id))
        .length;

    final updatedPhotos = current.photos
        .where((photo) => !current.pendingDeletionIds.contains(photo.id))
        .toList();

    state = AsyncData(
      current.copyWith(
        photos: updatedPhotos,
        currentIndex: current.currentIndex - removedBeforeCurrent,
        pendingDeletionIds: const {},
      ),
    );
  }
}
