// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/FormsBar.dart';
import 'package:wkwp_mobile/Components/FormsScrollController.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/UserContainer.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Model/Item.dart';

class CustomForms extends StatefulWidget {
  const CustomForms({super.key});

  @override
  State<CustomForms> createState() => _CustomFormsState();
}

class _CustomFormsState extends State<CustomForms> {
  String start = '';
  String end = '';
  String active = "Complete";
  String status = "Pending";
  String userid = '';
  String name = '';
  String county = '';
  List<Item> formsData = [];
  late FormsScrollController formsScrollController;
  var isLoading = null;

  late Image myimage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> getUserInfo() async {
    var token = await storage.read(key: "WKWPjwt");
    var decoded = parseJwt(token.toString());

    print("user info: $decoded");

    setState(() {
      name = decoded["Name"];
      userid = decoded["UserID"];
      county = decoded["County"];
    });
  }

  Future<void> fetchFormData() async {
    try {
      setState(() {
        isLoading = LoadingAnimationWidget.horizontalRotatingDots(
          color: const Color.fromARGB(248, 186, 12, 47),
          size: 100,
        );
      });

      print("county: $county");

      final response = await get(
        Uri.parse("${getUrl()}toolslist"),
      );

      List responseList = json.decode(response.body);
      print("list is : $responseList, $county");
      print("county is : $county");

      // Filter objects based on the county variable
      List filteredDataList = responseList
          .where((data) => data["County"] == county || data["County"] == "All")
          .toList();

      setState(() {
        formsData = filteredDataList.map((data) => Item(data)).toList();
        isLoading = null;
      });

      print("new list is $formsData");
    } catch (e) {
      setState(() {
        isLoading = null;
      });
    }
  }

  @override
  void initState() {
    getUserInfo();
    formsScrollController = FormsScrollController(
      id: userid,
      status: status,
      active: active,
    );

    fetchFormData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WKWP CustomForms',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        key: _scaffoldKey,
        drawer: const MyDrawer(),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(3, 48, 110, 1),
                    Color.fromRGBO(0, 96, 177, 1)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _openDrawer,
                        child: Image.asset(
                          'assets/images/menuicon.png',
                          width: 24,
                        ),
                      ),
                      UserContainer(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "My Forms",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                      child: formsData.isNotEmpty
                          ? ListView.builder(
                              itemCount: formsData.length,
                              itemBuilder: (context, index) {
                                return FormsBar(
                                  item: formsData[index],
                                  name: name,
                                );
                              },
                            )
                          : isLoading == null
                              ? const Center(
                                  child: Text(
                                    "No Current Form...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : const SizedBox()),
                ],
              ),
            ),
            isLoading != null ? Center(child: isLoading) : SizedBox()
          ],
        ),
      ),
    );
  }
}
