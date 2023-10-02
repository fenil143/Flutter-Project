import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_connect/ui/app/homeScreen.dart";
// import "package:firebase_connect/ui/posts/post_screen.dart";
import "package:flutter/material.dart";

import "../../utils/utils.dart";
// import "../../widgets/round_button.dart";

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;

  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final verificationCodeController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Verification",
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
            SizedBox(height: 80),
            Text(
              "Enter one time password",
              style: const TextStyle(color: Colors.grey, fontSize: 17),
            ),
            SizedBox(height: 15),
            TextFormField(
                keyboardType: TextInputType.number,
                controller: verificationCodeController,
                decoration:
                    InputDecoration(suffixIcon: Icon(Icons.call_missed))),
            SizedBox(height: 60),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 20,
                  shadowColor: Theme.of(context).primaryColor,
                  minimumSize: const Size.fromHeight(60),
                ),
                child: const Text("VERIFY"),
                onPressed: () async {
                  final crendital = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verificationCodeController.text.toString());

                  try {
                    await auth.signInWithCredential(crendital);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const homeScreen()));
                  } catch (e) {
                    utils().toastMessage(e.toString());
                  }
                })
          ]),
        ));
  }
}
