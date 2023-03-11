import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_database_hive/controllers/functions_and_variables.dart';
import 'package:student_database_hive/models/db_model.dart';
import 'package:student_database_hive/views/screens/home_screen.dart';
import 'package:student_database_hive/controllers/common_functions.dart';

class StudentDetailsPage extends StatelessWidget {
  StudentDetailsPage({
    super.key,
    required this.studentId,
    required this.studentIndex,
  });

  int? studentId;
  int? studentIndex;

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController placeController;
  late TextEditingController qualificationController;
  late TextEditingController domainController;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DbNotifier dbNotifierProvider = Provider.of<DbNotifier>(context);

    dbNotifierProvider.pageInitialize(studentIndex);

    nameController = TextEditingController()
      ..text = dbNotifierProvider.studentName;
    ageController = TextEditingController()
      ..text = dbNotifierProvider.studentAge.toString();
    placeController = TextEditingController()
      ..text = dbNotifierProvider.studentPlace;
    qualificationController = TextEditingController()
      ..text = dbNotifierProvider.studentQualification;
    domainController = TextEditingController()
      ..text = dbNotifierProvider.studentDomain;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Student Details"),
          actions: [
            IconButton(
                onPressed: () {
                  dbNotifierProvider.setEdit = true;
                },
                icon: const Icon(Icons.edit)),
          ],
        ),
        body: Consumer<DbNotifier>(
          builder: (context, value, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.blue,
                          shape: CircleBorder(),
                        ),
                        child: dbNotifierProvider.studentImage != null
                            ? InkWell(
                                onTap: () {
                                  _modalBottomSheetMenu(context);
                                },
                                child: dbNotifierProvider.imagePath != null
                                    ? InkWell(
                                        onTap: () {
                                          _modalBottomSheetMenu(context);
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.file(
                                            File(dbNotifierProvider.imagePath!),
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          File(
                                              dbNotifierProvider.studentImage!),
                                          width: 130,
                                          height: 130,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              )
                            : CircleAvatar(
                                radius: 60,
                                child: dbNotifierProvider.imagePath != null
                                    ? InkWell(
                                        onTap: () {
                                          _modalBottomSheetMenu(context);
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.file(
                                            File(dbNotifierProvider.imagePath!),
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : IconButton(
                                        iconSize: 50.0,
                                        onPressed: () {
                                          _modalBottomSheetMenu(
                                              context); //dp onPress
                                        },
                                        icon: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 50.0,
                                        )),
                              ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            enabled: dbNotifierProvider.edit,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Name",
                              disabledBorder: InputBorder.none,
                              border: OutlineInputBorder(),
                              hintText: "Name",
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            enabled: dbNotifierProvider.edit,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an age';
                              }
                              return null;
                            },
                            controller: ageController
                              ..text = dbNotifierProvider.studentAge.toString(),
                            decoration: const InputDecoration(
                              labelText: "Age",
                              disabledBorder: InputBorder.none,
                              border: OutlineInputBorder(),
                              hintText: 'Age',
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            enabled: dbNotifierProvider.edit,
                            controller: placeController
                              ..text = dbNotifierProvider.studentPlace,
                            decoration: const InputDecoration(
                              labelText: "Place",
                              disabledBorder: InputBorder.none,
                              border: OutlineInputBorder(),
                              hintText: 'Place',
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            enabled: dbNotifierProvider.edit,
                            controller: qualificationController
                              ..text = dbNotifierProvider.studentQualification,
                            decoration: const InputDecoration(
                              labelText: "Qualification",
                              disabledBorder: InputBorder.none,
                              border: OutlineInputBorder(),
                              hintText: 'Qualification',
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            enabled: dbNotifierProvider.edit,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a domain';
                              }
                              return null;
                            },
                            controller: domainController
                              ..text = dbNotifierProvider.studentDomain,
                            decoration: const InputDecoration(
                              labelText: "Domain",
                              disabledBorder: InputBorder.none,
                              border: OutlineInputBorder(),
                              hintText: 'Domain',
                            ),
                          ),
                          Visibility(
                            visible: dbNotifierProvider.edit,
                            child: ElevatedButton(
                                onPressed: () {
                                  updateStudentButtonClicked(
                                      studentId, context);
                                  //Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) {
                                    return const HomeScreen();
                                  }));
                                },
                                child: const Text("Update Student")),
                          )
                        ],
                      ),
                    )
                  ],
                )),
              ),
            );
          },
        ));
  }

  Future<void> updateStudentButtonClicked(id, context) async {
    final name = nameController.text.trim();
    final age = ageController.text.trim();
    final place = placeController.text.trim();
    final qualification = qualificationController.text.trim();
    final domain = domainController.text.trim();

    if (_formKey.currentState!.validate()) {
      if (Provider.of<DbNotifier>(context, listen: false).imagePath != null) {
        final student = StudentModel(
            name: name,
            age: int.parse(age),
            place: place,
            qualification: qualification,
            domain: domain,
            imagePath:
                Provider.of<DbNotifier>(context, listen: false).imagePath,
            id: id);
        Provider.of<DbNotifier>(context, listen: false)
            .updateStudent(student, id);
        Navigator.pop(context, true);
      } else {
        final student = StudentModel(
            name: name,
            age: int.parse(age),
            place: place,
            qualification: qualification,
            domain: domain,
            imagePath:
                Provider.of<DbNotifier>(context, listen: false).studentImage,
            id: id);
        Provider.of<DbNotifier>(context, listen: false)
            .updateStudent(student, id);
        Navigator.pop(context, true);
      }
    }
  }

  void _modalBottomSheetMenu(context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (builder) {
          return Container(
              height: 100,
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        getImageFromCamera(context);
                        Navigator.of(builder).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      child: const Text(
                        'Camera',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        getImageFromGallery(context);
                        Navigator.of(builder).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      child: const Text('Gallery'),
                    ),
                  ),
                ],
              ));
        });
  }
}
