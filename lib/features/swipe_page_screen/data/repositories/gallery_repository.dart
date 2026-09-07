import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_repository.g.dart';

abstract interface class GalleryRepository {
  Future<bool> requestPermission();

  Future<List<AssetEntity>> fetchPhotos();

  Future<void> deletePhoto(AssetEntity asset);
}

class PhotoManagerGalleryRepository implements GalleryRepository {
  @override
  Future<bool> requestPermission() async {
    final permission = await PhotoManager.requestPermissionExtend();
    return permission.isAuth || permission.hasAccess;
  }

  @override
  Future<List<AssetEntity>> fetchPhotos() async {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    if (albums.isEmpty) return [];

    final recentAlbum = albums.first;
    final count = await recentAlbum.assetCountAsync;
    return recentAlbum.getAssetListRange(start: 0, end: count);
  }

  @override
  Future<void> deletePhoto(AssetEntity asset) async {
    await PhotoManager.editor.deleteWithIds([asset.id]);
  }
}

@riverpod
GalleryRepository galleryRepository(Ref ref) {
  return PhotoManagerGalleryRepository();
}
