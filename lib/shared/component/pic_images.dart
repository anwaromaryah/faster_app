

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File> pickImage(BuildContext context) async {

  var image;

  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if( pickedImage != null ) {
        image = File(pickedImage.path);
        return image;
    }
  } catch (e) {
    print("error ${e}");
  }
  return File("");

}