import 'dart:io';
import 'package:expensetracker/api/google_sheets_api.dart';
import 'package:expensetracker/models/transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class transactionDB {
  final dbName;
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

  add_database(Transactions statement, stores) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store(stores);

    var key = await store.add(db, {});
    if (stores == "Money_management") {
      await store.record(key).update(db, {
        "Account": statement.Account,
        "Category": statement.Category,
        "Note": statement.Note,
        "Amount": statement.Amount,
        "Date": statement.date.toIso8601String(),
        "Expense": statement.Expanse,
        "key": key.toString()
      });
    }

    db.close();
    print("key => ${key}");
    return key;
  }

  update_database(Transactions statement, stores) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store(stores);

    if (stores == "Money_management") {
      await store.record(statement.key).update(db, {
        "Account": statement.Account,
        "Category": statement.Category,
        "Note": statement.Note,
        "Amount": statement.Amount,
        "Date": statement.date.toIso8601String(),
        "Expense": statement.Expanse
      });
    }
    db.close();
  }

  delete_database(spcify, stores) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store(stores);
    if (spcify == null) {
      // delete all data
      await store.delete(db);
    } else {
      // delete only selecten item
      await store.record(spcify).delete(db);
    }
    db.close();
  }

  Future loadALLdata(stores) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store(stores);
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));

    List<Transactions> transactionlist = [];
    GoogleSheetsApi google_sheet = GoogleSheetsApi();
    if (stores == "Money_management") {
      for (var record in snapshot) {
        transactionlist.add(Transactions(
            Account: record["Account"],
            Category: record["Category"],
            Note: record["Note"],
            Amount: record["Amount"],
            date: record["Date"],
            Expanse: record["Expense"],
            key: record["key"]));
      }
      print("Snapshot => $snapshot");
      return transactionlist;
    }
    if (stores == "google_sheet") {
      for (var record in snapshot) {
        google_sheet = GoogleSheetsApi(
            sheetid: record["sheetid"], credentials: record["credentials"]);
      }
      print("Snapshot => $snapshot");
      return google_sheet;
    }
  }

  setGoogleSheet() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("google_sheet");
    GoogleSheetsApi check = await loadALLdata("google_sheet");
    if (check.sheetid == null) {
      await store.add(db, {
        "sheetid": '10rsI5_MFxTew7UAkLj2ARSg1qqXhhQY6986sqMp4SQw',
        "credentials": r'''
{
  "type": "service_account",
  "project_id": "flutter-gsheet-tutorial-350314",
  "private_key_id": "054dfa90527d95ee5187da309699047d2dd7ae8b",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDLYc2z91lF2uf7\nGyyyRpHudPTNcNLc8hJUIJoZj4pOsUQSxFiSTBmyJmqO0NI3XkF3dzLl0zPlzo++\nDtnFpVUxnOW6817lvBjgV2e9u2Po7RtfW94IyDOZ2Eylq6XIn8QKDTH8G6JfB5DG\nVr2KVTbaTKUqs/JpeHMyd0iYk35FkI5EsvReq2kbvc2URNxQ0tpS1Tfa7bRn+9/i\nTYG4a9p/YL14KEh/vnHX8EYCMkwxjUD9HHmw7eRTuliplrvF1M9oBZ1mngk/1bke\nQbOfgYKAsHlQDduklHyRRt7H+6lDg6/3YxqRW8NWQOTpuOqp2pQbmLpnlZ/K+Xb0\noER4SvzxAgMBAAECggEAJPkQtii/N+3FwmZ8R6SAnwLwBfD+xF/VaSnMGd14XTno\nkCjVmTLwcOx+7puTu7EM4bTvscwlYR+eDgURHdcil7RYJxZbKBR7yTzahSltzkhc\nc4d1487RYqRpuqxrpP82WkVv0s8LQ49SiFv4dQ9su163n/26keXtuzzoG6SkjeyY\ni0AP/8Che4w5925PLaqOir6A7yUbJEaPHMGe/0s5kMCGqX/8jy1LER5QnRmqvdi6\nN/Q4oExSXjiC4fbn4oIB1OQd4iHIwtselY4HuquThBbV/S80JsqySomxWC7bkdqb\nHWga8zKR1Zrq2Kt0EQ7xS3puXkrC6WdWP/Mdoyc4aQKBgQDs0v8lpcPXbuBGpmUd\nuM47JFPATwsow181RmrIOG03uM0+ez4HZs9j1mogIVbz7Is5i3+iQCwaPL4Rp4Ce\nHivPhHH0NELLzRUc5m3zu0O7baCfF9AcE81w7BNkliLsrk4cB/kAfVu83AuY/hTQ\npA4OUDPWCbx7vj8a4HE0vzvFtwKBgQDb2Zof8scjvgS6+pasrIXMk/JISCfxgZgU\n0GKJWUUNhnS9IPT0JdRRuaQFZu6D0DbX8THofYAGHRyoE+HnpfyI9XSS2DPmJymb\n/RxOYWX/duJtMUvxt5C+x7XHbD6thsQanhSIG7PwIHYBtk2T7kUlF64UyJKt86sc\nct7hLPGSlwKBgDNUxILnfBxs5uXJWS9pCCJfjFuphlSujCti+PAu8tVaE/qQAfDe\nwuLz7YrLTyqNwduWNfL4D9ccBWKUONeM2JghMAXrcfL0n7fk5j4m/9ZXO7JgGfaM\nAEKSmN17gVRlr3555+nIQiMcWtMtd1uFw5osnh+tepIjuU/dCAyTyqPfAoGBAMlO\nSdMhMXkn4Br5o4f+/RDjE0FeWLzJxmCgoulTBWiqCjC3gbQhA3XFv0t3AcVOnTlD\n0EgqylROydOZSQwcr80UvCZNs8/1YiNEM2wNwSCXUiNbtUdipzYZlfhBxG6N7PjW\ncMRkYXHpt0RAEm73CPc65JqBQdXoPXDyOeUDizuHAoGAcupfFL6NBBKgj+TzCdix\nAjACUNsGZaL8QBKPBEzSZqNFA/WtfL9KQMljMSvkz5jRRPo5EovRRARgsMFW0M2h\n405DzfyGhrB5Cr7OW92UOFBVKSotTs2/LAnCJQ9nSKzW53xUS2vlYV2PQk9LAfav\nuiJwLximvRZ082/FClyW/Xs=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheet-tutorial@flutter-gsheet-tutorial-350314.iam.gserviceaccount.com",
  "client_id": "115317755060375975764",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheet-tutorial%40flutter-gsheet-tutorial-350314.iam.gserviceaccount.com"
}
  '''
      });
      print("google sheet add");
    } else {
      await store.record(1).update(db, {
        "sheetid": '555',
        "credentials": r'''
{
  "type": "service_account",
  "project_id": "flutter-gsheet-tutorial-350314",
  "private_key_id": "054dfa90527d95ee5187da309699047d2dd7ae8b",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDLYc2z91lF2uf7\nGyyyRpHudPTNcNLc8hJUIJoZj4pOsUQSxFiSTBmyJmqO0NI3XkF3dzLl0zPlzo++\nDtnFpVUxnOW6817lvBjgV2e9u2Po7RtfW94IyDOZ2Eylq6XIn8QKDTH8G6JfB5DG\nVr2KVTbaTKUqs/JpeHMyd0iYk35FkI5EsvReq2kbvc2URNxQ0tpS1Tfa7bRn+9/i\nTYG4a9p/YL14KEh/vnHX8EYCMkwxjUD9HHmw7eRTuliplrvF1M9oBZ1mngk/1bke\nQbOfgYKAsHlQDduklHyRRt7H+6lDg6/3YxqRW8NWQOTpuOqp2pQbmLpnlZ/K+Xb0\noER4SvzxAgMBAAECggEAJPkQtii/N+3FwmZ8R6SAnwLwBfD+xF/VaSnMGd14XTno\nkCjVmTLwcOx+7puTu7EM4bTvscwlYR+eDgURHdcil7RYJxZbKBR7yTzahSltzkhc\nc4d1487RYqRpuqxrpP82WkVv0s8LQ49SiFv4dQ9su163n/26keXtuzzoG6SkjeyY\ni0AP/8Che4w5925PLaqOir6A7yUbJEaPHMGe/0s5kMCGqX/8jy1LER5QnRmqvdi6\nN/Q4oExSXjiC4fbn4oIB1OQd4iHIwtselY4HuquThBbV/S80JsqySomxWC7bkdqb\nHWga8zKR1Zrq2Kt0EQ7xS3puXkrC6WdWP/Mdoyc4aQKBgQDs0v8lpcPXbuBGpmUd\nuM47JFPATwsow181RmrIOG03uM0+ez4HZs9j1mogIVbz7Is5i3+iQCwaPL4Rp4Ce\nHivPhHH0NELLzRUc5m3zu0O7baCfF9AcE81w7BNkliLsrk4cB/kAfVu83AuY/hTQ\npA4OUDPWCbx7vj8a4HE0vzvFtwKBgQDb2Zof8scjvgS6+pasrIXMk/JISCfxgZgU\n0GKJWUUNhnS9IPT0JdRRuaQFZu6D0DbX8THofYAGHRyoE+HnpfyI9XSS2DPmJymb\n/RxOYWX/duJtMUvxt5C+x7XHbD6thsQanhSIG7PwIHYBtk2T7kUlF64UyJKt86sc\nct7hLPGSlwKBgDNUxILnfBxs5uXJWS9pCCJfjFuphlSujCti+PAu8tVaE/qQAfDe\nwuLz7YrLTyqNwduWNfL4D9ccBWKUONeM2JghMAXrcfL0n7fk5j4m/9ZXO7JgGfaM\nAEKSmN17gVRlr3555+nIQiMcWtMtd1uFw5osnh+tepIjuU/dCAyTyqPfAoGBAMlO\nSdMhMXkn4Br5o4f+/RDjE0FeWLzJxmCgoulTBWiqCjC3gbQhA3XFv0t3AcVOnTlD\n0EgqylROydOZSQwcr80UvCZNs8/1YiNEM2wNwSCXUiNbtUdipzYZlfhBxG6N7PjW\ncMRkYXHpt0RAEm73CPc65JqBQdXoPXDyOeUDizuHAoGAcupfFL6NBBKgj+TzCdix\nAjACUNsGZaL8QBKPBEzSZqNFA/WtfL9KQMljMSvkz5jRRPo5EovRRARgsMFW0M2h\n405DzfyGhrB5Cr7OW92UOFBVKSotTs2/LAnCJQ9nSKzW53xUS2vlYV2PQk9LAfav\nuiJwLximvRZ082/FClyW/Xs=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheet-tutorial@flutter-gsheet-tutorial-350314.iam.gserviceaccount.com",
  "client_id": "115317755060375975764",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheet-tutorial%40flutter-gsheet-tutorial-350314.iam.gserviceaccount.com"
}
  '''
      });
      print("google sheet update");
    }
    print( " Check ====== ${check.sheetid}");
    print("add database googlesheet");
    db.close;
  }
}
