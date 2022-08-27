import 'package:expensetracker/db/transactionDB.dart';
import 'package:expensetracker/models/transactions.dart';
import 'package:expensetracker/providers/transaction_providers.dart';
import 'package:expensetracker/widget/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widget/top_card.dart';

class screntwo extends StatefulWidget {
  const screntwo({Key? key}) : super(key: key);

  @override
  State<screntwo> createState() => _screntwoState();
}

class _screntwoState extends State<screntwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Consumer(
          builder: (BuildContext context, TransactionProviders provider,
              Widget? child) {
            List<Transactions> statement = provider.transactions;
            List<String> statement2 = [];
            List<String> date1 = [];
            for (var index in statement) {
              date1.add(
                  DateFormat("dd/MM/yyyy").format(DateTime.parse(index.date)));
            }
            date1.sort();
            statement2 = date1.reversed.toList();
            print(statement2);
            var remove_duplicate_day;
            for (var i = 0; i < statement2.length; i++) {
              if (remove_duplicate_day == statement2[i]) {
                print("remove index $i " + statement2[i]);
                statement2.removeAt(i);
                i--;
              } else {
                remove_duplicate_day = statement2[i];
                print("not repeat index $i => " + remove_duplicate_day);
              }
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Screntwo_top_card(statement: statement,),
                Expanded(
                  child: Center(
                    child: ListView.builder(
                        itemCount: statement2.length,
                        itemBuilder: (context, index) {
                          var statement3 = statement2[index];
                          return screntwo_Transaction(
                            date: statement3,
                            statement: statement,
                          );
                        }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
