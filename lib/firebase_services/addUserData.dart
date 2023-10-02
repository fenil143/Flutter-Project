import "package:firebase_connect/utils/convertImageToStorage.dart";
import "package:firebase_connect/utils/encodeDecode.dart";
import "package:firebase_connect/utils/utils.dart";
import "package:firebase_database/firebase_database.dart";
import "dart:typed_data";

// import "package:firebase_storage/firebase_storage.dart";

// final auth = FirebaseAuth.instance;

final _databaseRef = FirebaseDatabase.instance.ref("user-data");

class StoreData {
  Future<void> saveData(
      {required String name,
      required String bio,
      required Uint8List file}) async {
    try {
      if (name.isNotEmpty || bio.isNotEmpty) {
        String imageUrl = await convertImageToStorage("profileImage", file);
        String path = encodeUrl(name);
        await _databaseRef
            .child(path)
            .set({"email": name, "imageUrl": imageUrl});
      }
    } catch (error) {
      utils().toastMessage(error.toString());
    }
  }

  Future<void> saveMobileData(
      {required String number, required Uint8List file}) async {
    try {
      String imageUrl = await convertImageToStorage("profileImage", file);
      await _databaseRef
          .child(number.toString())
          .set({"number": number, "imageUrl": imageUrl});
    } catch (error) {
      utils().toastMessage(error.toString());
    }
  }
}

class Uint8LIst {}
