import "package:firebase_storage/firebase_storage.dart";
// import "package:flutter/material.dart";
import "dart:typed_data";

final FirebaseStorage _storage = FirebaseStorage.instance;

Future<String> convertImageToStorage(String childName, Uint8List file) async {
  try {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (error) {
    print("Error uploading image to Firebase Storage: $error");
    throw error;
  }
}
