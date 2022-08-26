import 'dart:math';
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

  List put_incomeANDexpense() {
    List package = [];
    int income = 0;
    int expanse = 0;
    for (var index in transactions) {
      if (index.Expanse == false) {
        expanse = int.parse(index.Amount) + expanse;
      } else {
        income = int.parse(index.Amount) + income;
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

  Search_Data() async {
    var db = await transactionDB(dbName: "Transaction.db");
    transactions = await db.loadALLdata();
    for (var index in transactions) {
      // print(
      //     "Account => ${index.Account} Category => ${index.Category} Note => ${index.Note} Amount =>${index.Amount} Key => ${index.key.toString()}");
    }
    notifyListeners();
    print("Serch_data successfully");
    return transactions;
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
    await db.add_database(statement);
    Search_Data();
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
    await db.update_database(statement);
    Search_Data();
  }

  delete_data(specify) async {
    var db = await transactionDB(dbName: "Transaction.db");
    await db.delete_database(specify);
    Search_Data();
  }

  chack_googlesheet_Writing(Write) {
    write = Write;
    print("provider write = $transactions");
    
  }
}
