import 'package:expensetracker/models/transactions.dart';
import 'package:expensetracker/page/homepage.dart';
import 'package:expensetracker/providers/transaction_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi with ChangeNotifier {
  final sheetid;
  final credentials;
  GoogleSheetsApi({this.sheetid , this.credentials});
  // create credentials
  static const _credentials = r'''
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
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '10rsI5_MFxTew7UAkLj2ARSg1qqXhhQY6986sqMp4SQw';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;

  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;
  static int Write = 0;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionDate =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionCategory =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionNote =
          await _worksheet!.values.value(column: 3, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 4, row: i + 1);
      final String transactionAccount =
          await _worksheet!.values.value(column: 5, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 6, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionDate,
          transactionCategory,
          transactionNote,
          transactionAmount,
          transactionAccount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(List<Transactions> statement) async {
    TransactionProviders provider = TransactionProviders();
    for (var index in statement) {
      Write++;
      if (_worksheet == null) return;
      numberOfTransactions++;
      currentTransactions.add([
        index.date,
        index.Category,
        index.Note,
        index.Amount,
        index.Account,
        index.Expanse == true ? 'income' : 'expense',
      ]);
      await _worksheet!.values.appendRow([
        index.date,
        index.Category,
        index.Note,
        index.Amount,
        index.Account,
        index.Expanse == true ? 'income' : 'expense',
      ]);

      print("Writing $Write");
    }
    Write = 0;
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][5] == 'income') {
        totalIncome += double.parse(currentTransactions[i][3]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][5] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][3]);
      }
    }
    return totalExpense;
  }
}
