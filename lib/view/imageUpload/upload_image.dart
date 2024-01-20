
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:email_password_login/res/colors/app_color.dart';

class UploadImage extends StatefulWidget {
  final String? userID;
  UploadImage({Key? key, this.userID}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  // some initialization code
  File? _image;
  final imagePicker = ImagePicker();
  String? uploadedImageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('userIdd ${widget.userID}');
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image', style: TextStyle(color: AppColor.whiteColor)),
        centerTitle: true,
        backgroundColor: AppColor.color761113,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 550,
              width: double.infinity,
              child: Column(
                children: [
                  Text('upload Image'),
                  SizedBox(height: 10),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 350,
                      decoration: BoxDecoration(
                        // color: AppColor.color761113,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.color761113, width: 2)
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: _image == null?
                                Center(child: Text('No Image selected')):
                                Image.file(_image!),
                            ),
                            ElevatedButton(
                              child: Text('Select Images',
                                  style: TextStyle(color: AppColor.whiteColor)),
                              onPressed: (){
                                imagePickerMethod();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.color761113,
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.05,
                                      vertical: screenHeight* 0.012),
                                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                              ),
                            ),

                            ElevatedButton(
                              child: Text('Upload Images', style: TextStyle(color: AppColor.whiteColor)),
                              onPressed: (){
                                _image != null?
                                uploadImage():
                                Utils.snackBar('Image Upload', 'Please Select Image to upload', Duration(seconds: 2));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.color761113,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth* 0.04,
                                      vertical: screenHeight* 0.012),
                                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future uploadImage() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

    firebase_storage.Reference reference = storage.ref()
        .child("${widget.userID}/images").child("post_$postID");
    SettableMetadata settableMetadata = SettableMetadata(
      contentType: 'image/jpeg');

    // firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
    //   contentType: 'image/jpeg', // Adjust this based on your image type
    // );
    // Upload the file to Firebase Storage
    await reference.putFile(File(_image!.path), settableMetadata);

    // Get the download URL
    uploadedImageUrl = await reference.getDownloadURL();

    // Now you can use imageUrl for displaying or storing in your database
    print("ImageURL: $uploadedImageUrl");

    // Reference reference = FirebaseStorage.instance.ref()
    //     .child('${widget.userID}/images').child("post_$postID");
    // await reference.putFile(File(_image!.path));
    // uploadedImageUrl = await reference.getDownloadURL();
    // print('downloadedUrl $uploadedImageUrl');

    await firebaseFirestore
        .collection('users')
        .doc(widget.userID)
        .collection('images')
        .add({'downloadURl': uploadedImageUrl})
        .whenComplete(() =>
        Utils.snackBar('Image Upload', 'Image uploaded successfully...!', Duration(seconds: 2)),
    );
  }

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pick != null){
        _image = File(pick.path);
        print('pickedImage $_image');
      }
      else{
        // showing snackBar with error
        Utils.snackBar('Image Picker', 'No image file selected', Duration(seconds: 2));;
      }
    });
  }




  Future<void> uploadImageMethod() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Get a reference to the storage service, which is used to upload/download files
      firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

      // Create a reference to the location you want to upload to
      firebase_storage.Reference ref = storage.ref().child("images/${DateTime.now().toString()}");

      // Upload the file to Firebase Storage
      await ref.putFile(File(pickedFile.path));

      // Get the download URL
      String imageUrl = await ref.getDownloadURL();

      // Now you can use imageUrl for displaying or storing in your database
      print("Image URL: $imageUrl");
    }
  }

}
