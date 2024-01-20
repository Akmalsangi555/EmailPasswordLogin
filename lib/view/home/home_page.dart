
import 'dart:async';
import 'package:email_password_login/view/splash/splash_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/utils/utils.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/res/colors/app_color.dart';
import 'package:email_password_login/view/auth/login_page.dart';
import 'package:email_password_login/res/assets/image_assets.dart';
import 'package:email_password_login/view/imageUpload/show_image.dart';
import 'package:email_password_login/view/imageUpload/upload_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
          this.loggedInUser = UserModel.fromMap(value.data());
          setState(() {});
        });

    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false; // Set loading state to false after 3 seconds
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: _appBar(),
      body: _isLoading ? Center(child: CircularProgressIndicator(color: AppColor.color761113)) :
      Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight* 0.1),
              SizedBox(
                  height: screenHeight* 0.2,
                  child: Image.asset(ImageAssets.logoImage, fit: BoxFit.fill)),
              SizedBox(height: screenHeight* 0.07),
              Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back', style: TextStyle(color: AppColor.blackColor,
                      fontWeight: FontWeight.bold, fontSize: 25)),
                  SizedBox(height: screenHeight* 0.01),
                  Text('${loggedInUser.firstName} ${loggedInUser.lastName}',
                      style: TextStyle(color: AppColor.blackColor,
                          fontWeight: FontWeight.w500, fontSize: 14)),
                  Text('${loggedInUser.email}', style: TextStyle(fontSize: 14,
                      color: AppColor.blackColor, fontWeight: FontWeight.w500)),
                  Text('${loggedInUser.uId}', style: TextStyle(fontSize: 14,
                      color: AppColor.blackColor, fontWeight: FontWeight.w500)),
                ],
              ),

              SizedBox(height: screenHeight* 0.01),

              ElevatedButton(
                child: Text('Upload Images',
                    style: TextStyle(color: AppColor.whiteColor)),
                onPressed: (){
                  print('userId ${loggedInUser.uId}');
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => UploadImage(userID: loggedInUser.uId)));
                  // Get.to(()=> UploadImage(
                  //   userId: loggedInUser.uid,
                  // ),
                  //     transition: Transition.noTransition,
                  //     duration: Duration(milliseconds: 0));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.color761113,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.05,
                        vertical: screenHeight* 0.012),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),

              ElevatedButton(
                child: Text('Show Images', style: TextStyle(color: AppColor.whiteColor)),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ShowImages(userID: loggedInUser.uId)));

                  // Get.to(()=> ShowImages(),
                  //     transition: Transition.noTransition,
                  //     duration: Duration(milliseconds: 0));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.color761113,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth* 0.06,
                        vertical: screenHeight* 0.012),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
          ],
          ),
        ),
      ),
    );
  }

  // Future<void> logOut(BuildContext context) async {
  //   await FirebaseAuth.instance.signOut();
  //   Utils.toastMessageSuccess('SignOut Successfully...!');
  //   Get.offAll(()=> LoginPage());
  // }

  _appBar(){
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(title: Text('Home Page', style: TextStyle(color: AppColor.whiteColor),),
          actionsIconTheme: IconThemeData(
              color: AppColor.whiteColor
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.color761113,
          actions: [
            IconButton(onPressed: (){
              showLogoutAlertDialog(context);
            }, icon: Icon(Icons.logout_outlined))
          ],
        ),
        preferredSize: Size.fromHeight(appBarHeight)

    );
  }

  showLogoutAlertDialog(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget cancelButtons =  ElevatedButton(
      child: Text('Cancel',
          style: TextStyle(color: AppColor.whiteColor)),
      onPressed: (){
        Navigator.of(context, rootNavigator: true).pop();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.color761113,
          padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.07,
              vertical: screenHeight* 0.012),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
      ),
    );

    Widget continueButton =  ElevatedButton(
      child: Text('Continue',
          style: TextStyle(color: AppColor.whiteColor)),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        removeDataFormSharedPreferences();
        Utils.toastMessageSuccess('SignOut Successfully...!');
        setState(() {});
        Get.offAll(()=> LoginPage());
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.color761113,
          padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.05,
              vertical: screenHeight* 0.012),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      backgroundColor: Colors.grey.shade200,
      title: Text("Sign Out", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
      content: Text("Are you sure you want to Sign Out?"),
      actions: [
        cancelButtons,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  removeDataFormSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await prefs!.clear();
    setState(() {});
  }
}
