import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app/pages/add_transactoin.dart';
import '../Databases/database.dart';
import '../getx/GetxClass.dart';

class AllTransactions extends StatelessWidget {
  const AllTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseClass.getAllTransactions(GetXClass.prefs!.getString('userid'))
        .then((value) {
      GetXClass.listOfTransactions.value = value;
      GetXClass.listOfTransactions.value =
          GetXClass.listOfTransactions.reversed.toList();
    });

    return Scaffold(
      backgroundColor: Color(0xF1F1F1F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: const Text("All Transaction", style: TextStyle(
            color: Color(0xff3a69a9),
          ),),
        ),
      ),
        body: SafeArea(
      child: Obx(
        () => Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                width: double.maxFinite,
                alignment: Alignment.center,
                child: GetXClass.listOfTransactions.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        child: const Text("No Transaction Found"),
                      )
                    : ListView.builder(
                        itemCount: GetXClass.listOfTransactions.length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      GetXClass.listOfTransactions[index]['type'] ==
                                              "income"
                                          ? '+\$${GetXClass.listOfTransactions[index]['amount']}'
                                          : '-\$${GetXClass.listOfTransactions[index]['amount']}',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: GetXClass.listOfTransactions[index]
                                                    ['type'] ==
                                                "income"
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      "${GetXClass.listOfTransactions[index]['trans_date']}",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                PopupMenuButton(
                                  onSelected: (value) {
                                    if (value == 1) {
                                      // update Transactions
                                      Get.to(
                                        AddTransaction(
                                          catagory: GetXClass.listOfTransactions
                                              .value[index]['category'],
                                          editType: GetXClass.listOfTransactions
                                              .value[index]['type'],
                                          amount: GetXClass.listOfTransactions
                                              .value[index]['amount'],
                                          editDate: GetXClass.listOfTransactions
                                              .value[index]['trans_date'],
                                          note: GetXClass.listOfTransactions
                                              .value[index]['note'],
                                          isEdit: true,
                                          trnasID: GetXClass.listOfTransactions
                                              .value[index]['trans_id'].toString(),
                                        ),
                                      );
                                    } else if (value == 2) {
                                      // delete transaction
                                      DatabaseClass.deleteTransaction(GetXClass
                                          .listOfTransactions[index]["trans_id"]
                                          .toString());

                                      DatabaseClass.getAllTransactions(
                                              GetXClass.prefs!.getString('userid')!)
                                          .then((value) => GetXClass
                                              .listOfTransactions.value = value);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    // Update
                                    const PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 10),
                                          Text("Update")
                                        ],
                                      ),
                                    ),

                                    // Delete
                                    const PopupMenuItem(
                                      value: 2,
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(
                                            // sized box with width 10
                                            width: 10,
                                          ),
                                          Text("Delete")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}
