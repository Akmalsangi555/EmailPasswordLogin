
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../home_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> logInFormKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  final RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");

  @override
  Widget build(BuildContext context) {

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
    );
    final loginButton = Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(30)
      ),
      child: TextButton(
          onPressed: () {
            print('clicked');
            // Get.to(()=> HomeScreen());
            signInWidget(emailController.text, passwordController.text);
          },
        child: Text('Login', textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        )
        ,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(36.0),
              child: Form(
                key: logInFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 150,
                        child: Image.asset('assets/admin_icon.png', fit: BoxFit.fill)),
                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 25),
                    loginButton,
                    SizedBox(height: 15),

                    RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(text: ' Sign up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    color: Colors.redAccent, fontSize: 18),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                              print('clicked');
                              Get.to(()=> RegistrationScreen());
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
  signInWidget(loginEmail, loginPassword) async {
    print('clicked1');
    if(logInFormKey.currentState!.validate()){
      print('clicked11');
      await _auth.signInWithEmailAndPassword(email: loginEmail, password: loginPassword)
          .then((uid) => {
            Fluttertoast.showToast(msg: 'Login Successful'),
        Get.off(HomeScreen(), preventDuplicates: true),
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
