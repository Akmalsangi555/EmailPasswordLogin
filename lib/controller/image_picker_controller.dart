//
//
// import 'dart:io';
//
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ImagePickerController extends GetxController {
//   final image = Rxn<File>();
//
//   Future<void> imagePickerMethod() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       image.value = File(pickedFile.path);
//       print('selectedImage ${image.value}');
//     } else {
//       print('No image selected.');
//     }
//   }
// }
