import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/photo_model.dart';
import '../services/hive_service.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();
  static String? _appDocumentsPath;

  // Initialize the service
  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _appDocumentsPath = directory.path;
  }

  // Pick multiple images from gallery
  static Future<List<PhotoModel>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();

      if (images.isEmpty) return [];

      List<PhotoModel> photoModels = [];

      for (XFile image in images) {
        final PhotoModel? photoModel = await _processImage(image);
        if (photoModel != null) {
          photoModels.add(photoModel);
        }
      }

      return photoModels;
    } catch (e) {
      debugPrint('Error picking images: $e');
      return [];
    }
  }

  // Pick single image from gallery
  static Future<PhotoModel?> pickSingleImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      return await _processImage(image);
    } catch (e) {
      debugPrint('Error picking single image: $e');
      return null;
    }
  }

  // Process and save image locally
  static Future<PhotoModel?> _processImage(XFile image) async {
    try {
      if (_appDocumentsPath == null) {
        await init();
      }

      // Read the image file
      final Uint8List imageBytes = await image.readAsBytes();
      final File originalFile = File(image.path);

      // Generate unique ID and filename
      final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
      final String originalName = path.basename(image.path);
      final String extension = path.extension(originalName);
      final String newFileName = '${uniqueId}_$originalName';

      // Create photos directory if it doesn't exist
      final String photosDir = path.join(_appDocumentsPath!, 'photos');
      final Directory photosDirObj = Directory(photosDir);
      if (!await photosDirObj.exists()) {
        await photosDirObj.create(recursive: true);
      }

      // Save image to app documents directory
      final String localPath = path.join(photosDir, newFileName);
      final File localFile = File(localPath);
      await localFile.writeAsBytes(imageBytes);

      // Create PhotoModel
      final PhotoModel photoModel = PhotoModel(
        id: uniqueId,
        fileName: newFileName,
        localPath: localPath,
        addedDate: DateTime.now(),
        fileSize: imageBytes.length,
        originalPath: image.path,
      );

      return photoModel;
    } catch (e) {
      debugPrint('Error processing image: $e');
      return null;
    }
  }

  // Delete image file from local storage
  static Future<bool> deleteImageFile(String localPath) async {
    try {
      final File file = File(localPath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image file: $e');
      return false;
    }
  }

  // Check if image file exists
  static Future<bool> imageFileExists(String localPath) async {
    try {
      final File file = File(localPath);
      return await file.exists();
    } catch (e) {
      debugPrint('Error checking image file existence: $e');
      return false;
    }
  }

  // Get image file size
  static Future<int> getImageFileSize(String localPath) async {
    try {
      final File file = File(localPath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting image file size: $e');
      return 0;
    }
  }

  // Clean up orphaned files (files that exist locally but not in database)
  static Future<void> cleanupOrphanedFiles() async {
    try {
      if (_appDocumentsPath == null) {
        await init();
      }

      final String photosDir = path.join(_appDocumentsPath!, 'photos');
      final Directory photosDirObj = Directory(photosDir);

      if (!await photosDirObj.exists()) return;

      final List<FileSystemEntity> files = await photosDirObj.list().toList();
      final List<PhotoModel> dbPhotos = HiveService.getAllPhotos();
      final Set<String> dbFilePaths =
          dbPhotos.map((photo) => photo.localPath).toSet();

      for (FileSystemEntity file in files) {
        if (file is File && !dbFilePaths.contains(file.path)) {
          await file.delete();
          debugPrint('Deleted orphaned file: ${file.path}');
        }
      }
    } catch (e) {
      debugPrint('Error cleaning up orphaned files: $e');
    }
  }

  // Get photos directory size
  static Future<int> getPhotosDirectorySize() async {
    try {
      if (_appDocumentsPath == null) {
        await init();
      }

      final String photosDir = path.join(_appDocumentsPath!, 'photos');
      final Directory photosDirObj = Directory(photosDir);

      if (!await photosDirObj.exists()) return 0;

      int totalSize = 0;
      final List<FileSystemEntity> files = await photosDirObj.list().toList();

      for (FileSystemEntity file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      return totalSize;
    } catch (e) {
      debugPrint('Error getting photos directory size: $e');
      return 0;
    }
  }
}
