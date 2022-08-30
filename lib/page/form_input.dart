import 'package:expensetracker/api/google_sheets_api.dart';
import 'package:expensetracker/models/transactions.dart';
import 'package:expensetracker/providers/transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Form_input extends StatefulWidget {
  final bool specify;
  final Transactions statement;
  const Form_input({Key? key, required this.specify, required this.statement})
      : super(key: key);

  @override
  State<Form_input> createState() => _Form_inputState();
}

class _Form_inputState extends State<Form_input> {
  DateTime date = DateTime.now();
  DateTime? _textcontrollerDate;
  var _textcontrollerAccount = TextEditingController();
  var _textcontrollerCategory = TextEditingController();
  var _textcontrollerNote = TextEditingController();
  var _textcontrollerAMOUNT = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  push_date(date_in) {
    setState(() {
      date = date_in;
      _textcontrollerDate = /* "${date.day}/${date.month}/${date.year + 543}" */ date;
      print(_textcontrollerDate);
    });
  }

  push_data() {
    Transactions statement = Transactions(
        date: _textcontrollerDate,
        Account: _textcontrollerAccount.text,
        Category: _textcontrollerCategory.text,
        Note: _textcontrollerNote.text,
        Amount: _textcontrollerAMOUNT.text,
        Expanse: _isIncome);
    Provider.of<TransactionProviders>(context, listen: false)
        .Add_data(statement);
  }

  update_data() {
    Transactions statement = Transactions(
        date: _textcontrollerDate,
        Account: _textcontrollerAccount.text,
        Category: _textcontrollerCategory.text,
        Note: _textcontrollerNote.text,
        Amount: _textcontrollerAMOUNT.text,
        Expanse: _isIncome,
        key: int.parse(widget.statement.key));

    Provider.of<TransactionProviders>(context, listen: false)
        .update_data(statement);
  }

  List<Widget> Edit_AND_Delete(specify) {
    List<Widget> edit_and_delet = [];
    if (specify) {
      edit_and_delet.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlineButton(
                shape: StadiumBorder(),
                highlightedBorderColor: Colors.blue,
                borderSide: BorderSide(
                    width: 2, color: Color.fromARGB(255, 96, 238, 134)),
                child: Icon(Icons.add_circle_sharp),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    push_date(date);
                    push_data();
                    Navigator.pop(context);
                  }
                })
          ],
        ),
      );
    } else {
      edit_and_delet.add(Row(
        children: [
          OutlineButton(
              shape: StadiumBorder(),
              highlightedBorderColor: Colors.blue,
              borderSide: BorderSide(
                  width: 2, color: Color.fromARGB(255, 96, 238, 134)),
              child: Icon(Icons.save),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  push_date(date);
                  update_data();
                  Navigator.pop(context);
                }
              }),
          SizedBox(
            width: 20,
          ),
          OutlineButton(
              shape: StadiumBorder(),
              highlightedBorderColor: Colors.blue,
              borderSide: BorderSide(
                  width: 2, color: Color.fromARGB(255, 96, 238, 134)),
              child: Icon(Icons.delete),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  push_date(date);
                  Navigator.pop(context);
                  Provider.of<TransactionProviders>(context, listen: false)
                      .delete_data(int.parse(widget.statement.key));
                }
              })
        ],
      ));
    }
    return edit_and_delet;
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.statement.Account != null) {
      _textcontrollerAccount =
          TextEditingController(text: widget.statement.Account);
      _textcontrollerCategory =
          TextEditingController(text: widget.statement.Category);
      _textcontrollerNote = TextEditingController(text: widget.statement.Note);
      _textcontrollerAMOUNT =
          TextEditingController(text: widget.statement.Amount);
      _isIncome = widget.statement.Expanse;
      date = DateTime.parse(widget.statement.date);
      // print("initState START");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Expense'),
                  Switch(
                    value: _isIncome,
                    onChanged: (newValue) {
                      setState(() {
                        _isIncome = newValue;
                      });
                    },
                  ),
                  Text('Income'),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 137, 137, 137)),
                        onPressed: () async {
                          DateTime? newdate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          if (newdate == null) return;
                          setState((() {
                            date = newdate;
                          }));
                        },
                        child: Text(
                            "${date.day}/${date.month}/${date.year + 543}")),
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 5, 40, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 12,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Account',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "please enter account";
                        }
                        return null;
                      },
                      controller: _textcontrollerAccount,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 12,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Category',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "please enter Category";
                        }
                        return null;
                      },
                      controller: _textcontrollerCategory,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 30,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Note',
                      ),
                      validator: (text) {},
                      controller: _textcontrollerNote,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Amount',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "please enter Amount";
                        }
                        return null;
                      },
                      controller: _textcontrollerAMOUNT,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: Edit_AND_Delete(widget.specify),
                ))
          ],
        ),
      ),
    );
  }
}
