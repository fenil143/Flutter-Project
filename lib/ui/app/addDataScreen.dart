import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "dart:math";
import '../../utils/utils.dart';

Random random = Random();

// ignore: must_be_immutable
class AddData extends StatefulWidget {
  bool val = false;
  String? city;
  String? type;
  AddData(this.val, this.city, this.type);

  @override
  State<AddData> createState() => _AddDataState(val, city, type);
}

class _AddDataState extends State<AddData> {
  String? city;
  String? type;
  DatabaseReference? databaseRef;
  _AddDataState(this.val, this.city, this.type) {
    databaseRef = FirebaseDatabase.instance.ref(city.toString().toLowerCase());
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController placeNameController = TextEditingController();
  TextEditingController networkUrlController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController facilitiesController = TextEditingController();
  TextEditingController openingTimeController = TextEditingController();
  TextEditingController closingTimeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  Color setColor = Colors.blue;
  bool val = false;

  @override
  void dispose() {
    placeNameController.dispose();
    networkUrlController.dispose();
    addressController.dispose();
    facilitiesController.dispose();
    openingTimeController.dispose();
    closingTimeController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      // timeFormat: TimeFormat.english,
    );
    if (picked != null && picked != controller) {
      final dateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        picked.hour,
        picked.minute,
      );

      final formattedTime = DateFormat('hh:mm a').format(dateTime);

      setState(() {
        controller.text = formattedTime;
      });
    }
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
                  controller: addressController,
                  labelText: 'Address',
                  hintText: 'Enter address',
                  icon: Icons.location_on,
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                  controller: facilitiesController,
                  labelText: 'Facilities',
                  hintText: 'Enter facilities',
                  icon: Icons.business,
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                  controller: openingTimeController,
                  labelText: 'Opening Time',
                  hintText: 'Select opening time',
                  icon: Icons.access_time,
                  onTap: () {
                    _selectTime(context, openingTimeController);
                  },
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                  controller: closingTimeController,
                  labelText: 'Closing Time',
                  hintText: 'Select closing time',
                  icon: Icons.access_time,
                  onTap: () {
                    _selectTime(context, closingTimeController);
                  },
                ),
                val == true ? SizedBox(height: 20.0) : Container(),
                val == true
                    ? _buildTextField(
                        controller: phoneNumberController,
                        labelText: 'Phone-Number',
                        hintText: 'Enter phone number',
                        icon: Icons.phone,
                        val1: true,
                      )
                    : Container(),
                SizedBox(height: 20.0),
                _buildTextField(
                    controller: descriptionController,
                    labelText: 'Description',
                    hintText: 'Enter description',
                    icon: Icons.description,
                    val2: true),
                SizedBox(height: 20.0),
                ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String placeName = placeNameController.text;
                        String networkUrl = networkUrlController.text;
                        String address = addressController.text;
                        String facilities = facilitiesController.text;
                        String openingTime = openingTimeController.text;
                        String closingTime = closingTimeController.text;
                        String description = descriptionController.text;
                        String date = dateController.text;

                        DateTime opening =
                            DateFormat('hh:mm a').parse(openingTime);
                        DateTime closing =
                            DateFormat('hh:mm a').parse(closingTime);

                        // TimeOfDay opening = TimeOfDay.fromDateTime(DateFormat('hh:mm a').parse(openingTime));
                        // TimeOfDay closing = TimeOfDay.fromDateTime(DateFormat('hh:mm a').parse(closingTime));

                        if (opening.isAfter(closing)) {
                          // Show an error message if closing time is not greater than opening time
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Closing time must be greater than opening time.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          print('Place Name: $placeName');
                          print('Network URL: $networkUrl');
                          print('Address: $address');
                          print('Facilities: $facilities');
                          print('Opening Time: $openingTime');
                          print('Closing Time: $closingTime');
                          print('Date: $date');
                          print('Description: $description');

                          String id = DateTime.now().millisecond.toString();
                          if (val == false) {
                            databaseRef!
                                .child(type.toString().toLowerCase())
                                .child(id)
                                .set({
                              "placeName": placeName,
                              "networkUrl": networkUrl,
                              "address": address,
                              "facilities": facilities,
                              "openingTime": openingTime,
                              "closingTime": closingTime,
                              "description": description,
                              "likes": 0,
                              "fees": (random.nextInt(500) / 10) * 10 + 100,
                            }).then((value) {
                              utils().toastMessage("Data Added Successfully");
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              utils().toastMessage("Something went wrong");
                            });
                          } else {
                            String phoneNumber = phoneNumberController.text;
                            databaseRef!
                                .child(type.toString().toLowerCase())
                                .child(id)
                                .set({
                              "placeName": placeName,
                              "networkUrl": networkUrl,
                              "address": address,
                              "facilities": facilities,
                              "openingTime": openingTime,
                              "closingTime": closingTime,
                              "description": description,
                              "likes": 0,
                              "fees": (random.nextInt(200) / 10) * 10 + 100,
                              "phoneNumber": phoneNumber,
                            }).then((value) {
                              utils().toastMessage("Data Added Successfully");
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              utils().toastMessage("Something went wrong");
                            });
                          }
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
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
}
