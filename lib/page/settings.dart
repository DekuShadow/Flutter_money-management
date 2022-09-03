import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    alert() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Container(
                child: Text("test showdialog"),
              ),
              content: Container(child: Text("you are sure")),
              actions: [Text("data"), Text("data")],
            );
          });
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("S E T T I N G S"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("test");
                alert();
              
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.red),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  children: [
                    Text("Google sheet"),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
