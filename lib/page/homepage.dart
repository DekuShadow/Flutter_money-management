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

          final page = List.generate(
              5,
              (index) => TopNeuCard(
                    balance: (BALANCE[0] - BALANCE[1]).toString(),
                    income: BALANCE[0].toString(),
                    expense: BALANCE[1].toString(),
                  ));

          chack2 = provider.transactions.length;
          if (provider.transactions.length == 0) {
            if (chack == true) {
              provider.Search_Data();
              chack = false;
            }
          }
          List<Transactions> statement = provider.transactions;
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 4, 15, 10),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 210,
                    child: PageView.builder(
                        controller: controller,
                        itemCount: statement.length,
                        itemBuilder: (context, index) {
                          print(index);
                          return TopNeuCard(
                            balance: (BALANCE[0] - BALANCE[1]).toString(),
                            income: BALANCE[0].toString(),
                            expense: BALANCE[1].toString(),
                          );
                        }),
                  ),
                  // TopNeuCard(
                  //   balance: (BALANCE[0] - BALANCE[1]).toString(),
                  //   income: BALANCE[0].toString(),
                  //   expense: BALANCE[1].toString(),
                  // ),
                  NOT_DATA(),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: /* 0 == 1
                                  ? LoadingCircle()
                                  :  */
                                  ListView.builder(
                                      itemCount: provider.transactions.length,
                                      itemBuilder: (context, index) {
                                        var x = statement[index];
                                        return MyTransaction(
                                          statement: x,
                                          transactionName: x.Account.toString(),
                                          money: x.Amount,
                                          expenseOrIncome: x.Expanse,
                                          date: DateFormat("dd/MM/yyyy").format(DateTime.parse(x.date)),
                                          key1: x.key,
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
                  // OutlineButton(
                  //   shape: StadiumBorder(),
                  //   highlightedBorderColor: Color.fromARGB(255, 0, 255, 55),
                  //   borderSide: BorderSide(
                  //       width: 2, color: Color.fromARGB(255, 128, 249, 241)),
                  //   child: Text("add"),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) {
                  //         Transactions statement1 = Transactions();
                  //         return Form_input(
                  //           specify: true,
                  //           statement: statement1,
                  //         );
                  //       }),
                  //     );
                  //     print(statrment.length);
                  //   },
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            // BoxShadow(
                            //     color: Color.fromARGB(255, 238, 0, 255),
                            //     offset: Offset(4.0, 4.0),
                            //     blurRadius: 15.0,
                            //     spreadRadius: 1.0),
                            BoxShadow(
                                color: Color.fromARGB(255, 128, 128, 128),
                                offset: Offset(0, 0),
                                blurRadius: 1.0,
                                spreadRadius: 1.0),
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlineButton(
                            shape: StadiumBorder(),
                            highlightedBorderColor:
                                Color.fromARGB(255, 0, 255, 38),
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 60, 161, 255)),
                            child: Text("ADD"),
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
                            },
                          ),
                          OutlineButton(
                            shape: StadiumBorder(),
                            highlightedBorderColor:
                                Color.fromARGB(255, 0, 255, 38),
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 60, 161, 255)),
                            child: Icon(Icons.list),
                            onPressed: () {
                              Alert_deletANDpushGoogleSheet(context, statement);
                              print(statement.length);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
