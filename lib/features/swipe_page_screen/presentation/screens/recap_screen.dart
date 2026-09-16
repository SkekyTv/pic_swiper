import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../core/theme/theme.dart';
import '../notifiers/swipe_page_notifier.dart';

class RecapScreen extends ConsumerWidget {
  const RecapScreen({super.key, required this.photos});

  /// Snapshot of the batch under review, so the mosaic doesn't shrink when a photo is toggled off.
  final List<AssetEntity> photos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(swipePageProvider);
    final notifier = ref.read(swipePageProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final swipeColors = Theme.of(context).extension<SwipeActionColors>()!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: const Text('Confirm deletion')),
      body: SafeArea(
        child: asyncState.when(
          data: (state) {
            if (photos.isEmpty) {
              return const Center(
                child: Text('No photos selected for deletion'),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      final photo = photos[index];
                      final markedForDeletion = state.pendingDeletionIds
                          .contains(photo.id);

                      return _RecapPhotoTile(
                        photo: photo,
                        markedForDeletion: markedForDeletion,
                        onTap: () => notifier.toggleDeletionMark(photo.id),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: swipeColors.delete,
                      ),
                      onPressed: state.pendingDeletionCount == 0
                          ? null
                          : () => _confirmDeletion(context, notifier),
                      child: Text(
                        'Delete ${state.pendingDeletionCount} photo${state.pendingDeletionCount == 1 ? '' : 's'}',
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(
            child: Text('Something went wrong while loading your photos.'),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeletion(
    BuildContext context,
    SwipePageNotifier notifier,
  ) async {
    await notifier.confirmPendingDeletions();
    if (context.mounted) context.pop();
  }
}

class _RecapPhotoTile extends StatelessWidget {
  const _RecapPhotoTile({
    required this.photo,
    required this.markedForDeletion,
    required this.onTap,
  });

  final AssetEntity photo;
  final bool markedForDeletion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<Uint8List?>(
              future: photo.thumbnailDataWithSize(
                const ThumbnailSize.square(300),
              ),
              builder: (context, snapshot) {
                final bytes = snapshot.data;
                if (bytes == null) {
                  return ColoredBox(color: colorScheme.surfaceContainerHighest);
                }
                return Image.memory(bytes, fit: BoxFit.cover);
              },
            ),
            Positioned(
              right: 6,
              top: 6,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: markedForDeletion
                    ? Icon(
                        Icons.check_circle,
                        key: const ValueKey('marked'),
                        color: colorScheme.error,
                        size: 22,
                      )
                    : Icon(
                        Icons.circle_outlined,
                        key: const ValueKey('unmarked'),
                        color: Colors.white,
                        size: 22,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
