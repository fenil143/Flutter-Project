import 'package:flutter/material.dart';
// import "package:firebase_core/firebase_core.dart";
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../firebase_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  SplashServices splashScreen = SplashServices();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    _animation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut,
        reverseCurve: Curves.bounceIn);
    _animationController.forward();
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Scaffold(
    //     body: Center(
    //   child: Text("Welcome to our app",style:TextStyle(fontSize:30)),
    // ));

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: SvgPicture.asset(
              "assets/images/ahmedabad.svg",
              height: 130,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
