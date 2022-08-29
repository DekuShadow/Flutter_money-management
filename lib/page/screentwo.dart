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
  int month = DateTime.now().month, years = DateTime.now().year;
  int month_length = 0;
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

            // รวมวันเดือนปี
            for (var index in statement) {
              date1.add(
                  DateFormat("dd/MM/yyyy").format(DateTime.parse(index.date)));
            }
            date1.sort();
            statement2 = date1.reversed.toList();
            // print(" test $statement2");
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

            // Count how many months there are and keep it in Month_length
            List count_month = [];
            var remove_duplicate_month = "";
            for (var index in statement2) {
              if (remove_duplicate_month != index[3] + index[4]) {
                count_month.add(index[3] + index[4]);
              }
              remove_duplicate_month = index[3] + index[4];
              // print("month = $count_month");
            }
            month_length = count_month.length;

            // create page TopCard screentwo
            final page_topcard = List.generate(
              12,
              (index) => Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Screntwo_top_card(
                  statement: statement,
                  month: index + 1,
                ),
              ),
            );
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                    width: 500,
                    height: 120,
                    child: PageView.builder(
                      controller: PageController(
                          initialPage: month - 1,
                          viewportFraction: 0.999,
                          keepPage: true),
                      itemCount: page_topcard.length,
                      onPageChanged: (index) {
                        setState(() {
                          month = index + 1;
                          if(month == 13){
                          }
                        });
                      },
                      itemBuilder: (context, index) {
                        return page_topcard[index/*  % page_topcard.length */];
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Container(child: Text("< $month/2022 >")),
                ),
                Expanded(
                  child: Center(
                    child: ListView.builder(
                        itemCount: statement2.length,
                        itemBuilder: (context, index) {
                          var statement3 = statement2[index];
                          return screntwo_Transaction(
                            date: statement3,
                            statement: statement,
                            month: month,
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
