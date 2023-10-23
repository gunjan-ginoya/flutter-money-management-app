import 'package:money_management_app/Models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClass {
  static Database? dbHalper;

  static Future<Database> createDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE UserData (user_id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT, profileImage TEXT)');
      await db.execute(
          'CREATE TABLE `user_transaction` (trans_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER , amount TEXT, type TEXT, category TEXT,note TEXT, trans_date TEXT, FOREIGN KEY(user_id) REFERENCES UserData(user_id))');
    });
    return database;
  }

  static void updateUserData({
    required String username,
    required String email,
    required String password,
    required String? userId,
    required String profileImage,
  }) {
    String sql =
        "UPDATE UserData SET username = '$username', email = '$email',password='$password', profileImage = '$profileImage' WHERE user_id = '$userId'";
    dbHalper!.rawDelete(sql);
  }

  static void insertData(User user) {
    String sql =
        "INSERT INTO UserData (username, email, password, profileImage) VALUES('${user.username}', '${user.email}', '${user.password}', '${user.profileImage}')";
    dbHalper!.rawInsert(sql);
  }

  static Future<List<Map<String, Object?>>> verifyUser(
      {required String userEmail}) async {
    String sql = "SELECT * FROM UserData WHERE email = '${userEmail}'";
    return await dbHalper!.rawQuery(sql);
  }

  static Future<List<Map<String, Object?>>> getAllTransactions(
      String? id) async {
    String sql = "SELECT * FROM user_transaction WHERE user_id = '$id'";
    return await dbHalper!.rawQuery(sql);
  }

  static void insertTransaction(
      {required String userID,
      required String amount,
      required String category,
      required String note,
      required String date,
      required String type}) {
    String sql =
        "INSERT INTO user_transaction (user_id, amount, type, category ,note, trans_date) VALUES ('$userID','$amount','$type','$category', '$note', '$date')";
    dbHalper!.rawInsert(sql);
  }

  static void updateTransaction({
    required String amount,
    required String type,
    required String category,
    required String note,
    required String date,
    required String trans_id,
  }) {
    String sql =
        "UPDATE user_transaction SET amount = '$amount', type = '$type', category = '$category', note = '$note' WHERE trans_id = '$trans_id'";
    dbHalper!.rawUpdate(sql);
  }

  static updatePassword({required String email, required String password}) {
    String sql =
        "UPDATE UserData SET password = '$password' WHERE email = '$email'";
    dbHalper!.rawUpdate(sql);
  }

  static void deleteTransaction(String id) {
    String sql = "DELETE FROM user_transaction WHERE trans_id = '$id'";
    dbHalper!.rawDelete(sql);
  }

  static Future<List<Map<String, Object?>>> getUserData(
      {required String? userID}) {
    String sql = "SELECT * FROM UserData WHERE user_id = '$userID'";
    return dbHalper!.rawQuery(sql);
  }
}
