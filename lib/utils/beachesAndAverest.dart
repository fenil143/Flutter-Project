import 'package:firebase_connect/ui/app/viewAllSpecial.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

import '../model/placeModel.dart';
import '../widgets/itemBlock.dart';
// import 'dummyData.dart';

// ignore: must_be_immutable
class BeachesAndAverest extends StatelessWidget {
  String? city;
  DatabaseReference? ref;
  BuildContext? context;
  BeachesAndAverest({this.city, this.context, Key? key}) : super(key: key) {
    ref = FirebaseDatabase.instance.ref(city.toString().toLowerCase());
    if (ref != null) {
      ref = ref!.child("beaches and everest");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (ref == null) {
      return Container();
    }
    return StreamBuilder(
        stream: ref!.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            Map<dynamic, dynamic>? map =
                snapshot.data!.snapshot.value as dynamic;
            if (map == null) return Container();
            List<dynamic>? list = [];
            list = map.values.toList();
            return Container(
                height: 230,
                width: size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    PlaceModel pm = PlaceModel(
                        title: list![i]["placeName"],
                        bannerUrl: list[i]["networkUrl"],
                        like: int.parse(list[i]["likes"]),
                        description: "abc");
                    return Hero(
                      tag: "${pm.title}$i",
                      child: ItemBlock(
                        model: pm,
                        isMovie: true,
                        onTap: (model) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewAllSpecial(
                                      city!.toLowerCase(), pm.title.toString().toLowerCase())));
                        },
                      ),
                    );
                  },
                ));
          }
        });
  }
}
