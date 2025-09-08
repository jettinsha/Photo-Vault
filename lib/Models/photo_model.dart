import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'photo_model.g.dart';

@HiveType(typeId: 0)
class PhotoModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String path;

  @HiveField(2)
  String name;

  @HiveField(3)
  DateTime dateAdded;

  @HiveField(4)
  int size;

  @HiveField(5)
  String type; // 'image' or 'video'

  @HiveField(6)
  int? duration; // Duration in seconds for videos

  @HiveField(7)
  String? thumbnailPath; // Thumbnail path for videos

  @HiveField(8)
  Uint8List imageData; // Keep existing imageData for compatibility

  PhotoModel({
    required this.id,
    required this.path,
    required this.name,
    required this.dateAdded,
    required this.size,
    required this.imageData,
    this.type = 'image',
    this.duration,
    this.thumbnailPath,
  });

  bool get isVideo => type == 'video';
  bool get isImage => type == 'image';
}