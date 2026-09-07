class GalleryPermissionDeniedException implements Exception {
  const GalleryPermissionDeniedException();

  @override
  String toString() => 'Permission to access the photo gallery was denied.';
}
