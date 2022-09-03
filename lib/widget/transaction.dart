import 'package:expensetracker/models/transactions.dart';
import 'package:expensetracker/page/form_input.dart';
import 'package:expensetracker/providers/transaction_providers.dart';
import 'package:expensetracker/widget/plus_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyTransaction extends StatefulWidget {
  Transactions statement;
  final String transactionName;
  final String money;
  final bool expenseOrIncome;
  final String date;
  final String note;
  final key1;
  final Function;

  MyTransaction(
      {required this.statement,
      required this.transactionName,
      required this.money,
      required this.expenseOrIncome,
      required this.date,
      required this.note,
      this.key1,
      this.Function});

  @override
  State<MyTransaction> createState() => _MyTransactionState();
}

class _MyTransactionState extends State<MyTransaction> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, TransactionProviders provider, child) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Form_input(
                  specify: false,
                  statement: widget.statement,
                );
              }));
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              color: Color.fromARGB(255, 255, 255, 255),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          child: Column(
                            children: [
                              Text(
                                "${widget.date}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromARGB(255, 255, 24, 120)),
                              ),
                              Text(widget.transactionName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          // height: 35,
                          width: 100,
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.statement.Category),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                widget.note,
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 105,
                      // color: Color.fromARGB(14, 255, 151, 143),
                      child: Column(
                        children: [
                          Text(
                            /* (widget.expenseOrIncome == false ? '-' : '+') + */
                            '฿' + widget.money,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: widget.expenseOrIncome == false
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      );
    });
  }
}

class screntwo_Transaction extends StatelessWidget {
  final date;
  int month;
  List<Transactions> statement;
  screntwo_Transaction(
      {Key? key, this.date, required this.statement, required this.month})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    double fontSizes = 15;
    List<Widget> addtransaction() {
      List<Widget> transaction = [];

      for (var index in statement) {
        if (index.Expanse) {
          color = Colors.greenAccent;
        } else {
          color = Colors.red;
        }
        String x = DateFormat("dd/MM/yyyy").format(DateTime.parse(index.date));
        if (date == x) {
          transaction.add(
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Form_input(
                    specify: false,
                    statement: index,
                  );
                }));
              },
              child: Container(
                height: 40,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        // height: 15,
                        width: 95,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(index.Account)])),
                    Container(
                        // height: 15,
                        width: 100,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(index.Category)])),
                    Container(
                        // height: 15,
                        width: 110,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                (index.Expanse == false ? '-' : '+') +
                                    index.Amount,
                                style: TextStyle(color: color),
                              )
                            ]))
                  ],
                ),
              ),
            ),
          );
        }
      }
      return transaction;
    }

    topcard_transection() {
      int increase_sum = 0;
      int subtract_sum = 0;
      for (var index in statement) {
        String datecheck =
            DateFormat("dd/MM/yyyy").format(DateTime.parse(index.date));
        if (date == datecheck) {
          if (index.Expanse) {
            increase_sum += int.parse(index.Amount);
          } else {
            subtract_sum += int.parse(index.Amount);
          }
        }
      }
      int x = int.parse(date[3] + date[4]);
      if (x != month) {
        // print("Unwanted Month => "+ date[3] + date[4]);
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 138, 221, 221), offset: Offset(0, 4))
          ], borderRadius: BorderRadius.circular(10), color: Colors.white),
          // width: 400,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 163, 163, 163),
                        offset: Offset(0, 1))
                  ],
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$date",
                        style: TextStyle(fontSize: fontSizes),
                      ),
                      Text("\$" + "${increase_sum}",
                          style: TextStyle(
                              fontSize: fontSizes, color: Colors.greenAccent)),
                      Text("\$" + "$subtract_sum",
                          style: TextStyle(
                              fontSize: fontSizes, color: Colors.red)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                children: addtransaction(),
              )
            ]),
          ),
        ),
      );
    }

    return topcard_transection();
  }
}
