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
  final key1;
  final Function;

  MyTransaction(
      {required this.statement,
      required this.transactionName,
      required this.money,
      required this.expenseOrIncome,
      required this.date,
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
          child: Container(
            padding: EdgeInsets.all(15),
            color: Colors.grey[100],
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[500]),
                        child: Center(
                          child: Icon(
                            Icons.attach_money_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 35,
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
                    ],
                  ),
                  Text(
                    (widget.expenseOrIncome == false ? '-' : '+') +
                        '\$' +
                        widget.money,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: widget.expenseOrIncome == false
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  GestureDetector(
                    // When the child is tapped, show a snackbar.
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Form_input(
                          specify: false,
                          statement: widget.statement,
                        );
                      }));
                    },
                    // The custom button
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 127, 174, 197),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text("Edit"),
                    ),
                  )
                ]),
          ),
        ),
      );
    });
  }
}

class screntwo_Transaction extends StatelessWidget {
  final date;
  List<Transactions> statement;
  screntwo_Transaction({Key? key, this.date, required this.statement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 15,
                    width: 75,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(index.Account)])),
                SizedBox(
                    height: 15,
                    width: 75,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(index.Category)])),
                SizedBox(
                    height: 15,
                    width: 155,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            index.Amount,
                            style: TextStyle(color: color),
                          )
                        ]))
              ],
            ),
          );
        }
      }
      return transaction;
    }

    topcard() {
      int increase_sum = 0;
      int subtract_sum = 0;
      for (var index in statement) {
        if (index.Expanse) {
          increase_sum += int.parse(index.Amount);
        } else {
          subtract_sum += int.parse(index.Amount);
        }
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$date",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
              height: 17,
              width: 157,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$increase_sum", style: TextStyle(fontSize: 18,color: Colors.greenAccent)),
                    Text("$subtract_sum",
                        style: TextStyle(fontSize: 18, color: Colors.red))
                  ]))
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            topcard(),
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
}
