import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app/Databases/database.dart';
import 'package:money_management_app/Widgets/my_button.dart';
import 'package:money_management_app/Widgets/my_textfeild.dart';
import 'package:money_management_app/getx/GetxClass.dart';
import 'package:money_management_app/pages/main_page.dart';

class AddTransaction extends StatelessWidget {
  String amount;
  String note;
  String catagory;
  String editDate;
  String editType;
  bool isEdit;
  String? trnasID;

  AddTransaction({
    Key? key,
    this.amount = "",
    this.note = "",
    this.catagory = "Food",
    this.editDate = "",
    this.editType = "expense",
    this.isEdit = false,
    this.trnasID,
  }) : super(key: key);

  TextEditingController _transactionAmount = TextEditingController();
  TextEditingController _note = TextEditingController();
  RxString dropDownValue = "Food".obs;
  RxString date = formatDate(DateTime.now(), [dd, '-', M, '-', yyyy]).obs;
  RxBool isAmountValid = true.obs;
  RxBool isNoteValid = true.obs;
  RxBool isIncome = false.obs;

  @override
  Widget build(BuildContext context) {
    dropDownValue.value = catagory;
    isIncome.value = editType == 'expense' ? false : true;
    _transactionAmount.text = amount;
    _note.text = note;
    date.value = editDate.isEmpty ? formatDate(DateTime.now(), [dd, '-', M, '-', yyyy]) : editDate;

    return WillPopScope(
      onWillPop: () {
        if (isEdit == true) {
          Get.offAll(MainPage(index: 1));
        } else {
          Get.offAll(MainPage());
        }
        // Get.offAll(MainPage());
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xF1FAFAFA),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isEdit ? "Update Transaction" :
                  "Add Transaction",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3a69a9),
                  ),
                ),

                // Type
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 300,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Income
                      GestureDetector(
                        onTap: () {
                          isIncome.value = true;
                        },
                        child: Obx(
                          () => Container(
                            height: 70,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: isIncome.value
                                  ? const Color(0xff3a69a9)
                                  : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Income",
                              style: TextStyle(
                                color: isIncome.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Expense
                      GestureDetector(
                        onTap: () {
                          isIncome.value = false;
                        },
                        child: Obx(
                          () => Container(
                            height: 70,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: isIncome.value
                                  ? Colors.transparent
                                  : const Color(0xff3a69a9),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Expence",
                              style: TextStyle(
                                color: isIncome.value
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Amount
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: 300,
                  child: Obx(
                    () => MyTextField(
                      controller: _transactionAmount,
                      errorText: isAmountValid.value ? null : "Enter Amount",
                      hintText: "0",
                      keyboardType: TextInputType.number,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.currency_rupee),
                      ),
                    ),
                  ),
                ),

                // Category
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: DropdownButton(
                        isExpanded: true,
                        icon: const Icon(
                          Icons.list,
                          color: Color(0xff3a69a9),
                        ),
                        underline: Container(
                          height: 0,
                        ),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(30),
                        items: const [
                          DropdownMenuItem(
                            value: 'Food',
                            child: Text('Food'),
                          ),
                          DropdownMenuItem(
                            value: 'Movies',
                            child: Text('Movies'),
                          ),
                          DropdownMenuItem(
                            value: 'Salary',
                            child: Text('Salary'),
                          ),
                          DropdownMenuItem(
                            value: 'Transfers',
                            child: Text('Transfers'),
                          ),
                          DropdownMenuItem(
                            value: 'Bonus',
                            child: Text('Bonus'),
                          ),
                        ],
                        onChanged: (value) {
                          dropDownValue.value = value!;
                        },
                        value: dropDownValue.value,
                      ),
                    ),
                  ),
                ),

                // Note
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: 300,
                  child: Obx(
                    () => MyTextField(
                      controller: _note,
                      hintText: "Note",
                      errorText: isNoteValid.value ? null : "Enter valid note",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.note, size: 20),
                      ),
                    ),
                  ),
                ),

                // Date
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 31)),
                            lastDate: DateTime.now(),
                          );
                          date.value =
                              formatDate(pickedDate!, [dd, '-', M, '-', yyyy]);
                        },
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Color(0xff3a69a9),
                        ),
                      ),
                      Obx(() => Text(date.value)),
                    ],
                  ),
                ),

                // Add Transaction Button
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 330,
                  child: MyButton(
                    onPressed: () {
                      isAmountValid.value =
                          _transactionAmount.text.isEmpty ? false : true;
                      isNoteValid.value = _note.text.isEmpty ? false : true;
                      String type = isIncome.value ? "income" : "expense";

                      if(isEdit == true){
                        DatabaseClass.updateTransaction(
                          trans_id: trnasID!,
                          amount: _transactionAmount.text,
                          category: dropDownValue.value,
                          note: _note.text,
                          type: type,
                          date: date.value,
                        );
                        Get.offAll(MainPage(index: 0,));
                      }else {
                        if (isAmountValid.value == true &&
                            isNoteValid.value == true) {
                          DatabaseClass.insertTransaction(
                            userID: "${GetXClass.prefs!.getString('userid')}",
                            amount: _transactionAmount.text,
                            category: dropDownValue.value,
                            note: _note.text,
                            type: type,
                            date: date.value,
                          );
                          Get.offAll(MainPage());
                        }
                      }
                    },
                    buttonText: isEdit ? "Save Transaction" : "Add Transaction",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}