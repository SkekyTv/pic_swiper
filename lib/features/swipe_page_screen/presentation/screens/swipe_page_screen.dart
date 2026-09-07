import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/models/gallery_permission_denied_exception.dart';
import '../notifiers/swipe_page_notifier.dart';

class SwipePageScreen extends ConsumerWidget {
  const SwipePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(swipePageProvider);
    final notifier = ref.read(swipePageProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final swipeColors = Theme.of(context).extension<SwipeActionColors>()!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: asyncState.when(
          data: (state) {
            final photo = state.currentPhoto;

            return Column(
              children: [
                Expanded(
                  child: photo == null
                      ? Center(
                          child: Text(
                            'No more photos to review',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(24),
                          child: _SwipeablePhotoCard(
                            key: ValueKey(photo.id),
                            photo: photo,
                            onKeep: notifier.keepCurrent,
                            onDelete: notifier.markCurrentForDeletion,
                          ),
                        ),
                ),
                if (photo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionButton(
                          icon: Icons.close,
                          color: swipeColors.delete,
                          onPressed: notifier.markCurrentForDeletion,
                        ),
                        _ActionButton(
                          icon: Icons.favorite,
                          color: swipeColors.keep,
                          onPressed: notifier.keepCurrent,
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 32),
                  child: state.pendingDeletionCount > 0
                      ? _PendingDeletionButton(
                          count: state.pendingDeletionCount,
                          onPressed: notifier.confirmPendingDeletions,
                        )
                      : const SizedBox(height: 40),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _SwipePageError(
            error: error,
            onRetry: () => ref.invalidate(swipePageProvider),
          ),
        ),
      ),
    );
  }
}

class _SwipeablePhotoCard extends StatefulWidget {
  const _SwipeablePhotoCard({
    required super.key,
    required this.photo,
    required this.onKeep,
    required this.onDelete,
  });

  final AssetEntity photo;
  final VoidCallback onKeep;
  final VoidCallback onDelete;

  @override
  State<_SwipeablePhotoCard> createState() => _SwipeablePhotoCardState();
}

class _SwipeablePhotoCardState extends State<_SwipeablePhotoCard>
    with SingleTickerProviderStateMixin {
  static const double _swipeThreshold = 120;

  late final AnimationController _controller;
  Animation<Offset>? _animation;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 220),
        )..addListener(() {
          setState(() => _dragOffset = _animation!.value);
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() => _dragOffset += details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (_dragOffset.dx > _swipeThreshold) {
      _animateAway(Offset(screenWidth, _dragOffset.dy), widget.onKeep);
    } else if (_dragOffset.dx < -_swipeThreshold) {
      _animateAway(Offset(-screenWidth, _dragOffset.dy), widget.onDelete);
    } else {
      _animateBack();
    }
  }

  void _animateAway(Offset target, VoidCallback onComplete) {
    _animation = Tween<Offset>(begin: _dragOffset, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0).whenComplete(onComplete);
  }

  void _animateBack() {
    _animation = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final angle = _dragOffset.dx / 800;

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: angle,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: FutureBuilder<Uint8List?>(
                future: widget.photo.thumbnailDataWithSize(
                  const ThumbnailSize(1080, 1080),
                ),
                builder: (context, snapshot) {
                  final bytes = snapshot.data;
                  if (bytes == null) {
                    return ColoredBox(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Image.memory(
                    bytes,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Icon(icon, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}

class _PendingDeletionButton extends StatelessWidget {
  const _PendingDeletionButton({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = count == 1
        ? '1 photo sélectionnée'
        : '$count photos sélectionnées';

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: colorScheme.errorContainer,
        foregroundColor: colorScheme.onErrorContainer,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class _SwipePageError extends StatelessWidget {
  const _SwipePageError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = error is GalleryPermissionDeniedException
        ? 'Photo library access is required to use pic-swiper.\n'
              'Please grant permission in Settings.'
        : 'Something went wrong while loading your photos.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
