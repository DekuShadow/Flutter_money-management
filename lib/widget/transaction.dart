import 'package:expensetracker/models/transactions.dart';
import 'package:expensetracker/page/form_input.dart';
import 'package:expensetracker/providers/transaction_providers.dart';
import 'package:expensetracker/widget/plus_button.dart';
import 'package:flutter/material.dart';
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
                          specify: false,statement: widget.statement,
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
