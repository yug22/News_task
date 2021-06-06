import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:task_mumbai/apiProvider/api.dart';
import 'package:task_mumbai/main.dart';
import 'package:task_mumbai/searchPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  var dataArray = [];
  _getTopHeadingData() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Container(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
    apiProvider.topHeading(this).then((response) {
      Navigator.pop(context);
      var statusCode = ApiProvider.returnResponse(response.statusCode);
      var convertDataToJson = json.decode(response.body);
      setState(() {
        dataArray = convertDataToJson['articles'];
      });
      print("response ===================>     $convertDataToJson");
      print("data ===================>     $dataArray");
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _getTopHeadingData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: Icon(Icons.search),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: dataArray.length,
          itemBuilder: (ctx, index) {
            return Card(
              child: ListTile(
                title: Text(
                  dataArray[index]['title'] ?? "",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          },
          physics: const AlwaysScrollableScrollPhysics(),
        ),
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
            () {
              setState(() {
                _getTopHeadingData();
              });

              Fluttertoast.showToast(
                  msg: "Page Refreshed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          );
        },
      ),
    );
  }
}
