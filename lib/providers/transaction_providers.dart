import 'dart:math';
import 'package:expensetracker/api/google_sheets_api.dart';
import 'package:expensetracker/db/transactionDB.dart';
import 'package:expensetracker/models/transactions.dart';
import 'package:flutter/cupertino.dart';

class TransactionProviders with ChangeNotifier {
  var write;
  List<Transactions> transactions = [
    // Transactions(
    //     date:
    //         "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
    //     Account: "krungthi2",
    //     Category: "fool",
    //     Note: "Night fool",
    //     Amount: "200"),
  ];
  GoogleSheetsApi googlesheet = GoogleSheetsApi();

  List put_incomeANDexpense() {
    List package = [];
    int income = 0;
    int expanse = 0;
    for (var index in transactions) {
      if (index.Expanse) {
        income = int.parse(index.Amount) + income;
      } else {
        expanse = int.parse(index.Amount) + expanse;
      }
    }
    package.insert(0, income);
    package.insert(1, expanse);
    return package;
  }

  List<Transactions> getTransaction() {
    var x = transactions[0];
    print("taansactions => ${x.Account}");
    return transactions;
  }

  Search_Data(stores) async {
    var db = await transactionDB(dbName: "Transaction.db");
    if (stores == "Money_management") {
      transactions = await db.loadALLdata(stores);
      notifyListeners();
      print("Serch_data successfully");
      return transactions;
    }
    if (stores == "google_sheet") {
      googlesheet = await db.loadALLdata(stores);
      notifyListeners();
      print("Serch_data Google sheet successfully");
      return googlesheet;
    }
    
  }

  Add_data(Transactions statement) async {
    var db = await transactionDB(dbName: "Transaction.db");
    // Transactions statement = Transactions(
    //     date:
    //         "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
    //     Account: "krungthi2",
    //     Category: "fool",
    //     Note: "Night fool",
    //     Amount: "200");
    await db.add_database(statement, "Money_management");
    Search_Data("Money_management");
  }

  update_data(Transactions statement) async {
    var db = await transactionDB(dbName: "Transaction.db");
    // Transactions statement = Transactions(
    //     date:
    //         "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
    //     Account: "krungthi2222",
    //     Category: "foolll",
    //     Note: "Night foollll",
    //     Amount: "2000",
    //     key: 7);
    await db.update_database(statement, "Money_management");
    Search_Data("Money_management");
  }

  delete_data(specify) async {
    var db = await transactionDB(dbName: "Transaction.db");
    await db.delete_database(specify, "Money_management");
    Search_Data("Money_management");
  }

  provider_setgoogleSheet() async {
    var db = await transactionDB(dbName: "Transaction.db");
    await db.setGoogleSheet();
    Search_Data("google_sheet");
  }
}
