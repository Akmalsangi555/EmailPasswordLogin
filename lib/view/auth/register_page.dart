
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/utils/utils.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/view/home/home_page.dart';
import 'package:email_password_login/res/colors/app_color.dart';
import 'package:email_password_login/view/auth/login_page.dart';
import 'package:email_password_login/res/assets/image_assets.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final GlobalKey<FormState> formKeyRegister = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      onSaved: (value){
        firstNameController.text = value!;
      },
      validator: (value) {
        RegExp regExp = RegExp(r'^.{3,}$');
        if(value!.isEmpty){
          return ("FirstName can't be empty");
        }
        if(!regExp.hasMatch(value)){
          return 'Enter valid name (Min 3 Character) ';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'First Name',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColor.color761113, width: 2)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameController,
      keyboardType: TextInputType.name,
      onSaved: (value){
        lastNameController.text = value!;
      },
      validator: (value) {
        // RegExp regExp = RegExp(r'^.{3,}$');
        if(value!.isEmpty){
          return ("SecondName can't be empty");
        }
        // if(!regExp.hasMatch(value)){
        //   return 'Enter valid name (Min 3 Character) ';
        // }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Last Name',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColor.color761113, width: 2)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );

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
          hintText: 'Email',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColor.color761113, width: 2)),
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
          return 'Please Enter valid Password (Min 6 Character) ';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
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

    final confirmPasswordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: confirmPasswordController,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (value){
        confirmPasswordController.text = value!;
      },
      validator: (value) {
        if(confirmPasswordController.text != passwordController.text){
          return "Password don't match";
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Confirm Password',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColor.color761113, width: 2)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: AppColor.color761113,
      child: MaterialButton(
        onPressed: (){
          signUp(emailController.text, passwordController.text);
        },
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: screenWidth,
        child: Text('Register', style: TextStyle(color: AppColor.whiteColor, fontSize: 20),),
      ),

    );
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: AppColor.color761113),
      //     onPressed: (){
      //       Get.back();
      //     },
      //   ),
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: AppColor.whiteColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.1),
              child: Form(
                key: formKeyRegister,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: screenHeight* 0.2,
                        child: Image.asset(ImageAssets.logoImage, fit: BoxFit.fill)),
                    SizedBox(height: screenHeight* 0.03),
                    firstNameField,
                    SizedBox(height: screenHeight* 0.02),
                    lastNameField,
                    SizedBox(height: screenHeight* 0.02),
                    emailField,
                    SizedBox(height: screenHeight* 0.02),
                    passwordField,
                    SizedBox(height: screenHeight* 0.02),
                    confirmPasswordField,
                    SizedBox(height: screenHeight* 0.02),
                    registerButton,
                    SizedBox(height: screenHeight* 0.02),
                    RichText(
                      text: TextSpan(
                          text: 'Already have an account?',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(text: ' Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.color761113, fontSize: 20),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('clicked');
                                    Get.to(()=> LoginPage(),
                                      transition: Transition.noTransition,
                                      duration: Duration(milliseconds: 0));
                                  }
                            )
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

  void signUp(String userEmail, String userPassword) async {

    if(formKeyRegister.currentState!.validate()){
      await _auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword)
          .then((value) => {
            postDetailsToFireStore(),
      }).catchError((e){
        return Utils.toastMessageFailed(e.toString());
      });
    }
  }

  postDetailsToFireStore() async {
    // calling our firestore
    // calling our userModel
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uId = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.lastName = lastNameController.text;

    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap());
    Utils.toastMessageSuccess('Account created successfully');
    Get.offAll(() => HomePage(),
      transition: Transition.noTransition,
      duration: Duration(milliseconds: 0));
  }
}
