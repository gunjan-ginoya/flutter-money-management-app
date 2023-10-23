import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app/Widgets/my_button.dart';
import 'package:money_management_app/pages/login_page.dart';
import 'package:money_management_app/pages/main_page.dart';
import 'package:money_management_app/pages/update_profile_Page.dart';
import '../Databases/database.dart';
import '../Widgets/profile_menu.dart';
import '../getx/GetxClass.dart';
import 'forget_password_page.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  RxString username = "".obs;
  RxString email = "".obs;
  RxString password = "".obs;
  RxBool isPassword = true.obs;
  RxString normalPassword = "".obs;
  RxString imagePath = "lib/images/user.png".obs;

  @override
  Widget build(BuildContext context) {
    DatabaseClass.getUserData(userID: GetXClass.prefs!.getString('userid'))
        .then((value) {
      username.value = value[0]['username'].toString();
      email.value = value[0]['email'].toString();
      normalPassword.value = value[0]['password'].toString();
      password.value = convertToPassword(value[0]['password'].toString());
      imagePath.value = value[0]['profileImage'].toString();
    });

    return WillPopScope(
      onWillPop: () {
        Get.offAll(MainPage());
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xF1F1F1F1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.offAll(MainPage()),
            icon: const Icon(
              Icons.chevron_left,
              color: Color(0xff3a69a9),
              size: 40,
            ),
          ),
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff3a69a9),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // -- PROFILE IMAGE
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.all(10),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey.shade300,
                          ),
                          child: Image(
                            image: AssetImage(imagePath.value),
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
                                                DatabaseClass.updateUserData(
                                                  username: username.value,
                                                  email: email.value,
                                                  password:
                                                      normalPassword.value,
                                                  userId: GetXClass.prefs!
                                                      .getString('userid'),
                                                  profileImage: GetXClass
                                                          .listOfProfileImages[
                                                      index],
                                                );
                                                build(context);
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
                const SizedBox(height: 30),

                // -- EDIT PROFILE BUTTON
                MyButton(
                    width: 300,
                    onPressed: () => Get.to(UpdateProfileScreen()),
                    buttonText: "Edit Profile"),

                const SizedBox(height: 30),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),

                // -- DETAILS
                // username
                Obx(
                  () => ProfileDetails(
                    title: username.value,
                    icon: Icons.person,
                    onPress: () {},
                    iconColor: Colors.black,
                  ),
                ),

                // email
                Obx(
                  () => ProfileDetails(
                    title: email.value,
                    icon: Icons.email,
                    onPress: () {},
                    iconColor: Colors.black,
                  ),
                ),

                // password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ProfileDetails(
                        title: isPassword.value == true
                            ? password.value
                            : normalPassword.value,
                        icon: Icons.password,
                        onPress: () {},
                        iconColor: Colors.black,
                        trailicon: IconButton(
                          onPressed: () => isPassword.value = !isPassword.value,
                          icon: const Icon(Icons.remove_red_eye),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: TextButton(
                        onPressed: () {
                          Get.to(ForgetPassword(fromProfile: true));
                        },
                        child: const Text("Forget Password?"),
                      ),
                    )
                  ],
                ),

                const Divider(
                  height: 10,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),

                // LOGOUT
                ProfileDetails(
                  title: "Logout",
                  icon: Icons.logout,
                  iconColor: Colors.black,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    Get.defaultDialog(
                      title: "LOGOUT",
                      titleStyle: const TextStyle(fontSize: 20),
                      titlePadding: const EdgeInsets.only(top: 20),
                      content: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Are you sure, you want to Logout?"),
                      ),
                      confirm: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            GetXClass.prefs!.clear();
                            GetXClass.listOfTransactions.value = [];
                            GetXClass.prefs!.setBool("isLogin", false);
                            Get.offAll(LoginPage());
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff3a69a9),
                              side: BorderSide.none),
                          child: const Text("Yes"),
                        ),
                      ),
                      cancel: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text("No"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String convertToPassword(String inputString) {
    String result = '';
    for (int i = 0; i < inputString.length; i++) {
      result += '*';
    }
    return result;
  }
}
