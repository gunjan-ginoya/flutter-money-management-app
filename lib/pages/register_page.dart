import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management_app/Databases/database.dart';
import 'package:money_management_app/Widgets/my_button.dart';
import 'package:money_management_app/Widgets/my_textfeild.dart';
import 'package:money_management_app/getx/GetxClass.dart';
import 'package:money_management_app/pages/login_page.dart';
import '../Models/user.dart';
import 'main_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  TextEditingController usernameControler = TextEditingController();
  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();
  TextEditingController repasswordControler = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfff3f4f6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Register now!",
                  style: GoogleFonts.josefinSans(
                    color: Color(0xff3a69a9),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Username
                const SizedBox(height: 30),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: MyTextField(
                      controller: usernameControler,
                      hintText: "Username",
                      errorText: GetXClass.isUsernameValid.value
                          ? null
                          : "Enter Username",
                      prefixIcon: const Icon(
                        Icons.person_2,
                      ),
                    ),
                  ),
                ),

                // E-mail
                const SizedBox(height: 15),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: MyTextField(
                      controller: emailControler,
                      errorText: GetXClass.isEmailValid.value
                          ? null
                          : "Enter valid email",
                      hintText: "Email",
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                      ),
                    ),
                  ),
                ),

                // Password
                const SizedBox(height: 15),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: MyTextField(
                      controller: passwordControler,
                      errorText: GetXClass.isPasswordValid.value
                          ? null
                          : "Enter the password",
                      obscureText: GetXClass.isPassword.value,
                      hintText: "Password",
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      endIcon: GestureDetector(
                        onTap: () {
                          GetXClass.isPassword.value =
                              !GetXClass.isPassword.value;
                        },
                        child: const Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ),
                ),

                // Repass
                const SizedBox(height: 15),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: MyTextField(
                      controller: repasswordControler,
                      obscureText: true,
                      errorText: GetXClass.isRePasswordValid.value
                          ? null
                          : "Password doesn't match",
                      hintText: "Conform Password",
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                    ),
                  ),
                ),

                // Register Button
                MyButton(
                  onPressed: () {
                    User user = User(
                      password: passwordControler.text,
                      email: emailControler.text,
                      username: usernameControler.text,
                    );

                    GetXClass.isUsernameValid.value =
                        usernameControler.text.isNotEmpty;
                    GetXClass.isEmailValid.value =
                        GetXClass.emialRegexp.hasMatch(emailControler.text) &&
                            emailControler.text.isNotEmpty;
                    GetXClass.isPasswordValid.value =
                        passwordControler.text.isNotEmpty;
                    GetXClass.isRePasswordValid.value =
                        repasswordControler.text.isNotEmpty &&
                            repasswordControler.text == passwordControler.text;

                    if (GetXClass.isUsernameValid.value &&
                        GetXClass.isEmailValid.value &&
                        GetXClass.isPasswordValid.value &&
                        GetXClass.isRePasswordValid.value) {
                      DatabaseClass.verifyUser(userEmail: user.email).then((value) {
                        if (value.isEmpty) {
                          DatabaseClass.insertData(user);
                          GetXClass.prefs!.setBool("isLogin", true);
                          DatabaseClass.verifyUser(userEmail: user.email).then((value) {
                            GetXClass.prefs!.setString("userid", "${value[0]['user_id']}");
                          });
                          Get.offAll(MainPage());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Center(
                                child: Text("user already exist"),
                              ),
                            ),
                          );
                        }
                      });
                    }
                  },
                  buttonText: "Sing up",
                  paddding: 15,
                  margin: 20,
                ),

                // Login Button
                const SizedBox(height: 15),
                Column(
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        GetXClass.isUsernameValid.value = true;
                        GetXClass.isEmailValid.value = true;
                        GetXClass.isPasswordValid.value = true;
                        GetXClass.isRePasswordValid.value = true;

                        Get.offAll(LoginPage());
                      },
                      child: const Text(
                        "Login Now",
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
      ),
    );
  }
}
