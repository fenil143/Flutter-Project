// import "dart:math";

import "package:firebase_connect/utils/utils.dart";
import "package:firebase_connect/widgets/round_button.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final databaseRef = FirebaseDatabase.instance.ref("Post");
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Add post"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextFormField(
                  maxLines: 4,
                  controller: postController,
                  decoration: InputDecoration(
                    hintText: "What is in your mind?",
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: "Add",
                  onTap: () {
                    // databaseRef.child('1').set({
                    //   "id": 1,
                    //   "title": postController.text.toString()
                    // }).then((value) {
                    //   utils().toastMessage("Post Added");
                    // }).onError((error, stackTrace) {
                    //   utils().toastMessage(error.toString());
                    // });
                    String id = DateTime.now().millisecond.toString();
                    databaseRef.child(id).set({
                      "id": id,
                      "title": postController.text.toString()
                    }).then((value) {
                      utils().toastMessage("Post Added");
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      utils().toastMessage(error.toString());
                    });

                    // databaseRef.child("Student").child("1").set({
                    //   "id":1,
                    //   "title":postController.text.toString();
                    // }).then((value) {
                    //   utils().toastMessage("Post Added");
                    // }).onError((error, stackTrace) {
                    //   utils().toastMessage(error.toString());
                    // });
                  })
            ],
          ),
        ));
  }
}
