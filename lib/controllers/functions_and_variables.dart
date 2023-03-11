import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_database_hive/models/db_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DbNotifier extends ChangeNotifier {
  //home screen

  File? dp;
  bool searchVisibility = true;
  final searchController = TextEditingController();

  List<StudentModel> studentList = [];

  set setSearchVisibility(val) {
    searchVisibility = val;
    notifyListeners();
  }

//add student
  File? dpImage;
  String? imagePath;

  set setDpImage(img) {
    dpImage = img;
    notifyListeners();
  }

  //student details
  String studentName = '',
      studentPlace = '',
      studentQualification = '',
      studentDomain = '';
  String? studentImage;
  int studentAge = 0;
  int? studentId;

  bool edit = false;

  set setEdit(val) {
    edit = val;
    notifyListeners();
  }

  // student details functions

  getImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        dpImage = File(image.path);
        imagePath = image.path;
      }
    } catch (e) {
      // print("Error at getImageFromCamera");
    }
    notifyListeners();
  }

  getImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        // setState(() {
        dpImage = File(image.path);

        imagePath = image.path;
        // });
      }
    } catch (e) {
      // print("Error at getImageFromCamera");
    }
    notifyListeners();
  }

  pageInitialize(id) {
    studentName = studentList[id].name;
    studentPlace = studentList[id].place;
    studentQualification = studentList[id].qualification;
    studentDomain = studentList[id].domain;
    studentImage = studentList[id].imagePath;
    studentAge = studentList[id].age;
    studentId = id;
  }

  //db functions

  searchStudent(String query, List studentList) {
    final suggestions = studentList.where((temp) {
      String input = query.toLowerCase();
      final name = temp.name.toString().toLowerCase();

      return name.contains(input);
    }).toList();

    studentList.clear();
    studentList.addAll(suggestions);
    notifyListeners();

    if (query == "") {
      getAllStudents();
    }
  }

  Future<void> addStudent(StudentModel value) async {
    final studentDB = await Hive.openBox<StudentModel>('student_db');
    final id = await studentDB.add(value);
    value.id = id;

    await studentDB.put(id, value);
    getAllStudents();
  }

  Future<void> getAllStudents() async {
    final studentDB = await Hive.openBox<StudentModel>('student_db');
    studentList.clear();

    studentList.addAll(studentDB.values);
    notifyListeners();
  }

  Future<void> deleteStudent(int id) async {
    final studentDB = await Hive.openBox<StudentModel>('student_db');
    await studentDB.delete(id);
    getAllStudents();
  }

  Future<void> updateStudent(StudentModel data, id) async {
    final studentDB = await Hive.openBox<StudentModel>('student_db');
    await studentDB.put(id, data);
    getAllStudents();
  }
}
