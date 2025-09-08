import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/photo_model.dart';

class HiveService {
  static const String _photoBoxName = 'photo_vault';
  static Box<PhotoModel>? _photoBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register the adapter
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PhotoModelAdapter());
    }

    // Open the box
    _photoBox = await Hive.openBox<PhotoModel>(_photoBoxName);
  }

  static Box<PhotoModel> get photoBox {
    if (_photoBox == null) {
      throw Exception('Hive not initialized. Call HiveService.init() first.');
    }
    return _photoBox!;
  }

  static Future<void> addPhoto(PhotoModel photo) async {
    await photoBox.put(photo.id, photo);
  }

  static List<PhotoModel> getAllPhotos() {
    return photoBox.values.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
  }

  static Future<void> deletePhoto(String id) async {
    await photoBox.delete(id);
  }

  static PhotoModel? getPhoto(String id) {
    return photoBox.get(id);
  }

  static Future<void> close() async {
    await _photoBox?.close();
  }
}
