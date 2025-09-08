import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'photo_model.g.dart';

@HiveType(typeId: 0)
class PhotoModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  Uint8List imageData;

  @HiveField(3)
  DateTime dateAdded;

  @HiveField(4)
  String originalPath;

  PhotoModel({
    required this.id,
    required this.name,
    required this.imageData,
    required this.dateAdded,
    required this.originalPath,
  });

  factory PhotoModel.create({
    required String name,
    required Uint8List imageData,
    required String originalPath,
  }) {
    return PhotoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      imageData: imageData,
      dateAdded: DateTime.now(),
      originalPath: originalPath,
    );
  }
}
