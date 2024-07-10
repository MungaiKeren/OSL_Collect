// ignore_for_file: use_build_context_synchronously, file_names, use_super_parameters

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/IncidentBars/TAFIncidentBar.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/UserContainer.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Model/Item.dart';
import 'package:wkwp_mobile/Pages/Login.dart';

class TAFList extends StatefulWidget {
  const TAFList({Key? key}) : super(key: key);

  @override
  State<TAFList> createState() => _TAFListState();
}

class _TAFListState extends State<TAFList> {
  String start = '';
  String end = '12.31.2023';
  String active = "Complete";
  String status = "Pending";
  String userid = '';
  String name = '';

  var isLoading;
  late Image myimage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();
  List<Item> items = []; // List to store filtered items
  List<Item> postList = [];

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> getUserInfo() async {
    var token = await storage.read(key: "WKWPjwt");
    var decoded = parseJwt(token.toString());
    if (decoded["error"] == "Invalid token") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );
    } else {
      setState(() {
        name = decoded["Name"];
        userid = decoded["UserID"];
      });
    }
  }

  getTAFLists() async {
    isLoading = LoadingAnimationWidget.horizontalRotatingDots(
      color: Color.fromARGB(248, 186, 12, 47),
      size: 100,
    );
    try {
      final response = await get(
        Uri.parse("${getUrl()}taf"),
      );

      List responseList = json.decode(response.body);
      print("TAFLIST $responseList");

      setState(() {
        postList = responseList.map((data) => Item(data)).toList();
      });

      isLoading = null;

      items =
          postList.where((item) => item.item["WKWPRepName"] == name).toList();
    } catch (e) {
      print("product error is: $e");
    }
  }

  @override
  void initState() {
    getUserInfo();
    getTAFLists();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WKWP TAFList',
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
              padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
              child: Column(
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
                  const SizedBox(
                    height: 16,
                  ),
                  const Center(
                    child: Text(
                      "List of Technical Asistance (TAF)",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Expanded(
                    child: items.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Padding(
                                padding: const EdgeInsets.all(0),
                                child: TAFIncidentBar(item: item, name: name),
                              );
                            },
                          )
                        : isLoading == null
                            ? const Center(
                                child: Text(
                                  "No Assistance provided yet",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : const SizedBox(),
                  )
                ],
              ),
            ),
            Center(
              child: isLoading ?? const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
