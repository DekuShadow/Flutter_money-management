import 'dart:ui';

import 'package:expensetracker/db/transactionDB.dart';
import 'package:expensetracker/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class TopNeuCard extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;

  TopNeuCard({
    required this.balance,
    required this.expense,
    required this.income,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 180,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[200],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_upward,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Income',
                                            style: TextStyle(
                                                color: Colors.grey[500])),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('\$' + income,
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[200],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_downward,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Expense',
                                            style: TextStyle(
                                                color: Colors.grey[500])),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('\$' + expense,
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      /* gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment(0.8, 1),
                        colors: <Color>[
                          Color.fromARGB(255, 235, 255, 242),
                          Color.fromARGB(255, 215, 255, 228),
                          Color.fromARGB(255, 190, 255, 210),
                          Color.fromARGB(255, 170, 255, 196),
                          Color.fromARGB(255, 150, 255, 182),
                          Color.fromARGB(255, 120, 255, 161),
                          Color.fromARGB(255, 90, 255, 140),
                          Color.fromARGB(255, 55, 255, 115),
                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                        tileMode: TileMode.mirror,
                      ), */
                      color: Color(0xffC2F8C9),
                      /* boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 137, 255, 237),
                              offset: Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0),
                          BoxShadow(
                              color: Color.fromARGB(255, 104, 164, 249),
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0),
                        ] */
                    ),
                  ),
                  Positioned(
                      child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text('B A L A N C E',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 87, 87, 87),
                                  fontSize: 35)),
                        ),
                        SizedBox(height: 15,)
                      ],
                    ),
                    height: 90,
                    decoration: BoxDecoration(
                        // boxShadow: [BoxShadow(color: Colors.black,offset: Offset(0,2))],
                        borderRadius: BorderRadius.circular(27),
                        color: Colors.white),
                  ))
                ],
              ),
            ],
          ),
          Positioned(
            child: Container(
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: Color.fromARGB(125, 0, 0, 0)),
                    height: 45,
                    width: 300,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: Color.fromARGB(255, 255, 255, 255)),
                        height: 49,
                        width: 299.9,
                        child: Center(
                          child: Text(
                            '\$' + balance,
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 28),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Screntwo_top_card extends StatelessWidget {
  List<Transactions> statement;
  int month;
  Screntwo_top_card({required this.statement, required this.month});

  @override
  Widget build(BuildContext context) {
    top_card() {
      int income = 0;
      int expense = 0;

      for (var index in statement) {
        String dateCheck =
            DateFormat("dd/MM/yyyy").format(DateTime.parse(index.date));
        if (int.parse(dateCheck[3] + dateCheck[4]) == month) {
          if (index.Expanse) {
            income += int.parse(index.Amount);
          } else {
            expense += int.parse(index.Amount);
          }
        }
      }

      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 138, 221, 221),
                offset: Offset(0, 3),
                blurRadius: 5.0,
                spreadRadius: 1.0),
          ],
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        width: 400,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Income",
                        style: TextStyle(fontSize: 18, color: Colors.green)),
                    Text("$income",
                        style: TextStyle(fontSize: 15, color: Colors.green))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Expense",
                        style: TextStyle(fontSize: 18, color: Colors.red)),
                    Text("$expense",
                        style: TextStyle(fontSize: 15, color: Colors.red))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("total",
                        style: TextStyle(fontSize: 18, color: Colors.blue)),
                    Text("${income - expense}",
                        style: TextStyle(fontSize: 15, color: Colors.blue))
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 10), child: top_card());
  }
}
