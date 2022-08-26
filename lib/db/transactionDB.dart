import 'dart:io';
import 'package:expensetracker/models/transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class transactionDB {
  var dbName;
  transactionDB({this.dbName});

  Future openDatabase() async {
    // Search address database
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);
    // create database
    DatabaseFactory dbFctory = await databaseFactoryIo;
    Database db = await dbFctory.openDatabase(dbLocation);
     print("OPEN_database => $db");
    return db;
  }

  add_database(Transactions statement) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("Money_management3");

    var key = await store.add(db, {});
    await store.record(key).update(db, {
      "Account": statement.Account,
      "Category": statement.Category,
      "Note": statement.Note,
      "Amount": statement.Amount,
      "Date": statement.date.toIso8601String(),
      "Expense": statement.Expanse,
      "key": key.toString()
    });
    db.close();
    print("key => ${key}");
    return key;
  }

  update_database(Transactions statement) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("Money_management3");

    await store.record(statement.key).update(db, {
      "Account": statement.Account,
      "Category": statement.Category,
      "Note": statement.Note,
      "Amount": statement.Amount,
      "Date": statement.date.toIso8601String(),
      "Expense": statement.Expanse
    });
    print("Amount =>>>> ${statement.Amount}");
    db.close();
  }

  delete_database(spcify) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("Money_management3");
    if (spcify == null) {
      // delete all data
      await store.delete(db);
    } else {
      // delete only selecten item
      await store.record(spcify).delete(db);
    }
    db.close();
  }

  Future loadALLdata() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("Money_management3");

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));

    List<Transactions> transactionlist = [];
    for (var recoed in snapshot) {
      // print("recoed_Key => ${recoed["key"]}");
      transactionlist.add(Transactions(
          Account: recoed["Account"],
          Category: recoed["Category"],
          Note: recoed["Note"],
          Amount: recoed["Amount"],
          date: recoed["Date"],
          Expanse: recoed["Expense"],
          key: recoed["key"]));
    }
    print("Snapshot => $snapshot");
    return transactionlist;
  }
}
