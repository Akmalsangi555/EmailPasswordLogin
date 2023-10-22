
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../imageUpload/image_upload.dart';
import '../imageUpload/show_uploads.dart';
import 'auth/login_screen.dart';
import '../model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("users")
        .doc(user!.uid)
        .get().then((value) {
          this.loggedInUser = UserModel.fromMap(value.data());
          setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      // AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text('Welcome', style: TextStyle(color: Colors.white, fontSize: 20),),
      //   centerTitle: true,

      // ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                  height: Get.height* 0.15,
                  width: Get.width* 0.35,
                  child: Image.asset('assets/admin_icon.png', fit: BoxFit.fill)),
              SizedBox(height: Get.height* 0.035),
              Text('Welcome Back', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

              SizedBox(height: Get.height* 0.024),
              Text('${loggedInUser.firstName}${loggedInUser.secondName}', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
              Text('${loggedInUser.email}', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
              Text('${loggedInUser.uId}', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
              SizedBox(height: Get.height* 0.02),

              TextButton(
                onPressed: () {
                  // Get.to(()=> ImageUpload());
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageUpload(
                    userID: loggedInUser.uId,
                  )));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red, // Background color of the button
                  padding: EdgeInsets.symmetric(horizontal: Get.width* 0.07, vertical: Get.height* 0.015), // Padding around the button's text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  textStyle: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 16, // Text size
                  ),
                ),
                child: Text("Upload Image", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: Get.height* 0.01),

              TextButton(
                onPressed: () {
                  Get.to(()=> ShowUploads(userId: loggedInUser.uId));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ImageUpload(
                  //   userID: loggedInUser.uId,
                  // )));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red, // Background color of the button
                  padding: EdgeInsets.symmetric(horizontal: Get.width* 0.07, vertical: Get.height* 0.015), // Padding around the button's text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  textStyle: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 16, // Text size
                  ),
                ),
                child: Text("Show Images", style: TextStyle(color: Colors.white),),
              ),

              // Container(
              //   width: Get.width* 0.3,
              //   decoration: BoxDecoration(
              //     color: Colors.red,
              //     borderRadius: BorderRadius.circular(30)
              //   ),
              //   child: TextButton(
              //     onPressed: () {
              //       logOut(context);
              //       // Get.to(()=> LoginScreen());
              //     },
              //     child: Row(
              //       children: <Widget>[
              //         Icon(Icons.logout_outlined, color: Colors.white),
              //         SizedBox(width: 8), // Add some space between the icon and text
              //         Text("Logout",
              //           style: TextStyle(color: Colors.white,
              //             fontSize: 16, fontWeight: FontWeight.bold)),
              //       ],
              //     ),
              //   ),
              // )

            ],
          ),
        ),
      ),
    );
  }
  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: 'SignOut Successfully...!');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  _appBar(){

    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      child: AppBar(title: Text('Profile', style: TextStyle(color: Colors.white),),
        actionsIconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.red,
      actions: [
        IconButton(onPressed: (){
          logOut(context);
        }, icon: Icon(Icons.logout_outlined))
      ],
      ),
      preferredSize: Size.fromHeight(appBarHeight)

    );
  }
}
