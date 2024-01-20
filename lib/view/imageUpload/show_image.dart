
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/res/assets/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:email_password_login/res/colors/app_color.dart';

class ShowImages extends StatefulWidget {
  final String? userID;
  ShowImages({Key? key, this.userID}) : super(key: key);

  @override
  State<ShowImages> createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {

  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
      appBar: AppBar(
        title: Text('Show Image', style: TextStyle(color: AppColor.whiteColor),),
        centerTitle: true,
        backgroundColor: AppColor.color761113,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(color: AppColor.color761113)) :
      StreamBuilder(
        stream: FirebaseFirestore
            .instance
            .collection('users')
            .doc(widget.userID)
            .collection('images')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            /// If the data is still loading, show a loader
            return Center(
              child: CircularProgressIndicator(color: AppColor.color761113),
            );
          }
          else if(!snapshot.hasData){
            return Center(
                child: Text('No image Uploaded'),
            );
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
                print('imagesLength ${snapshot.data!.docs.length}');
                String imageUrl = snapshot.data!.docs[index]['downloadURl'] as String? ?? '';
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.02, vertical: screenHeight* 0.002),
                  child: Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.color761113, width: 2)
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage(
                              placeholder: AssetImage(ImageAssets.fadeInImage),
                              height: 300, width: screenWidth, fit: BoxFit.fill,
                              image: NetworkImage(imageUrl),
                          ),
                      ),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
