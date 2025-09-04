import 'package:hive_flutter/hive_flutter.dart';
import '../models/photo_model.dart';

class HiveService {
  static const String _photoBoxName = 'photos';
  static late Box<PhotoModel> _photoBox;

  static Future<void> init() async {
    try {
      _photoBox = await Hive.openBox<PhotoModel>(_photoBoxName);
    } catch (e) {
      print('Error initializing Hive: $e');
      rethrow;
    }
  }

  // Get all photos
  static List<PhotoModel> getAllPhotos() {
    try {
      return _photoBox.values.toList()
        ..sort((a, b) => b.addedDate.compareTo(a.addedDate));
    } catch (e) {
      print('Error getting all photos: $e');
      return [];
    }
  }

  // Add a photo
  static Future<void> addPhoto(PhotoModel photo) async {
    try {
      await _photoBox.put(photo.id, photo);
    } catch (e) {
      print('Error adding photo: $e');
      rethrow;
    }
  }

  // Add multiple photos
  static Future<void> addPhotos(List<PhotoModel> photos) async {
    try {
      final Map<String, PhotoModel> photoMap = {};
      for (var photo in photos) {
        photoMap[photo.id] = photo;
      }
      await _photoBox.putAll(photoMap);
    } catch (e) {
      print('Error adding photos: $e');
      rethrow;
    }
  }

  // Delete a photo
  static Future<void> deletePhoto(String photoId) async {
    try {
      await _photoBox.delete(photoId);
    } catch (e) {
      print('Error deleting photo: $e');
      rethrow;
    }
  }

  // Get photo by ID
  static PhotoModel? getPhoto(String photoId) {
    try {
      return _photoBox.get(photoId);
    } catch (e) {
      print('Error getting photo: $e');
      return null;
    }
  }

  // Check if photo exists
  static bool photoExists(String photoId) {
    try {
      return _photoBox.containsKey(photoId);
    } catch (e) {
      print('Error checking photo existence: $e');
      return false;
    }
  }

  // Get photos count
  static int getPhotosCount() {
    try {
      return _photoBox.length;
    } catch (e) {
      print('Error getting photos count: $e');
      return 0;
    }
  }

  // Clear all photos
  static Future<void> clearAllPhotos() async {
    try {
      await _photoBox.clear();
    } catch (e) {
      print('Error clearing all photos: $e');
      rethrow;
    }
  }

  // Close the box
  static Future<void> close() async {
    try {
      await _photoBox.close();
    } catch (e) {
      print('Error closing Hive box: $e');
    }
  }

  // Get storage info
  static Map<String, dynamic> getStorageInfo() {
    try {
      final photos = getAllPhotos();
      final totalSize =
          photos.fold<int>(0, (sum, photo) => sum + photo.fileSize);

      return {
        'totalPhotos': photos.length,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
        'totalSizeBytes': totalSize,
      };
    } catch (e) {
      print('Error getting storage info: $e');
      return {
        'totalPhotos': 0,
        'totalSizeMB': '0.00',
        'totalSizeBytes': 0,
      };
    }
  }
}
