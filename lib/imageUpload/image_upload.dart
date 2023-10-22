import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


// images picker for picking the image
// firebase storage for uploading the image to firebaseStorage
// and cloud firestore for saving the url for for upload image to our application.

class ImageUpload extends StatefulWidget {
  final String? userID;
  ImageUpload({Key? key, this.userID}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {

  // some initialization code
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: Get.height* 0.6,
              width: Get.width,
              child: Column(
                children: [
                  Text('Upload Image'),
                  SizedBox(height: Get.height* 0.02,),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: Get.width* 0.85,
                      decoration: BoxDecoration(
                      // color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red)
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: _image == null? Center(child: Text('No Image selected')):
                                Image.file(_image!)),

                            TextButton(
                              onPressed: () {
                                imagePickerMethod();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red, // Background color of the button
                                padding: EdgeInsets.symmetric(horizontal: Get.width* 0.07, vertical: Get.height* 0.01), // Padding around the button's text
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0), // Rounded corners
                                ),
                                textStyle: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 16, // Text size
                                ),
                              ),
                              child: Text("Select Images", style: TextStyle(color: Colors.white),),
                            ),
                            TextButton(
                              onPressed: () {
                                // upload only when image has som value
                                if(_image != null){
                                  uploadImage();
                                }
                                else{
                                  showSnackBar('Please select image to upload', Duration(seconds: 1));
                                }

                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red, // Background color of the button
                                padding: EdgeInsets.symmetric(horizontal: Get.width* 0.07, vertical: Get.height* 0.01), // Padding around the button's text
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0), // Rounded corners
                                ),
                                textStyle: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 16, // Text size
                                ),
                              ),
                              child: Text("Upload Images", style: TextStyle(color: Colors.white),),
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
  // snackBar for showing error
  showSnackBar(String snackText, Duration snackBarDuration){
    final snackBar = SnackBar(content: Text(snackText), duration: snackBarDuration);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  // Uploading the image, then get the download url, and then
  // adding that downloaded url to our cloudFirestore.
  Future uploadImage() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref()
        .child('${widget.userID}/images').child("post_$postID");
    await reference.putFile(_image!);
    downloadUrl = await reference.getDownloadURL();
    print('downloadedUrl $downloadUrl');

    await firebaseFirestore
        .collection('users')
        .doc(widget.userID)
        .collection('images')
        .add({'downloadURl': downloadUrl})
        .whenComplete(() =>
        showSnackBar('Image uploaded successfully...!', Duration(seconds: 2)),
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
        showSnackBar('No file selected', Duration(milliseconds: 400));
      }
    });
  }

}
