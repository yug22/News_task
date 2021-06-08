import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_mumbai/apiProvider/api.dart';
import 'package:task_mumbai/main.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List names = [];
  List filteredNames = [];

  _getSearchData() {
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
    apiProvider.everything(todayDate, this).then((response) {
      Navigator.pop(context);
      var statusCode = ApiProvider.returnResponse(response.statusCode);
      var convertDataToJson = json.decode(response.body);
      var data = convertDataToJson['articles'];

      List tempList = [];
      for (int i = 0; i < data.length; i++) {
        tempList.add(data[i]);
      }
      setState(() {
        names = tempList;
        names.shuffle();
        filteredNames = names;
      });
      var status_code = convertDataToJson["status_code"];
      print("response ===================>     $convertDataToJson");
      print("statusCode ===================>     $status_code");
      print("data ===================>     $data");
    });
  }

  _SearchPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _getSearchData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text("Search Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: _filter,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Search Here",
                suffixIcon: Icon(
                  Icons.search,
                  size: 15,
                  color: Colors.grey,
                ),
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['title']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i] ?? "");
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: names == null ? 0 : filteredNames.length,
      // itemCount: 7,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(
              filteredNames[index]['title'] ?? "",
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
