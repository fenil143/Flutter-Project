import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'encodeDecode.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final _databaseRef = FirebaseDatabase.instance.ref("user-data");
String getUserImage() {
  String imageUrl = "";
  String email = auth.currentUser!.email.toString();
  String data = encodeUrl(email);
  _databaseRef.child(data).get().then((DataSnapshot dataSnapshot) {
    if (dataSnapshot.value != null) {
      dynamic data = dataSnapshot.value;
      imageUrl = data['imageUrl'];
      print('Image URL: $imageUrl');
    } else {
      print('Data not found.');
    }
  }).catchError((error) {
    print('Error: $error');
  });
  return imageUrl;
}

String getUserEmail() {
  return auth.currentUser!.email.toString();
}
