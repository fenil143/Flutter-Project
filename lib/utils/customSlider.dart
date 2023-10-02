import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSlider extends StatelessWidget {
  int index;
  String city;
  CustomSlider({Key? key, this.index = 0, this.city = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    city = city.toString().toLowerCase();
    return Container(
      height: size.height * 0.3,
      width: size.width,
      child: Image.asset(
        "assets/images/cities/" + "${city}/photo-${index+1}.jpg",
        fit: BoxFit.cover,
      ),
    );
  }
}
