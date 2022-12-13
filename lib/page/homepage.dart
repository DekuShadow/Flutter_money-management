import 'dart:async';
import 'package:expensetracker/db/transactionDB.dart';
import 'package:expensetracker/models/transactions.dart';
import 'package:expensetracker/page/Form_input.dart';
import 'package:expensetracker/page/settings.dart';
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

  @override
  Widget build(BuildContext context) {
    Alert(statement, chackMessage) {
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
                OutlinedButton(
                    child: Text("YES"),
                    onPressed: () async {
                      if (chackMessage) {
                        Provider.of<TransactionProviders>(context,
                                listen: false)
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
                OutlinedButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }

    Alert_deletANDpushGoogleSheet(statement) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(child: Text("LIST")),
              content: Container(
                height: 100,
                child: Column(
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            StadiumBorder()),
                        side: MaterialStateProperty.resolveWith<BorderSide>(
                            (Set<MaterialState> states) {
                          final Color color =
                              states.contains(MaterialState.pressed)
                                  ? Color.fromARGB(255, 71, 255, 24)
                                  : Color.fromARGB(255, 222, 112, 255);
                          return BorderSide(color: color, width: 2);
                        }),
                      ),
                      child: Text("DELETE_ALL"),
                      onPressed: () {
                        Alert(statement, true);
                      },
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            StadiumBorder()),
                        side: MaterialStateProperty.resolveWith<BorderSide>(
                            (Set<MaterialState> states) {
                          final Color color =
                              states.contains(MaterialState.pressed)
                                  ? Color.fromARGB(255, 71, 255, 24)
                                  : Color.fromARGB(255, 222, 112, 255);
                          return BorderSide(color: color, width: 2);
                        }),
                      ),
                      child: Text("PUSH_SHEET"),
                      onPressed: () {
                        Alert(statement, false);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    List<Widget> testwidget = [
      Container(
        height: 15,
        width: 10,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
    ];
    for (var i = 0; i < 9; i++) {
      testwidget.add(Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Container(
          height: 15,
          width: 10,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ));
    }
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
              provider.Search_Data("Money_management");
              chack = false;
            }
          }
          List<Transactions> statement = provider.transactions;
          return SafeArea(
            child: Container(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFDBCCFF),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment(0, -1),
                              colors: <Color>[
                                Color.fromARGB(255, 218, 202, 255),
                                Color.fromARGB(255, 204, 182, 255),
                                Color.fromARGB(255, 184, 151, 255),
                                Color.fromARGB(255, 162, 122, 255),
                                Color.fromARGB(255, 150, 106, 255),
                                Color.fromARGB(255, 143, 95, 255),
                                Color.fromARGB(255, 122, 65, 255),
                                Color.fromARGB(255, 104, 40, 255),
                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                              tileMode: TileMode.mirror,
                            ),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            children: [
                              TopNeuCard(
                                balance: (BALANCE[0] - BALANCE[1]).toString(),
                                income: BALANCE[0].toString(),
                                expense: BALANCE[1].toString(),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateFormat("dd/MM/yyyy")
                                        .format(DateTime.now())),
                                    Text("List ${statement.length}")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xffD4F3FF),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: chack2 == 0
                                      ? Center(
                                          child: Container(
                                            child: Text(
                                              "NOT DATA",
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
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
                  Positioned(
                    top: 219,
                    child: Container(
                      // color: Colors.red,
                      child: Row(
                        children: testwidget,
                      ),
                    ),
                  ),
                  Stack(
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
                                    color: Color(0xFFDBCCFF),
                                    offset: Offset(0, -2),
                                    blurRadius: 3)
                              ]),
                          // color: Color.fromARGB(255, 255, 255, 255),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                child: Icon(Icons.settings),
                                onPressed: () {
                                  // Provider.of<TransactionProviders>(context,
                                  //         listen: false)
                                  //     .provider_setgoogleSheet();
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return Settings();
                                  // }));
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                style: ButtonStyle(),
                                child: Icon(Icons.list),
                                onPressed: () {
                                  Alert_deletANDpushGoogleSheet(statement);
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
                ],
                alignment: AlignmentDirectional.bottomCenter,
              ),
            ),
          );
        },
      ),
    );
  }
}
