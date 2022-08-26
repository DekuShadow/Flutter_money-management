import 'package:flutter/material.dart';

class LoadingCircle extends StatefulWidget {
  const LoadingCircle({Key? key}) : super(key: key);

  @override
  State<LoadingCircle> createState() => _LoadingCircleState();
}

class _LoadingCircleState extends State<LoadingCircle> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 180,
        width: 200,
        child: Column(
          children: [
            Text("Sending Data",style: TextStyle(fontSize: 30),),
            SizedBox(
              height: 20,
            ),
            Text("Writing data in google sheets"),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
