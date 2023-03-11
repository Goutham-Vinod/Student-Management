import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'db_model.g.dart';

@HiveType(typeId: 1)
class StudentModel extends HiveObject {
  @HiveField(0)
  late int? id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late int age;
  @HiveField(3)
  late String place;
  @HiveField(4)
  late String qualification;
  @HiveField(5)
  late String domain;
  @HiveField(6)
  late String? imagePath;

  StudentModel({
    required this.name,
    required this.age,
    required this.place,
    required this.qualification,
    required this.domain,
    this.imagePath,
    this.id,
  });
}
