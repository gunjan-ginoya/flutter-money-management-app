import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app/getx/GetxClass.dart';
import 'package:money_management_app/pages/profile_page.dart';
import '../Databases/database.dart';

class HomePage extends StatelessWidget {
  static RxDouble totalExpenses = 0.0.obs;
  static RxDouble totalIncome = 0.0.obs;
  static RxDouble totalBalance = 0.0.obs;
  static RxMap userData = {}.obs;

  @override
  Widget build(BuildContext context) {
    DatabaseClass.getAllTransactions(GetXClass.prefs!.getString('userid'))
        .then((value) {
      GetXClass.listOfTransactions.value = value;
      getAllAmounts();
      GetXClass.listOfTransactions.value =
          GetXClass.listOfTransactions.reversed.toList();
    });

    DatabaseClass.getUserData(userID: GetXClass.prefs!.getString('userid'))
        .then((value) {
      userData.value = value[0];
    });

    return Scaffold(
      backgroundColor: const Color(0xF1F1F1F1),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Container(
                          height: 80,
                          width: 80,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image(
                              image: AssetImage(
                                  "${userData.value["profileImage"]}")),
                        ),),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Welcome",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ),
                            Obx(
                              () => Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "${userData.value["username"]}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(ProfileScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.settings,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Total Balance card
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff116E93),
                      Color(0xff3181A1),
                      Color(0xff5094AE),
                      Color(0xff70A7BC),
                      Color(0xff70A7BC),
                      Color(0xff8FB9CA),
                      Color(0xff8FB9CA),
                      Color(0xffAFCCD8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    bottom: 40,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Total Balance
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: Obx(
                          () => Text(
                            '\$${totalBalance.value.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Income and Expenses
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // total income
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white24,
                                ),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.arrow_upward_outlined,
                                  color: Colors.greenAccent,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Income',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  Obx(
                                    () => Text(
                                      '\$${totalIncome.value.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // total expense
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white24,
                                ),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.arrow_downward_outlined,
                                  color: Colors.redAccent,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Expenses',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  Obx(
                                    () => Text(
                                      '\$${totalExpenses.value.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Recent transactions
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(
                  () => GetXClass.listOfTransactions.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text("No Transaction"),
                          ),
                        )
                      : ListView.builder(
                          itemCount: GetXClass.listOfTransactions.value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${GetXClass.listOfTransactions[index]['note']}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "${GetXClass.listOfTransactions[index]['type']}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        GetXClass.listOfTransactions[index]
                                                    ['type'] ==
                                                "income"
                                            ? '+\$${GetXClass.listOfTransactions[index]['amount']}'
                                            : '-\$${GetXClass.listOfTransactions[index]['amount']}',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: GetXClass.listOfTransactions[
                                                      index]['type'] ==
                                                  "income"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      Text(
                                        "${GetXClass.listOfTransactions[index]['trans_date']}",
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void getAllAmounts() {
    totalBalance.value = 0.0;
    totalIncome.value = 0.0;
    totalExpenses.value = 0.0;

    if (GetXClass.listOfTransactions.isNotEmpty) {
      for (int i = 0; i < GetXClass.listOfTransactions.length; i++) {
        if (GetXClass.listOfTransactions[i]['type'] == 'income') {
          totalIncome.value +=
              double.parse(GetXClass.listOfTransactions[i]['amount']);
        } else if (GetXClass.listOfTransactions[i]['type'] == 'expense') {
          totalExpenses.value +=
              double.parse(GetXClass.listOfTransactions[i]['amount']);
        }
      }
    }
    totalBalance.value = totalIncome.value - totalExpenses.value;

    print("!! total income: ${totalIncome.value}");
    print("!! total expense: ${totalExpenses.value}");
    print("!! total balance: ${totalBalance.value}");
  }
}
