import "dart:typed_data";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_connect/firebase_services/addUserData.dart";
// import "package:firebase_connect/ui/auth/loginScreen.dart";
import "package:firebase_connect/utils/imagePicker.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import "../../utils/utils.dart";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late Color myColor;
  late Size mediaSize;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool rememberUser = false;
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/welcome.jpg"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: Container()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome",
          style: TextStyle(
              color: myColor, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Please sign-in with your information"),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          displayImage(),
        ]),
        const SizedBox(height: 10),
        _buildGreyText("Email address"),
        _buildInputField(emailController),
        const SizedBox(height: 40),
        _buildGreyText("Password"),
        _buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 25),
        ForNoAccount(),
        // _buildRememberForgot(),
        const SizedBox(height: 25),
        _buildLoginButton(),
      ],
    );
  }

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

  Widget ForNoAccount() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Already have an-account?",
          style: TextStyle(color: Color.fromRGBO(136, 3, 244, 1))),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Login"))
    ]);
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        login();
        debugPrint("Email : ${emailController.text}");
        debugPrint("Password : ${passwordController.text}");
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("Sign-up"),
    );
  }

  void login() async {
    try {
      StoreData().saveData(
          name: emailController.text.toString(),
          bio: passwordController.text.toString(),
          file: _image!);
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );
      utils().toastMessage(
        "Your account has been created successfully",
        check: true,
      );
      Navigator.pop(context);
    } catch (error) {
      utils().toastMessage(error.toString());
    }
  }
}
