import "package:firebase_connect/utils/utils.dart";
// import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  } else {
    utils().toastMessage("No image has been selected");
  }
}
