
import 'package:shared_preferences/shared_preferences.dart';

import 'register_page.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_password_login/utils/utils.dart';
import 'package:email_password_login/view/home/home_page.dart';
import 'package:email_password_login/res/colors/app_color.dart';
import 'package:email_password_login/res/assets/image_assets.dart';
import 'package:email_password_login/controller/shared_pref_service.dart';

String? userLoginId;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> formKeyLogIn = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final SharedPreferencesService _prefs = SharedPreferencesService();

  final RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,

      onSaved: (value){
        emailController.text = value!;
        },
      validator: (value) {
      if(value!.isEmpty){
        return 'Please Enter your Email';
      }
      if(!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value)){
        return ('Please Enter a valid Email');
      }
      return null;
    },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
      prefixIcon: Icon(Icons.email_outlined),
      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          // enabledBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          //     borderSide: BorderSide(color: Color(0xffF6F6F6))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColor.color761113, width: 2)),
      hintText: 'Email',
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
      )
  ),

);

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (value){
        passwordController.text = value!;
      },
      validator: (value) {
        RegExp regExp = RegExp(r'^.{6,}$');
        if(value!.isEmpty){
          return ('Please Enter your Password');
        }
        if(!regExp.hasMatch(value)){
          return 'Enter valid Password (Min 6 Character)';
        }
        return null;
      },

      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Password',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColor.color761113, width: 2)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: AppColor.color761113,
      child: MaterialButton(
        onPressed: (){
          signIn(emailController.text, passwordController.text);
        },
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: screenWidth,
        child: Text('Login', style: TextStyle(color: AppColor.whiteColor, fontSize: 20),),
      ),

    );

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: AppColor.whiteColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.1),
              child: Form(
                key: formKeyLogIn,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: screenHeight* 0.2,
                        child: Image.asset(ImageAssets.logoImage, fit: BoxFit.fill)),
                    SizedBox(height: screenHeight* 0.07),
                    emailField,
                    SizedBox(height: screenHeight* 0.02),
                    passwordField,
                    SizedBox(height: screenHeight* 0.04),
                    loginButton,
                    SizedBox(height: screenHeight* 0.02),
                    RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(text: ' Sign up',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.color761113, fontSize: 20),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                    Get.to(()=> RegistrationPage(),
                                      transition: Transition.noTransition,
                                      duration: Duration(milliseconds: 0));
                            }
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String userEmail, String userPassword) async {

    if(formKeyLogIn.currentState!.validate()){
      try {
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );

        // Save user ID to shared preferences on successful login
        SharedPreferences sharedPref = await SharedPreferences.getInstance();
        await sharedPref.setString('userid', "${result.user!.uid.toString()}");
        userLoginId = result.user!.uid;
        // _prefs.saveUserId(userLoginId!);
        print('userLoginId ${userLoginId}');

        Utils.toastMessageSuccess('Login Successful');
        Get.off(HomePage(),
            preventDuplicates: true,
            transition: Transition.noTransition,
            duration: Duration(milliseconds: 0));
      } catch (e) {
        print('error message ${e.toString()}');
        Utils.toastMessageFailed(e.toString());
      }


      // await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword)
      //     .then((uid) => {
      //       Utils.toastMessageSuccess('Login Successful'),
      //
      //   Get.off(HomePage(), preventDuplicates: true,
      //     transition: Transition.noTransition,
      //     duration: Duration(milliseconds: 0)),
      // }).catchError((e){
      //   print('error message ${e!.toString()}');
      //   return Utils.toastMessageFailed(e.toString());
      //
      // });
    }
  }
}
