import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/photo_model.dart';
import 'hive_service.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.photos,
      Permission.camera,
      Permission.storage,
    ].request();

    return permissions.values.every((status) =>
        status == PermissionStatus.granted ||
        status == PermissionStatus.limited);
  }

  static Future<PhotoModel?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        return await _createPhotoModel(image);
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
    return null;
  }

  static Future<List<PhotoModel>> pickMultipleImagesFromGallery() async {
    List<PhotoModel> photos = [];
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 100,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (images.isNotEmpty) {
        for (XFile image in images) {
          try {
            PhotoModel photoModel = await _createPhotoModel(image);
            photos.add(photoModel);
          } catch (e) {
            print('Error processing image ${image.name}: $e');
            // Continue processing other images even if one fails
          }
        }
      }
    } catch (e) {
      print('Error picking multiple images from gallery: $e');
    }
    return photos;
  }

  static Future<PhotoModel?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image != null) {
        return await _createPhotoModel(image);
      }
    } catch (e) {
      print('Error taking photo from camera: $e');
    }
    return null;
  }

  static Future<PhotoModel> _createPhotoModel(XFile image) async {
    final File imageFile = File(image.path);
    final Uint8List imageBytes = await imageFile.readAsBytes();
    final String fileName = image.name.isEmpty
        ? 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg'
        : image.name;

    return PhotoModel.create(
      name: fileName,
      imageData: imageBytes,
      originalPath: image.path,
    );
  }

  static Future<void> savePhotoToVault(PhotoModel photo) async {
    await HiveService.addPhoto(photo);
  }

  static Future<bool> saveMultiplePhotosToVault(List<PhotoModel> photos) async {
    if (photos.isEmpty) return false;
    
    try {
      int successCount = 0;
      int totalCount = photos.length;
      
      for (PhotoModel photo in photos) {
        try {
          await HiveService.addPhoto(photo);
          successCount++;
        } catch (e) {
          print('Error saving photo ${photo.name}: $e');
          // Continue with other photos even if one fails
        }
      }
      
      // Return true if at least some photos were saved successfully
      // You might want to adjust this logic based on your requirements
      return successCount > 0;
      
    } catch (e) {
      print('Error saving multiple photos: $e');
      return false;
    }
  }

  // Utility method to get image file size
  static Future<int> getImageFileSize(String path) async {
    try {
      final File file = File(path);
      return await file.length();
    } catch (e) {
      print('Error getting file size: $e');
      return 0;
    }
  }

  // Utility method to validate image format
  static bool isValidImageFormat(String fileName) {
    final String extension = fileName.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }
}