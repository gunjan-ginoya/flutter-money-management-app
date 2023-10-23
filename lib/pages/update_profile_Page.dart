import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app/Widgets/my_button.dart';
import 'package:money_management_app/Widgets/my_textfeild.dart';
import 'package:money_management_app/pages/main_page.dart';
import 'package:money_management_app/pages/profile_page.dart';

import '../Databases/database.dart';
import '../getx/GetxClass.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({Key? key}) : super(key: key);
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RxBool isUsernameValid = true.obs;
  RxBool isEmailValid = true.obs;
  RxBool isPasswordValid = true.obs;
  RxBool isPassword = true.obs;
  RxString userProfile = ''.obs;
  RxMap userData = {}.obs;
  String userid = "";
  @override
  Widget build(BuildContext context) {
    DatabaseClass.getUserData(
      userID: GetXClass.prefs!.getString('userid'),
    ).then(
      (value) {
        userProfile.value = value[0]['profileImage'].toString();
        _usernameController.text = value[0]['username'].toString();
        _emailController.text = value[0]["email"].toString();
        _passwordController.text = value[0]["password"].toString();
        userid = value[0]["user_id"].toString();
      },
    );

    return WillPopScope(
      onWillPop: () {
        Get.offAll(ProfileScreen());
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xF1F1F1F1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.offAll(ProfileScreen()),
            icon: const Icon(
              Icons.chevron_left,
              color: Color(0xff3a69a9),
              size: 40,
            ),
          ),
          centerTitle: true,
          title: const Text(
            "Edit Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff3a69a9),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // -- IMAGE with ICON
                Stack(
                  children: [
                    Obx(
                      () => Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(userProfile.value),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      height: 400,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: GridView.builder(
                                        itemCount: GetXClass
                                            .listOfProfileImages.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        itemBuilder: (context, index) {
                                          return Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                userProfile.value = GetXClass
                                                    .listOfProfileImages[index];
                                                Get.back();
                                              },
                                              child: Container(
                                                height: 130,
                                                width: 130,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                      GetXClass
                                                              .listOfProfileImages[
                                                          index],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0xff6ba1e5),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // -- Form Fields
                Column(
                  children: [
                    // Username
                    Obx(
                      () => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: MyTextField(
                          errorText: isUsernameValid.value == true
                              ? ""
                              : "Enter Valid Username",
                          controller: _usernameController,
                          hintText: "Username",
                          prefixIcon: const Icon(Icons.person_2_rounded),
                        ),
                      ),
                    ),

                    // Email
                    const SizedBox(height: 10),
                    Obx(
                      () => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: MyTextField(
                          errorText:
                              isEmailValid.value ? "" : "Enter Valid Email",
                          controller: _emailController,
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email_rounded),
                        ),
                      ),
                    ),

                    // Password
                    const SizedBox(height: 10),
                    Obx(
                      () => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: MyTextField(
                          errorText: isPasswordValid.value == true
                              ? ""
                              : "Enter Valid Password",
                          obscureText: isPassword.value,
                          controller: _passwordController,
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.password_outlined),
                          endIcon: IconButton(
                            onPressed: () =>
                                isPassword.value = !isPassword.value,
                            icon: const Icon(Icons.remove_red_eye),
                          ),
                        ),
                      ),
                    ),

                    // -- Form Submit Button
                    MyButton(
                      onPressed: () {
                        isEmailValid.value = GetXClass.emialRegexp
                                .hasMatch(_emailController.text) &&
                            _emailController.text.isNotEmpty;
                        isPasswordValid.value =
                            _passwordController.text.isNotEmpty;
                        isUsernameValid.value =
                            _usernameController.text.isNotEmpty;

                        if (isUsernameValid.value &&
                            isEmailValid.value &&
                            isPasswordValid.value) {
                          if (isEmailValid.value && isPasswordValid.value) {
                            DatabaseClass.verifyUser(
                                    userEmail: _emailController.text)
                                .then((value) {
                              // print("Value: $value");
                              if (value.isEmpty) {
                                DatabaseClass.updateUserData(
                                  username: _usernameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  userId: GetXClass.prefs!.getString('userid'),
                                  profileImage: userProfile.value,
                                );
                                Get.back();
                              } else {
                                if(value[0]["user_id"].toString() == userid)
                                {
                                  DatabaseClass.updateUserData(
                                    username: _usernameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    userId: GetXClass.prefs!.getString('userid'),
                                    profileImage: userProfile.value,
                                  );
                                  Get.back();
                                }else{
                                  isEmailValid.value = false;
                                }
                              }
                            });
                          }

                        }
                      },
                      buttonText: "Update Details",
                    ),
                    const SizedBox(height: 20),
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
