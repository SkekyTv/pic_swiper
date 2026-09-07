import 'package:photo_manager/photo_manager.dart';
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

  void keepCurrent() {
    final current = state.value;
    if (current == null || current.isFinished) return;

    state = AsyncData(
      current.copyWith(currentIndex: current.currentIndex + 1),
    );
  }

  Future<void> deleteCurrent() async {
    final current = state.value;
    if (current == null || current.isFinished) return;

    final photo = current.currentPhoto;
    if (photo == null) return;

    final repository = ref.read(galleryRepositoryProvider);
    await repository.deletePhoto(photo);

    final updatedPhotos = List<AssetEntity>.from(current.photos)
      ..removeAt(current.currentIndex);
    state = AsyncData(current.copyWith(photos: updatedPhotos));
  }
}
