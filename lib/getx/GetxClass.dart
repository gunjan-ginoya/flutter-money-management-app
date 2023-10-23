import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetXClass extends GetxController {
  static RegExp emialRegexp = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");
  static SharedPreferences? prefs;
  static RxList listOfTransactions = [].obs;
  static RxList listOfProfileImages = [
    "lib/images/man1.png",
    "lib/images/man2.png",
    "lib/images/man3.png",
    "lib/images/woman1.png",
    "lib/images/woman2.png",
    "lib/images/woman3.png",
  ].obs;

  static RxBool isPassword = true.obs;
  static RxBool isrePassword = true.obs;
  static RxBool isUsernameValid = true.obs;
  static RxBool isEmailValid = true.obs;
  static RxBool isPasswordValid = true.obs;
  static RxBool isRePasswordValid = true.obs;

  static RxBool isEmailValidLogin = true.obs;
  static RxBool isPasswordValidLogin = true.obs;

  static Future<void> getPref() async {
    prefs = await SharedPreferences.getInstance();
  }
}
