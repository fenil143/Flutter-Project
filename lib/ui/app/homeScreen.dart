import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_connect/ui/app/displayScreen.dart';
import 'package:firebase_connect/utils/encodeDecode.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/utils.dart';
import '../auth/loginScreen.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

List<String> tempCities = [
  "Kutch",
  "Banaskantha",
  "Mehsana",
  "Sabarkantha",
  "Gandhinagar",
  "Aravalli",
  "Mahisagar",
  "Kheda",
  "Ahmedabad",
  "Surendranagar",
  "Morbi",
  "Jamnagar",
  "Dwarka",
  "Junagadh",
  "Gir Somnath",
  "Rajkot",
  "Amreli",
  "Botad",
  "Bhavnagar",
  "Dahod",
  "Panchmahal",
  "Anand",
  "Vadodara",
  "Chhota Udaipur",
  "Bharuch",
  "Surat",
  "Tapi",
  "Navsari",
  "Dang",
  "Daman",
  "Valsad",
];

List<String> cities = [
  "Ahmedabad",
  "Surat",
  "Rajkot",
  "Kutch",
  "Valsad",
  "Jamnagar"
];
List svgs = [
  SvgPicture.asset('assets/images/ahmedabad.svg',
      height: 50, width: 50, color: Colors.black),
  SvgPicture.asset('assets/images/surat.svg',
      height: 50, width: 50, color: Colors.black),
  SvgPicture.asset('assets/images/rajkot.svg',
      height: 35, width: 35, color: Colors.black.withOpacity(0.7)),
  SvgPicture.asset('assets/images/kutch.svg',
      height: 35, width: 35, color: Colors.black.withOpacity(0.7)),
  SvgPicture.asset('assets/images/valsad.svg',
      height: 40, width: 40, color: Colors.black.withOpacity(0.7)),
  SvgPicture.asset('assets/images/jamnagar.svg',
      height: 35, width: 35, color: Colors.black.withOpacity(0.7)),
];

class _homeScreenState extends State<homeScreen> {
  List<String> allCities = [];
  TextEditingController searchString = TextEditingController();
  final auth = FirebaseAuth.instance;
  final _databaseRef = FirebaseDatabase.instance.ref("user-data");
  String imageUrl = " ";

  @override
  void initState() {
    super.initState();
    tempCities.sort();
    allCities = tempCities;
    setImage();
  }

  void fun(String query) {
    setState(() {
      allCities = tempCities.where((city) {
        return city
            .toString()
            .toLowerCase()
            .contains(searchString.text.toLowerCase());
      }).toList();
    });
  }

  void setImage() {
    String email = auth.currentUser!.email.toString();
    String data = encodeUrl(email);
    _databaseRef.child(data).get().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        dynamic data = dataSnapshot.value;
        setState(() {
          imageUrl = data['imageUrl'];
        });
        print('Image URL: $imageUrl');
      } else {
        print('Data not found.');
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color(0xFFD9E4EE),
        child: SingleChildScrollView(
            child: Stack(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: 270,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.6),
                      Theme.of(context).primaryColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)))),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                          IconButton(
                            onPressed: () {
                              auth.signOut().then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              }).onError((error, stackTrace) {
                                utils().toastMessage(error.toString());
                              });
                            },
                            icon: Icon(
                              Icons.logout_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                    SizedBox(height: 10),
                    Text("Hello, excursionist",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 10),
                    Text("Your Enjoyment is Our\nFirst Priority",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 15, bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ]),
                        child: TextFormField(
                            controller: searchString,
                            onChanged: fun,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search city here...",
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              prefixIcon: Icon(Icons.search, size: 25),
                            )))
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text("   Popular cities",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.8))),
              SizedBox(height: 10),
              Container(
                  height: 120,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DisplayScreen(
                                          userImage: imageUrl,
                                          city: cities[index].toString(),
                                        )));
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Color(0xFFF2F8FF),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    )
                                  ]),
                              child: Center(child: svgs[index])),
                        ),
                        SizedBox(height: 10),
                        Text(
                          cities[index].toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.7)),
                        )
                      ]);
                    },
                  )),
              SizedBox(height: 10),
              Text("   Another cities",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.8))),
              SizedBox(height: 10),
              Column(
                  children: allCities.map((city) {
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  leading: Icon(Icons.location_city, color: Colors.blue),
                  title: Text(
                    city,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'State: Gujarat',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayScreen(
                                userImage: imageUrl, city: city)));
                  },
                );
              }).toList()),
            ]),
          )
        ])));
  }
}
