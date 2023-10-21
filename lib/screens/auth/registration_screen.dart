import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../model/user_model.dart';
import '../home_screen.dart';
import 'login_screen.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> formKeyRegister = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var secondNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.text,
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
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),

    );
    final lastNameField = TextFormField(
      autofocus: false,
      controller: secondNameController,
      keyboardType: TextInputType.text,
      onSaved: (value){
        secondNameController.text = value!;
      },
      validator: (value) {
        RegExp regExp = RegExp(r'^.{3,}$');
        if(value!.isEmpty){
          return ("SecondName can't be empty");
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
          hintText: 'Second Name',
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
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),

    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
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
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Password',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
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
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Confirm Password',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );
    final signUpButton = Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextButton(
        onPressed: (){
          signUpWidget(emailController.text, passwordController.text);
        },
        child: Text('SignUp', textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        )
        ,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: (){
            Get.back();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(36.0),
              child: Form(
                key: formKeyRegister,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 150,
                        child: Image.asset('assets/admin_icon.png', fit: BoxFit.fill)),
                    SizedBox(height: 45),
                    firstNameField,
                    SizedBox(height: 25),
                    lastNameField,
                    SizedBox(height: 25),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 25),
                    confirmPasswordField,
                    SizedBox(height: 25),
                    signUpButton,
                    SizedBox(height: 15),

                    RichText(
                      text: TextSpan(
                          text: 'Already have an account?',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(text: ' Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent, fontSize: 18),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('clicked');
                                    Get.to(()=> LoginScreen());
                                    // navigate to desired screen
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

  signUpWidget(signUpEmail, signUpPassword) async {
    print('clicked1');
    if(formKeyRegister.currentState!.validate()){
      print('clicked11');
      await _auth.createUserWithEmailAndPassword(email: signUpEmail, password: signUpPassword)
          .then((value) => {
            postDetailsForFireStore(),
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsForFireStore() async {
    // calling our fireStore
    // calling our userModel
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uId = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.secondName = secondNameController.text;

    await firebaseFirestore.collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: 'Account created Successfully');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => HomeScreen()), (route) => false);

  }

}



