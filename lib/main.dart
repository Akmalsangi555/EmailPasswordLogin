
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'view/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  Platform.isAndroid?
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyAeOwe5h2Kio0OoJ311xHqwh1so_6qyY3E',
        appId: '1:634849287827:android:d8bac5d7a27ffbb5c03766',
        messagingSenderId: '634849287827',
        projectId: 'emailpasswordlogin-5761a',
        storageBucket: 'emailpasswordlogin-5761a.appspot.com',
      )): await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Email Password Login',
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
