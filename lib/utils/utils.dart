
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_password_login/res/colors/app_color.dart';

class Utils {

  static toastMessageSuccess(String message){
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColor.colorGreen,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
      textColor: AppColor.whiteColor
    );
  }
  static toastMessageFailed(String message){
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: AppColor.blackColor,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        textColor: AppColor.whiteColor
    );
  }

  static snackBar(String title, String message, timeDuration){
    Get.snackbar(
        title, message,
        snackPosition: SnackPosition.BOTTOM,
        duration: timeDuration,
        backgroundColor: AppColor.color761113,
        colorText: AppColor.whiteColor);
  }
}