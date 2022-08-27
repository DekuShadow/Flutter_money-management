import 'package:expensetracker/page/screntwo.dart';
import 'package:expensetracker/providers/transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api/google_sheets_api.dart';
import 'page/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsApi().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return TransactionProviders();
          },
        ),
        ChangeNotifierProvider(create: (context) {
          return GoogleSheetsApi();
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Myhomepage(),
      ),
    );
  }
}

class Myhomepage extends StatefulWidget {
  const Myhomepage({Key? key}) : super(key: key);

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(children: [HomePage(), screntwo()])
          ,
          bottomNavigationBar: TabBar(indicatorColor: Colors.red, indicatorWeight: 1, tabs: [
            Tab(child: Text("home",style: TextStyle(color: Color.fromARGB(31, 24, 24, 24)),),),Tab(child: Text("Scran"),)
          ]),
        ));
  }
}
