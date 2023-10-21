
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome', style: TextStyle(color: Colors.white, fontSize: 20),),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                  height: 100,
                  child: Image.asset('assets/admin_icon.png', fit: BoxFit.fill)),
              SizedBox(height: 30),
              Text('Welcome Back', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

              SizedBox(height: 20),
              Text('${loggedInUser.firstName}${loggedInUser.secondName}', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
              Text('${loggedInUser.email}', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
              SizedBox(height: 20),

              Container(
                width: Get.width* 0.3,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TextButton(
                  onPressed: () {
                    logOut(context);
                    // Get.to(()=> LoginScreen());
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.logout_outlined, color: Colors.white),
                      SizedBox(width: 8), // Add some space between the icon and text
                      Text("Logout",
                        style: TextStyle(color: Colors.white,
                          fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )

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
}
