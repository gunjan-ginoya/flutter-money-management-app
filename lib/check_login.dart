  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:get/get_core/src/get_main.dart';
  import 'package:money_management_app/getx/GetxClass.dart';
  import 'package:money_management_app/pages/login_page.dart';
  import 'package:money_management_app/pages/main_page.dart';
  import 'package:lottie/lottie.dart';
  import 'Databases/database.dart';

  class CheckLogin extends StatelessWidget {
    const CheckLogin({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      GetXClass.getPref();
      DatabaseClass.createDatabase()
          .then((database) => DatabaseClass.dbHalper = database);

      Future.delayed(Duration(seconds: 3)).then((value) {
        bool? val = GetXClass.prefs!.getBool("isLogin") ?? false;
        if (val == true) {
          Get.off(MainPage());
        } else {
          Get.off(LoginPage());
        }
      });

      return Scaffold(
        body: Center(
          child: Lottie.asset('lib/images/animation_loadin.json'),
        ),
      );
    }
  }
