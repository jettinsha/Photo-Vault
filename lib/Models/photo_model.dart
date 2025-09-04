import 'package:hive/hive.dart';

part 'photo_model.g.dart';

@HiveType(typeId: 0)
class PhotoModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fileName;

  @HiveField(2)
  String localPath;

  @HiveField(3)
  DateTime addedDate;

  @HiveField(4)
  int fileSize;

  @HiveField(5)
  String? originalPath;

  PhotoModel({
    required this.id,
    required this.fileName,
    required this.localPath,
    required this.addedDate,
    required this.fileSize,
    this.originalPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'localPath': localPath,
      'addedDate': addedDate.toIso8601String(),
      'fileSize': fileSize,
      'originalPath': originalPath,
    };
  }

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'],
      fileName: json['fileName'],
      localPath: json['localPath'],
      addedDate: DateTime.parse(json['addedDate']),
      fileSize: json['fileSize'],
      originalPath: json['originalPath'],
    );
  }

  @override
  String toString() {
    return 'PhotoModel(id: $id, fileName: $fileName, localPath: $localPath, addedDate: $addedDate, fileSize: $fileSize)';
  }
}
