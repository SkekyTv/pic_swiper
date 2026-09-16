import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_repository.g.dart';

abstract interface class GalleryRepository {
  Future<bool> requestPermission();

  Future<List<AssetEntity>> fetchPhotos({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Returns the distinct months (as the first day of each month) for which
  /// at least one photo exists, sorted chronologically.
  Future<List<DateTime>> fetchAvailableMonths();

  Future<void> deletePhotos(List<AssetEntity> assets);
}

class PhotoManagerGalleryRepository implements GalleryRepository {
  @override
  Future<bool> requestPermission() async {
    final permission = await PhotoManager.requestPermissionExtend();
    return permission.isAuth || permission.hasAccess;
  }

  @override
  Future<List<AssetEntity>> fetchPhotos({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final filterOption = FilterOptionGroup(
      createTimeCond: DateTimeCond(
        min: startDate ?? DateTimeCond.zero,
        max: endDate ?? DateTime.now(),
      ),
    );

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
      filterOption: filterOption,
    );
    if (albums.isEmpty) return [];

    final recentAlbum = albums.first;
    final count = await recentAlbum.assetCountAsync;
    return recentAlbum.getAssetListRange(start: 0, end: count);
  }

  @override
  Future<List<DateTime>> fetchAvailableMonths() async {
    final photos = await fetchPhotos();

    final months = <DateTime>{
      for (final photo in photos)
        DateTime(photo.createDateTime.year, photo.createDateTime.month),
    };

    return months.toList()..sort();
  }

  @override
  Future<void> deletePhotos(List<AssetEntity> assets) async {
    if (assets.isEmpty) return;
    await PhotoManager.editor.deleteWithIds(
      assets.map((asset) => asset.id).toList(),
    );
  }
}

@riverpod
GalleryRepository galleryRepository(Ref ref) {
  return PhotoManagerGalleryRepository();
}
