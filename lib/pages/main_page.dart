import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app/pages/add_transactoin.dart';
import 'package:money_management_app/pages/home_page.dart';
import 'package:money_management_app/pages/transactions_page.dart';


class MainPage extends StatelessWidget {
  final int index;

  MainPage({
    Key? key,
    this.index = 0,
  }) : super(key: key);

  List<Widget> pages = [
    HomePage(),
    const AllTransactions(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: index,
      length: pages.length,
      child: Scaffold(
        body: TabBarView(
          children: pages,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff3181A1),
          onPressed: () {
            Get.offAll(AddTransaction());
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.home), text: "Home"),
              Tab(icon: Icon(Icons.list), text: "Transactions"),
            ],
            labelColor: const Color(0xff3a69a9),
            unselectedLabelColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
