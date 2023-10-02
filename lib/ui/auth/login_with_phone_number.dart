import "dart:typed_data";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_connect/firebase_services/addUserData.dart";
import "package:firebase_connect/ui/auth/verify_code.dart";
import "package:firebase_connect/utils/utils.dart";
// import "package:firebase_connect/widgets/round_button.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import "../../utils/imagePicker.dart";

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  Uint8List? _image;

  Widget displayImage() {
    return Stack(
      children: [
        _image == null
            ? CircleAvatar(
                radius: 56,
                // backgroundImage: NetworkImage(
                //     "https://e7.pngegg.com/pngimages/753/432/png-clipart-user-profile-2018-in-sight-user-conference-expo-business-default-business-angle-service.png"),
              )
            : CircleAvatar(radius: 56, backgroundImage: MemoryImage(_image!)),
        Positioned(
            bottom: -10,
            left: 75,
            child: IconButton(
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.deepPurple,
              ),
              onPressed: selectedImage,
            ))
      ],
    );
  }

  void selectedImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {});
    _image = img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Login",
            style: TextStyle(
              fontSize: 24.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Make the text bold
              color: Colors.white, // Set the text color to white for contrast
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              displayImage(),
            ]),
            SizedBox(height: 20),
            Text(
              "Enter phone number",
              style: const TextStyle(color: Colors.grey, fontSize: 17),
            ),
            SizedBox(height: 10),
            TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneNumberController,
                decoration: InputDecoration(
                    hintText: "+1 234 3455 234",
                    suffixIcon: Icon(Icons.call_missed))),
            SizedBox(height: 60),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 20,
                  shadowColor: Theme.of(context).primaryColor,
                  minimumSize: const Size.fromHeight(60),
                ),
                child: const Text("LOGIN"),
                onPressed: () {
                  StoreData().saveMobileData(
                      number: phoneNumberController.toString(), file: _image!);
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (context) {},
                      verificationFailed: (error) {
                        utils().toastMessage(error.toString());
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyCodeScreen(
                                    verificationId: verificationId)));
                      },
                      codeAutoRetrievalTimeout: (error) {
                        utils().toastMessage(error.toString());
                      });
                })
          ]),
        ));
  }
}
