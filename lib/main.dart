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
        home: HomePage(),
      ),
    );
  }
}
