import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_database_hive/controllers/functions_and_variables.dart';
import 'package:student_database_hive/models/db_model.dart';

class AddStudentPage extends StatelessWidget {
  AddStudentPage({super.key});

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _placeController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _domainController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final dbNotifierProvider = Provider.of<DbNotifier>(context, listen: false);
    dbNotifierProvider.dpImage = null;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Add Student"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<DbNotifier>(
                builder: (context, dbNotifierData, child) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: dbNotifierData.dpImage != null
                      ? InkWell(
                          onTap: () {
                            _modalBottomSheetMenu(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              dbNotifierData.dpImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.blue,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                              iconSize: 100.0,
                              onPressed: () {
                                _modalBottomSheetMenu(context);
                              }, //dp onPress
                              icon: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 80.0,
                              )),
                        ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a name';
                        }
                        return null;
                      },
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        num? number;
                        if (value != null) {
                          number = num.tryParse(value);
                        }
                        if (value == null || value.isEmpty) {
                          return 'Enter an age';
                        }
                        if (number == null) {
                          return 'Enter age in numbers';
                        }
                        return null;
                      },
                      controller: _ageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Age',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _placeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Place',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _qualificationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Qualification',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a domain';
                        }
                        return null;
                      },
                      controller: _domainController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Domain',
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          addStudentButtonClicked(context);
                        },
                        child: const Text("Save Student"))
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Future<void> addStudentButtonClicked(context) async {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final place = _placeController.text.trim();
    final qualification = _qualificationController.text.trim();
    final domain = _domainController.text.trim();
    final imagePathString =
        Provider.of<DbNotifier>(context, listen: false).imagePath;

    if (_formKey.currentState!.validate()) {
      final student = StudentModel(
          name: name,
          age: int.parse(age),
          place: place,
          qualification: qualification,
          domain: domain,
          imagePath: imagePathString);

      Provider.of<DbNotifier>(context, listen: false).addStudent(student);
      Navigator.pop(context);
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

  getImageFromCamera(context) async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera); // getImage(source: ImageSource.camera);
      if (image != null) {
        //   setState(() {
        Provider.of<DbNotifier>(context, listen: false).setDpImage =
            File(image.path);

        Provider.of<DbNotifier>(context, listen: false).imagePath = image.path;
        //    });
      }
    } catch (e) {
      // print("Error at getImageFromCamera");
    }
  }

  getImageFromGallery(context) async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery); //getImage(source: ImageSource.gallery);
      if (image != null) {
        // setState(() {
        Provider.of<DbNotifier>(context, listen: false).setDpImage =
            File(image.path);
        Provider.of<DbNotifier>(context, listen: false).imagePath = image.path;
        //  });
      }
    } catch (e) {
      // print("Error at getImageFromCamera");
    }
  }
}
