import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "../../model/exploreModel.dart";
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../utils/getUserImage.dart';
import '../../utils/utils.dart';

ExploreModel exploreModel = ExploreModel(
  name: "Example Place 1",
  networkImage:
      "https://static.toiimg.com/thumb/msid-83592691,width-400,resizemode-4/83592691.jpg",
  likes: "100",
  entryFee: "\$10",
  openingTime: "9:00 AM",
  closingTime: "6:00 PM",
  facilities: "Wi-Fi, Parking, Restaurant",
  description: "A beautiful place to explore.",
  address: "123 Main Street, Cityville",
);

// ignore: must_be_immutable

// ignore: must_be_immutable
class ExploreAndBook extends StatefulWidget {
  DatabaseReference? ref;
  String networkImage = "";
  String id = "";
  // ignore: prefer_typing_uninitialized_variables
  dynamic data;
  ExploreAndBook(this.networkImage, this.id, this.data, this.ref);

  @override
  State<ExploreAndBook> createState() =>
      _ExploreAndBookState(networkImage, id, data, ref);
}

class _ExploreAndBookState extends State<ExploreAndBook> {
  String networkImage = " ";
  String id = " ";
  String? email;
  dynamic data;
  int likeCount = 0;
  bool isLiked = false;
  Razorpay? razorpay;
  DatabaseReference? ref;

  _ExploreAndBookState(this.networkImage, this.id, this.data, this.ref) {
    likeCount = (data["likes"] as int);
    email = getUserEmail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    utils().toastMessage(
        "Congratulations on your successful payment! please check your mails");
    final smtpServer = gmail('mahendrafenil8@gmail.com', 'kojc tdiv mffw czyx');
    String id = DateTime.now().millisecond.toString();

    final message = Message()
      ..from = Address('mahendrafenil8@gmail.com', 'Fenil Modi')
      ..recipients.add(email.toString())
      ..subject = 'Gujarat tourism'
      ..html =
          '<!DOCTYPE html><html><head><style>body{font-family:Arial, sans-serif;background-color:#f4f4f4;margin:0;padding:0;}.container{max-width:600px;margin:0 auto;padding:20px;background-color:#ffffff;}h1{color:#007bff;}p{font-size:16px;line-height:1.6;color:#333333;}.reservation-id{font-weight:bold;}.contact-info{font-weight:bold;color:#007bff;}</style></head><body><div class="container"><h2>Congratulations!</h2><p>Your reservation for ${data["placeName"]} has been confirmed.</p><p>Your unique reservation ID is: <span class="reservation-id">${id}</span>.</p><p>When you visit the restaurant, please show this ID to the staff for a seamless experience.</p><p>We hope you have a delightful time at the restaurant.</p><p>If you have any questions or require assistance, please don\'t hesitate to reach out to us at <span class="contact-info">${data["phoneNumber"]}</span>.</p></div></body></html>';

    try {
      await send(message, smtpServer);
      print('Message sent');
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    utils().toastMessage("ERROR HERE : ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    utils().toastMessage("EXTERNAL_WALLET IS : ${response.walletName}");
  }

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void makePayment() async {
    var options = {
      "key": "rzp_test_RXnQf9pieow87w",
      "amount": (data["fees"] as int) * 100,
      "name": email.toString(),
      "description": "Hey bro, thanks for selecting this restaurant",
      "prefill": {
        "contact": "+917990850583",
        "email": "contact@protocoderspoint.com"
      },
    };

    try {
      razorpay?.open(options);
    } catch (e) {
      utils().toastMessage("Something went wrong");
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
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          "Book And Enjoy",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 250,
              width: double.infinity,
              child: Image.network(
                networkImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      data["placeName"],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.thumb_up, color: Colors.blue),
                      SizedBox(width: 4),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          "${likeCount} Likes",
                          key: ValueKey<int>(likeCount),
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.money, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        "Pre-booking Fee: ${data["fees"]}",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Address:",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    data["address"],
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Facilities:",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: data["facilities"]
                        .toString()
                        .split(',')
                        .map((facility) => Chip(
                              label: Text(
                                facility.trim(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.blue,
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Opening and Closing Time:",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        "${data["openingTime"]} - ${data["closingTime"]}",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Description:",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    data["description"],
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: !isLiked
            ? () {
                setState(() {
                  likeCount++;
                  isLiked = true;
                  ref!.child(id).update({"likes": likeCount});
                });
              }
            : () {
                setState(() {
                  likeCount++;
                  ref!.child(id).update({"likes": likeCount});
                });
              },
        child: !isLiked
            ? Icon(Icons.thumb_up)
            : Icon(
                Icons.thumb_up,
                color: Colors.red,
              ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            makePayment();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month, color: Colors.white),
              SizedBox(width: 8.0),
              Text("Book Now",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // Background color
            onPrimary: Colors.white, // Text color
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4, // Add a subtle shadow
          ),
        ),
      ),
    );
  }
}
