import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/photo_model.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<PhotoModel>> pickMedia() async {
    try {
      // Pick multiple images and videos
      final List<XFile> files = await _picker.pickMultipleMedia();
      
      if (files.isEmpty) return [];

      List<PhotoModel> mediaList = [];
      
      for (XFile file in files) {
        final photoModel = await _processMediaFile(file);
        if (photoModel != null) {
          mediaList.add(photoModel);
        }
      }
      
      return mediaList;
    } catch (e) {
      print('Error picking media: $e');
      return [];
    }
  }

  static Future<PhotoModel?> _processMediaFile(XFile file) async {
    try {
      final String fileName = path.basename(file.path);
      final String fileExtension = path.extension(file.path).toLowerCase();
      final File originalFile = File(file.path);
      final int fileSize = await originalFile.length();
      
      // Determine if it's a video or image
      final bool isVideo = _isVideoFile(fileExtension);
      
      // Get app directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String mediaDir = path.join(appDir.path, 'media');
      await Directory(mediaDir).create(recursive: true);
      
      // Copy file to app directory
      final String newPath = path.join(mediaDir, '${DateTime.now().millisecondsSinceEpoch}_$fileName');
      final File newFile = await originalFile.copy(newPath);
      
      String? thumbnailPath;
      int? duration;
      
      if (isVideo) {
        // Generate thumbnail for video
        thumbnailPath = await _generateVideoThumbnail(newPath);
        duration = await _getVideoDuration(newPath);
      }
      
      return PhotoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        path: newFile.path,
        name: fileName,
        dateAdded: DateTime.now(),
        size: fileSize,
        type: isVideo ? 'video' : 'image',
        duration: duration,
        thumbnailPath: thumbnailPath,
      );
    } catch (e) {
      print('Error processing media file: $e');
      return null;
    }
  }

  static bool _isVideoFile(String extension) {
    const videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.3gp', '.m4v'];
    return videoExtensions.contains(extension);
  }

  static Future<String?> _generateVideoThumbnail(String videoPath) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String thumbnailDir = path.join(appDir.path, 'thumbnails');
      await Directory(thumbnailDir).create(recursive: true);
      
      final String thumbnailPath = path.join(
        thumbnailDir, 
        '${path.basenameWithoutExtension(videoPath)}_thumb.jpg'
      );

      final Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 300,
        quality: 75,
      );

      if (thumbnailData != null) {
        final File thumbnailFile = File(thumbnailPath);
        await thumbnailFile.writeAsBytes(thumbnailData);
        return thumbnailPath;
      }
      return null;
    } catch (e) {
      print('Error generating video thumbnail: $e');
      return null;
    }
  }

  static Future<int?> _getVideoDuration(String videoPath) async {
    try {
      // You might need to use video_player or ffmpeg to get actual duration
      // For now, returning null as placeholder
      return null;
    } catch (e) {
      print('Error getting video duration: $e');
      return null;
    }
  }

  static Future<void> deleteMedia(PhotoModel media) async {
    try {
      // Delete main file
      final File file = File(media.path);
      if (await file.exists()) {
        await file.delete();
      }
      
      // Delete thumbnail if it's a video
      if (media.isVideo && media.thumbnailPath != null) {
        final File thumbnailFile = File(media.thumbnailPath!);
        if (await thumbnailFile.exists()) {
          await thumbnailFile.delete();
        }
      }
    } catch (e) {
      print('Error deleting media: $e');
    }
  }
}