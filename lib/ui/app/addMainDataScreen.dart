import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";

import "../../utils/utils.dart";

// ignore: must_be_immutable
class AddMainData extends StatefulWidget {
  String city;
  AddMainData(this.city);

  @override
  State<AddMainData> createState() => _AddMainDataState(city);
}

class _AddMainDataState extends State<AddMainData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController placeNameController = TextEditingController();
  TextEditingController networkUrlController = TextEditingController();
  TextEditingController likesController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  DatabaseReference? databaseRef;
  String city;

  _AddMainDataState(this.city) {
    databaseRef = FirebaseDatabase.instance.ref(city.toString().toLowerCase());
  }

  final arr = [
    "historical places",
    "beaches and everest",
    "adventure places",
    "popular places"
  ];
  String selector = "historical places";

  @override
  void dispose() {
    placeNameController.dispose();
    networkUrlController.dispose();
    likesController.dispose();
    eventTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.white)),
          title: Text('Input Page', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      _buildTextField(
                        controller: placeNameController,
                        labelText: 'Place Name',
                        hintText: 'Enter place name',
                        icon: Icons.place,
                      ),
                      SizedBox(height: 20.0),
                      _buildTextField(
                        controller: networkUrlController,
                        labelText: 'Image URL',
                        hintText: 'Enter network URL',
                        icon: Icons.link,
                      ),
                      SizedBox(height: 20.0),
                      _buildTextField(
                        controller: likesController,
                        labelText: 'Total likes',
                        hintText: 'Enter total likes',
                        icon: Icons.thumb_up,
                      ),
                      SizedBox(height: 20.0),
                      _buildTextField(
                        controller: eventTypeController,
                        labelText: 'Event type',
                        hintText: 'Enter type of event',
                        icon: Icons.event,
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: DropdownButtonFormField<String>(
                            value: selector,
                            onChanged: (newValue) {
                              setState(() {
                                selector = newValue ?? " ";
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Select an option', // Add a label
                              labelStyle: TextStyle(color: Colors.blue),
                            ),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            items: arr.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String placeName = placeNameController.text;
                            String networkUrl = networkUrlController.text;
                            String likes = likesController.text;
                            String eventType = eventTypeController.text;

                            print("Place Name: " + placeName);
                            print("Network URL: " + networkUrl);
                            print("Likes: " + likes);
                            print("Event Type: " + eventType);
                            print("Selector : " + selector);
                            Navigator.pop(context);

                            String id = DateTime.now().millisecond.toString();
                            databaseRef!
                                .child(selector.toString().toLowerCase())
                                .child(id)
                                .set({
                              "placeName": placeName,
                              "networkUrl": networkUrl,
                              "likes": likes,
                              "eventType": eventType,
                            }).then((value) {
                              utils().toastMessage("Data Added Successfully");
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              utils().toastMessage("Something went wrong");
                            });
                          }
                        },
                        child: Text("Add data"),
                      )
                    ])))));
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required IconData icon,
  void Function()? onTap,
  bool val1 = false,
  bool val2 = false,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: val1
        ? TextInputType.number
        : val2
            ? TextInputType.multiline
            : TextInputType.text,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(
        icon,
        color: Colors.blue,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      errorStyle: TextStyle(color: Colors.red), // Error text color
    ),
    validator: val1 == false
        ? (value) {
            if (value!.isEmpty) {
              return 'This field is required';
            }
            return null;
          }
        : (value) {
            if (value!.isEmpty) {
              return "This field is required";
            }
            if (value.length != 10) {
              return "Length of phone number must be 10 characters";
            }
            return null;
          },
    onTap: onTap,
    readOnly: onTap != null,
  );
}
