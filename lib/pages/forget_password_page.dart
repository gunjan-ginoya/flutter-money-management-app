import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management_app/Databases/database.dart';
import 'package:money_management_app/pages/login_page.dart';
import 'package:money_management_app/pages/main_page.dart';
import '../Widgets/my_button.dart';
import '../Widgets/my_textfeild.dart';
import '../getx/GetxClass.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({
    Key? key,
    required this.fromProfile,
  }) : super(key: key);

  TextEditingController _emailControler = TextEditingController();
  TextEditingController _passwordControler = TextEditingController();
  RxBool isEmailValidLogin = true.obs;
  RxBool isPasswordValidLogin = true.obs;

  bool fromProfile;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (fromProfile == true) {
          Get.offAll(MainPage(index: 0));
        } else {
          Get.offAll(LoginPage());
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff3f4f6),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              if (fromProfile == true) {
                Get.offAll(MainPage(index: 0));
              } else {
                Get.offAll(LoginPage());
              }
            },
            icon: const Icon(
              Icons.chevron_left,
              color: Color(0xff3a69a9),
              size: 40,
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reset Password",
                  style: GoogleFonts.josefinSans(
                    color: const Color(0xff3a69a9),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Email
                const SizedBox(height: 30),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: MyTextField(
                      controller: _emailControler,
                      errorText: GetXClass.isEmailValidLogin.value
                          ? null
                          : "Enter valid emial",
                      hintText: "Email",
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password
                Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: MyTextField(
                      controller: _passwordControler,
                      obscureText: GetXClass.isPassword.value,
                      hintText: "Reset Password",
                      errorText: GetXClass.isPasswordValidLogin.value
                          ? null
                          : "Enter the password",
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      endIcon: GestureDetector(
                          onTap: () {
                            GetXClass.isPassword.value =
                                !GetXClass.isPassword.value;
                          },
                          child: const Icon(Icons.remove_red_eye)),
                    ),
                  ),
                ),

                // Login Button
                MyButton(
                  onPressed: () {
                    isEmailValidLogin.value =
                        GetXClass.emialRegexp.hasMatch(_emailControler.text) &&
                            _emailControler.text.isNotEmpty;
                    isPasswordValidLogin.value =
                        _passwordControler.text.isNotEmpty;

                    if (GetXClass.isEmailValidLogin.value &&
                        GetXClass.isPasswordValidLogin.value) {
                      // reset/update password
                      DatabaseClass.updatePassword(
                        email: _emailControler.text,
                        password: _passwordControler.text,
                      );
                      if (fromProfile == true) {
                        Get.offAll(MainPage(index: 0));
                      } else {
                        Get.offAll(LoginPage());
                      }
                    }
                  },
                  buttonText: "Reset Password",
                  paddding: 15,
                  margin: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
