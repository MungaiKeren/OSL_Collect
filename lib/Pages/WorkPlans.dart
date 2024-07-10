// ignore_for_file: use_build_context_synchronously, file_names, use_super_parameters

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/MyCalendar.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/UserContainer.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wkwp_mobile/Components/IncidentBars/WPIncidentBar.dart';
import 'package:wkwp_mobile/Model/Item.dart';
import 'package:wkwp_mobile/Pages/Login.dart';
import 'package:intl/intl.dart';

class WorkPlan extends StatefulWidget {
  const WorkPlan({Key? key}) : super(key: key);

  @override
  State<WorkPlan> createState() => _WorkPlanState();
}

class _WorkPlanState extends State<WorkPlan> {
  String start = '';
  String end = '12.31.2023';
  String active = "Complete";
  String status = "Pending";
  String userid = '';
  String name = '';
  bool allworkplans = true;
  dynamic isLoading;
  String todaysDate = '';

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
       await getWorkPlans();
    }
  }

  selectWorkPlans(String start) {
    isLoading = LoadingAnimationWidget.horizontalRotatingDots(
      color: Color.fromARGB(248, 186, 12, 47),
      size: 100,
    );

    todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<String> parts = start.split('-'); // Split the string by hyphens
    int year = int.parse(parts[0]); // Extract year
    int month = int.parse(parts[1]); // Extract month
    int day = int.parse(parts[2]); // Extract day

    String selectedDate =
        "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

    print('start: $selectedDate, todaysDate: $todaysDate');

    if (selectedDate == todaysDate) {
      items = filterItemsByDate(postList, selectedDate);
    } else {
      items = filterItemsByDate(postList, selectedDate);
    }
  }

  getWorkPlans() async {
    isLoading = LoadingAnimationWidget.horizontalRotatingDots(
      color: Color.fromARGB(248, 186, 12, 47),
      size: 100,
    );
    try {
      print("userid is: $userid");

      final response = await get(
        Uri.parse("${getUrl()}workplan/userid/$userid"),
      );

      List responseList = json.decode(response.body);
            print("workplan listS: $responseList");


      setState(() {
        postList = responseList.map((data) => Item(data)).toList();
      });

      print("workplan listS: $postList");

      isLoading = null;

      items = filterItemsByCurrentMonth(postList);
    } catch (e) {
      print("product error is: $e");
    }
  }

  List<Item> filterItemsByDate(postList, String selectedDate) {
    isLoading = null;
    setState(() {
      allworkplans = false;
    });

    return postList.where((item) => item.item["Date"] == selectedDate).toList();
  }

  List<Item> filterItemsByCurrentMonth(postList) {
    isLoading = null;

    setState(() {
      allworkplans = true;
    });

    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MM').format(now);

    return postList
        .where((item) => item.item["Date"].split('-')[1] == currentMonth)
        .toList();
  }

  @override
  void initState() {
    getUserInfo();
   

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WKWP WorkPlan',
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
                      "Work Plans",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  MyCalendar(
                    lines: 1,
                    value: start,
                    onSubmit: (value) {
                      setState(() {
                        start = value;
                      });
                      selectWorkPlans(start);
                      print("the date is: $start");
                    },
                    label: 'Filter Work Plans By Date',
                  ),
                  start != ''
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 0.5,
                                  color: const Color.fromRGBO(
                                      217, 217, 217, 1.0), // Line color
                                ),
                              ),
                              allworkplans
                                  ? const Expanded(
                                      child: Text(
                                        "Viewing All Work Plans",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Text(
                                        "Work Plans for: $start",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                              Expanded(
                                child: Container(
                                  height: 0.5,
                                  color: const Color.fromRGBO(
                                      217, 217, 217, 1.0), // Line color
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: items.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              print("workplan item $item");
                              return Padding(
                                padding: const EdgeInsets.all(0),
                                child: WPIncidentBar(item: item, name: name),
                              );
                            },
                          )
                        : isLoading == null
                            ? Center(
                                child: Text(
                                  "There are no workplans for date $start.",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            : const SizedBox(),
                  )
                ],
              ),
            ),
            Center(
              child: isLoading ?? const SizedBox(),
            ), Center(
              child: isLoading ?? const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
