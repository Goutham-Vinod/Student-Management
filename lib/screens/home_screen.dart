import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_database_hive/screens/add_student_page.dart';
import 'package:student_database_hive/db/db_functions.dart';
import 'package:student_database_hive/db/db_model.dart';
import 'package:student_database_hive/screens/student_details_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DbNotifier dbNotifierProvider =
        Provider.of<DbNotifier>(context, listen: false);

    dbNotifierProvider.getAllStudents();
    return Consumer<DbNotifier>(
      builder: (context, dbNotifierData, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Student Database"),
            actions: [
              Visibility(
                visible: dbNotifierData.searchVisibility,
                child: IconButton(
                    onPressed: () {
                      dbNotifierData.setSearchVisibility = false;
                    },
                    icon: const Icon(Icons.search)),
              )
            ],
          ),
          floatingActionButton: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return AddStudentPage();
              }));
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), padding: const EdgeInsets.all(20)),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: SafeArea(
              child: Column(
            children: [
              Visibility(
                visible: !dbNotifierData.searchVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: dbNotifierProvider.searchController,
                    onChanged: (temp) {
                      dbNotifierProvider.searchStudent(
                          dbNotifierProvider.searchController.text,
                          dbNotifierProvider.studentList);
                    },
                    decoration: InputDecoration(
                        hintText: "Search Here",
                        suffixIcon: IconButton(
                            onPressed: () {
                              dbNotifierProvider.searchController.clear();
                              dbNotifierProvider.getAllStudents();
                              // setState(() {
                              dbNotifierData.searchVisibility = true;
                              // });
                            },
                            icon: const Icon(Icons.clear))),
                  ),
                ),
              ),
              Expanded(
                child: dbNotifierProvider.studentList.isEmpty
                    ? const Center(child: Text("No data found"))
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          StudentModel data =
                              dbNotifierProvider.studentList[index];
                          return ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (ctx) {
                                return StudentDetailsPage(
                                    studentId: data.id, studentIndex: index);
                              }));
                            },
                            leading: data.imagePath != null
                                ? InkWell(
                                    onTap: () {},
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(
                                        File(data.imagePath!),
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(child: icoBtn(data.imagePath)),
                            title: Text(data.name),
                            subtitle: Text(data.domain),
                            trailing: IconButton(
                                onPressed: () {
                                  if (data.id != null) {
                                    _modalBottomSheetMenu(context, data.id);
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: dbNotifierProvider.studentList.length,
                      ),
              ),
            ],
          )),
        );
      },
    );
  }

  void _modalBottomSheetMenu(context, studentId) {
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
                    child: OutlinedButton(
                      onPressed: () {
                        Provider.of<DbNotifier>(context, listen: false)
                            .deleteStudent(studentId);

                        Navigator.of(builder).pop();
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder()),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(builder).pop();
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder()),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ));
        });
  }

  Widget icoBtn(imgPath) {
    if (imgPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.file(
          File(imgPath),
          //width: 100,
          //height: 100,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return IconButton(
          iconSize: 100.0,
          onPressed: () {}, //dp onPress
          icon: const Icon(
            size: 20,
            Icons.person,
            color: Colors.white,
          ));
    }
  }
}
