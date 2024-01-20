import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_password_login/view/home/home_page.dart';
import 'package:email_password_login/res/colors/app_color.dart';
import 'package:email_password_login/view/auth/login_page.dart';
import 'package:email_password_login/res/assets/image_assets.dart';

SharedPreferences? prefs;

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool loading = true;

  sharedPrefs() async {
    loading = true;
    setState(() {});
    prefs = await SharedPreferences.getInstance();
    userLoginId = (prefs!.getString('userid'));
    print('checkUserLoginId $userLoginId');
    if (userLoginId != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    else{
      loading = false;
      setState(() {});
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  splashNavigator() {
    Timer(Duration(seconds: 3), () {
      sharedPrefs();
      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  void initState() {
    super.initState();
    splashNavigator();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child:
          SizedBox(
              height: screenHeight* 0.2,
              child: Image.asset(ImageAssets.logoImage, fit: BoxFit.fill)),),
        ],
      ),
    );
  }
}
