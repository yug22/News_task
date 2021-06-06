import 'package:flutter/material.dart';
import 'package:task_mumbai/apiProvider/api.dart';
import 'package:task_mumbai/homePage.dart';

ApiProvider apiProvider = ApiProvider();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'News App'),
    );
  }
}
