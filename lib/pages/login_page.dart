import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management_app/Databases/database.dart';
import 'package:money_management_app/Widgets/my_button.dart';
import 'package:money_management_app/Widgets/my_textfeild.dart';
import 'package:money_management_app/getx/GetxClass.dart';
import 'package:money_management_app/pages/forget_password_page.dart';
import 'package:money_management_app/pages/main_page.dart';
import 'package:money_management_app/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f4f6),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome back!",
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
                    controller: emailControler,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: MyTextField(
                        controller: passwordControler,
                        obscureText: GetXClass.isPassword.value,
                        hintText: "Password",
                        errorText: GetXClass.isPasswordValidLogin.value
                            ? null
                            : "Invalid password",
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
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: TextButton(
                      onPressed: () {
                        Get.to(ForgetPassword(fromProfile: false,));
                      },
                      child: const Text("Forget Password?"),
                    ),
                  ),
                ],
              ),
              // Login Button
              MyButton(
                onPressed: () {
                  GetXClass.isEmailValidLogin.value =
                      GetXClass.emialRegexp.hasMatch(emailControler.text) &&
                          emailControler.text.isNotEmpty;
                  GetXClass.isPasswordValidLogin.value =
                      passwordControler.text.isNotEmpty;

                  if (GetXClass.isEmailValidLogin.value &&
                      GetXClass.isPasswordValidLogin.value) {
                    DatabaseClass.verifyUser(userEmail: emailControler.text)
                        .then((value) {
                      if (value.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("user does't exist"),
                          ),
                        );
                      } else {
                        if (value[0]["password"].toString() ==
                            passwordControler.text) {
                          GetXClass.prefs!.setBool("isLogin", true);
                          GetXClass.prefs!
                              .setString('userid', "${value[0]['user_id']}");
                          Get.off(MainPage());
                        } else {
                          GetXClass.isPasswordValidLogin.value = false;
                        }
                      }
                    });
                  }
                },
                buttonText: "Login",
                paddding: 15,
                margin: 20,
              ),

              // Register button
              const SizedBox(height: 15),
              Column(
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      Get.to(RegisterPage());
                    },
                    child: const Text(
                      "Register Now",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff3a69a9),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
