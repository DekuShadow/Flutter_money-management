import 'package:expensetracker/db/transactionDB.dart';
import 'package:expensetracker/models/transactions.dart';
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(5),
      child: Container(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('B A L A N C E',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16)),
              Text(
                '\$' + balance,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Income',
                                style: TextStyle(color: Colors.grey[500])),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Expense',
                                style: TextStyle(color: Colors.grey[500])),
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
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 255, 255, 255),
          // boxShadow: [
          //   BoxShadow(
          //       color: Color.fromARGB(255, 137, 255, 237),
          //       offset: Offset(4.0, 4.0),
          //       blurRadius: 15.0,
          //       spreadRadius: 1.0),
          //   BoxShadow(
          //       color: Color.fromARGB(255, 104, 164, 249),
          //       offset: Offset(-4.0, -4.0),
          //       blurRadius: 15.0,
          //       spreadRadius: 1.0),
          // ]
        ),
      ),
    );
  }
}

class Screntwo_top_card extends StatelessWidget {
  List<Transactions> statement;
  Screntwo_top_card({required this.statement});

  @override
  Widget build(BuildContext context) {
    top_card() {
      int income = 0;
      int expense = 0;

      for (var index in statement) {
        if (index.Expanse) {
          income += int.parse(index.Amount);

        } else {
          expense += int.parse(index.Amount);

        }
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        width: 400,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Income",
                    style: TextStyle(fontSize: 18, color: Colors.green)),
                Text("$income", style: TextStyle(fontSize: 15,color: Colors.green))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Expense", style: TextStyle(fontSize: 18,color: Colors.red)),
                Text("$expense", style: TextStyle(fontSize: 15,color: Colors.red))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("total", style: TextStyle(fontSize: 18,color: Colors.blue)),
                Text("${income - expense}", style: TextStyle(fontSize: 15,color: Colors.blue))
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 2), child: top_card());
  }
}
