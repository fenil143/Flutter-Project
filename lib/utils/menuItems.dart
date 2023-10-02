import 'package:firebase_connect/ui/app/viewAllScreen.dart';
import 'package:firebase_connect/utils/dummyData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// ignore: must_be_immutable
class MyMenu extends StatelessWidget {
  String? userImage;
  String? city;
  MyMenu(this.userImage, this.city, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // city = city.toString().toLowerCase();
    return Container(
        height: 120,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: menus.length,
          itemBuilder: (context, index) {
            return Column(children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAllScreen(userImage,city,menus[index].name.toString().toLowerCase())));
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                    child: Center(child: SvgPicture.asset(menus[index].asset))),
              ),
              SizedBox(height: 10),
              Text(
                menus[index].name.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.7)),
              )
            ]);
          },
        ));
  }
}
