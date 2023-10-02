import "dart:async";

import "package:firebase_connect/utils/adventurePlaces.dart";
import "package:firebase_connect/utils/beachesAndAverest.dart";
import "package:firebase_connect/utils/getUserImage.dart";
import "package:firebase_connect/utils/historicalPlaces.dart";
import "package:firebase_connect/utils/menuItems.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
// import "package:flutter_svg/svg.dart";

import "../../utils/customSlider.dart";
import "../../utils/eventItems.dart";
// import "../../utils/myTheme.dart";
import "../../utils/utils.dart";
import "../auth/loginScreen.dart";
import "addMainDataScreen.dart";

String globalCity = " ";

class DisplayScreen extends StatefulWidget {
  final userImage;
  final city;
  DisplayScreen({required this.userImage, required this.city, super.key}) {
    globalCity = city;
  }

  @override
  State<DisplayScreen> createState() =>
      _DisplayScreenState(userImage: userImage, city: city);
}

class _DisplayScreenState extends State<DisplayScreen> {
  final userImage;
  final city;
  // late PageController pageController;
  _DisplayScreenState({required this.userImage, required this.city});

  @override
  void initState() {
    super.initState();
  }

  final userEmail = getUserEmail();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
          // backgroundColor: Colors.indigo,
          leading: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(userImage.toString()),
                ),
              )),
          title: Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(userEmail.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  Row(
                    children: [
                      Text(city.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_drop_down_outlined,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          actions: [
            IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  utils().toastMessage(error.toString());
                });
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: Container(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              displayPhoto(context, city),
              data1(),
              MyMenu(userImage, city),
              data2(context),
              HistoricalPlace(city: city, context: context),
              data3(context),
              BeachesAndAverest(city: city, context: context),
              data4(context),
              AdventurePlaces(city: city, context: context),
              data5(context),
              EventItems(city: city, context: context),
            ],
          ))),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple.withOpacity(0.7),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddMainData(city)));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  Widget displayPhoto(BuildContext context, final city) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.25,
        width: size.width,
        color: Colors.red,
        child: PageView.builder(
          itemCount: 3,
          itemBuilder: (_, i) {
            return CustomSlider(index: i, city: city);
          },
        ));
  }
}

Widget data1() {
  return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
      child: Text("SELECT CATEGORIES",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.8))));
}

Widget data2(BuildContext context) {
  DatabaseReference? ref;
  ref = FirebaseDatabase.instance.ref(globalCity.toString().toLowerCase());
  ref = ref.child("historical places");

  return StreamBuilder(
      stream: ref.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();
        else {
          Map<dynamic, dynamic>? map = snapshot.data!.snapshot.value as dynamic;
          if (map == null)
            return Container();
          else {
            return Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 11, bottom: 10),
                child: Text("HISTORICAL PLACES",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.8))));
          }
        }
      });
}

Widget data3(BuildContext context) {
  DatabaseReference? ref;
  ref = FirebaseDatabase.instance.ref(globalCity.toString().toLowerCase());
  ref = ref.child("beaches and everest");

  return StreamBuilder(
      stream: ref.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();
        else {
          Map<dynamic, dynamic>? map = snapshot.data!.snapshot.value as dynamic;
          if (map == null)
            return Container();
          else {
            return Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 11, bottom: 10),
                child: Text("BEACHES AND EVEREST",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.8))));
          }
        }
      });
}

Widget data4(BuildContext context) {
  DatabaseReference? ref;
  ref = FirebaseDatabase.instance.ref(globalCity.toString().toLowerCase());
  ref = ref.child("adventure places");

  return StreamBuilder(
      stream: ref.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();
        else {
          Map<dynamic, dynamic>? map = snapshot.data!.snapshot.value as dynamic;
          if (map == null)
            return Container();
          else {
            return Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 11, bottom: 10),
                child: Text("ADVENTURE PLACES",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.8))));
          }
        }
      });
}

Widget data5(BuildContext context) {
  DatabaseReference? ref;
  ref = FirebaseDatabase.instance.ref(globalCity.toString().toLowerCase());
  ref = ref.child("popular places");

  return StreamBuilder(
      stream: ref.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();
        else {
          Map<dynamic, dynamic>? map = snapshot.data!.snapshot.value as dynamic;
          if (map == null)
            return Container();
          else {
            return Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 11, bottom: 10),
                child: Text("POPULAR PLACES",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.8))));
          }
        }
      });
}
