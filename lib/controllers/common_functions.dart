import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'functions_and_variables.dart';

getImageFromCamera(context) async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      Provider.of<DbNotifier>(context, listen: false).dpImage =
          File(image.path);
      Provider.of<DbNotifier>(context, listen: false).imagePath = image.path;
    }
  } catch (e) {
    // print("Error at getImageFromCamera");
  }
}

getImageFromGallery(context) async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      // setState(() {
      Provider.of<DbNotifier>(context, listen: false).dpImage =
          File(image.path);
      Provider.of<DbNotifier>(context, listen: false).imagePath = image.path;
      // });
    }
  } catch (e) {
    // print("Error at getImageFromCamera");
  }
}
