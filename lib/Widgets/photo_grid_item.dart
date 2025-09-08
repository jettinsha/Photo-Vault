import 'dart:io';
import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../screens/full_screen_photo.dart';

class PhotoGridItem extends StatelessWidget {
  final PhotoModel media;
  final VoidCallback onDelete;

  const PhotoGridItem({
    Key? key,
    required this.media,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenPhoto(
              media: media,
              onDelete: onDelete,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Display thumbnail for videos or image for photos
              _buildMediaThumbnail(),

              // Video indicator overlay
              if (media.isVideo)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 16,
                        ),
                        if (media.duration != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(media.duration!),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaThumbnail() {
    if (media.isVideo && media.thumbnailPath != null) {
      // Show video thumbnail
      return Image.file(
        File(media.thumbnailPath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    } else if (media.isImage) {
      // Show image
      return Image.file(
        File(media.path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    } else {
      // Fallback for videos without thumbnails
      return Container(
        color: Colors.grey[300],
        child: const Icon(
          Icons.video_file,
          size: 40,
          color: Colors.grey,
        ),
      );
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        media.isVideo ? Icons.video_file : Icons.image,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
