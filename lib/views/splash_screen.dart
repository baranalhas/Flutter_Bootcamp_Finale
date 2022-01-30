import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String getName = "";
  @override
  void initState() {
    Timer(Duration(seconds: 3), checkAccount);
    super.initState();
  }
  Future<void> checkAccount() async{
    var sp = await SharedPreferences.getInstance();
    getName = sp.getString("username") ?? "";
    if(getName.isEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(getName)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('lib/entity/lottie/food2.json',reverse: true),
      ),
    );
  }
}
