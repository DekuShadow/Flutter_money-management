import 'dart:async';
import 'package:expensetracker/db/transactionDB.dart';
import 'package:expensetracker/models/transactions.dart';
import 'package:expensetracker/page/Form_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../api/google_sheets_api.dart';
import '../providers/transaction_providers.dart';
import '../widget/loading_circle.dart';
import '../widget/top_card.dart';
import '../widget/transaction.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // wait for the data to be fetched from google sheets

  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  bool chack = true;
  int chack2 = 0;
  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  Alert(context, statement, chackMessage) {
    var x;
    var message;
    if (chackMessage) {
      message = "Do you want to delete all data?";
    } else {
      message = "Would you like to send your information to Google Sheet?";
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure"),
            content: Container(child: Text(message)),
            actions: [
              OutlineButton(
                  child: Text("YES"),
                  onPressed: () async {
                    if (chackMessage) {
                      Provider.of<TransactionProviders>(context, listen: false)
                          .delete_data(null);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: LoadingCircle(),
                            );
                          });
                      await GoogleSheetsApi.insert(statement);
                      Navigator.pop(context);
                    }
                    Navigator.pop(context);
                  }),
              OutlineButton(
                  child: Text("NO"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Alert_deletANDpushGoogleSheet(context, statement) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text("LIST")),
            content: Container(
              height: 100,
              child: Column(
                children: [
                  OutlineButton(
                    shape: StadiumBorder(),
                    highlightedBorderColor: Color.fromARGB(255, 255, 9, 247),
                    borderSide: BorderSide(
                        width: 2, color: Color.fromARGB(255, 255, 0, 0)),
                    child: Text("DELETE_ALL"),
                    onPressed: () {
                      Alert(context, statement, true);
                    },
                  ),
                  OutlineButton(
                    shape: StadiumBorder(),
                    highlightedBorderColor: Color.fromARGB(255, 44, 242, 199),
                    borderSide: BorderSide(
                        width: 2, color: Color.fromARGB(255, 128, 249, 241)),
                    child: Text("PUSH_SHEET"),
                    onPressed: () {
                      Alert(context, statement, false);
                      print(statement.length);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  NOT_DATA() {
    if (chack2 == 0) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
        child: Container(
          child: Text(
            "NOT DATA",
          ),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // start loading until the data arrives
    if (GoogleSheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Consumer(
        builder: (BuildContext context, TransactionProviders provider,
            Widget? child) {
          List? BALANCE = provider.put_incomeANDexpense();
          chack2 = provider.transactions.length;
          if (provider.transactions.length == 0) {
            if (chack == true) {
              provider.Search_Data();
              chack = false;
            }
          }
          List<Transactions> statement = provider.transactions;
          return Container(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: SafeArea(
                    child: Column(
                      children: [
                        TopNeuCard(
                          balance: (BALANCE[0] - BALANCE[1]).toString(),
                          income: BALANCE[0].toString(),
                          expense: BALANCE[1].toString(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat("dd/MM/yyyy")
                                  .format(DateTime.now())),
                              Text("List ${statement.length}")
                            ],
                          ),
                        ),
                        NOT_DATA(),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: /* 0 == 1
                                        ? LoadingCircle()
                                        :  */
                                        ListView.builder(
                                            itemCount:
                                                provider.transactions.length,
                                            itemBuilder: (context, index) {
                                              var data = statement[index];
                                              return MyTransaction(
                                                statement: data,
                                                transactionName:
                                                    data.Account.toString(),
                                                money: data.Amount,
                                                expenseOrIncome: data.Expanse,
                                                date: DateFormat("dd/MM/yyyy")
                                                    .format(DateTime.parse(
                                                        data.date)),
                                                note: data.Note,
                                                key1: data.key,
                                              );
                                            }),
                                  )
                                  //   child: GoogleSheetsApi.loading == true
                                  // ? LoadingCircle()
                                  //       : ListView.builder(
                                  //           itemCount:
                                  //               GoogleSheetsApi.currentTransactions.length,
                                  //           itemBuilder: (context, index) {
                                  //             return MyTransaction(
                                  //               transactionName: GoogleSheetsApi
                                  //                   .currentTransactions[index][1],
                                  //               money: GoogleSheetsApi
                                  //                   .currentTransactions[index][3],
                                  //               expenseOrIncome: GoogleSheetsApi
                                  //                   .currentTransactions[index][5],
                                  //               date: GoogleSheetsApi
                                  //                   .currentTransactions[index][0],
                                  //               Function: _newTransaction,
                                  //             );
                                  //           }),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 195, 255, 215),
                                    offset: Offset(0, -2),
                                    blurRadius: 3)
                              ]),
                          // color: Color.fromARGB(255, 255, 255, 255),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                child: Icon(Icons.dynamic_form_sharp),
                                onPressed: () {},
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                style: ButtonStyle(),
                                child: Icon(Icons.list),
                                onPressed: () {
                                  Alert_deletANDpushGoogleSheet(
                                      context, statement);
                                  print(statement.length);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                Transactions statement1 = Transactions();
                                return Form_input(
                                  specify: true,
                                  statement: statement1,
                                );
                              }),
                            );
                            print(statement.length);
                          }),
                    ],
                  ),
                )
              ],
              alignment: AlignmentDirectional.bottomEnd,
            ),
          );
        },
      ),
    );
  }
}
