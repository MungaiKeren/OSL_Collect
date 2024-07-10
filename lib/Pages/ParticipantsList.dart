// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_field, prefer_final_fields, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/QRCodeDialog1.dart';
import 'package:wkwp_mobile/Components/SmallButton.dart';
import 'package:wkwp_mobile/Components/UserContainer.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Pages/ARFAddParticipant.dart';
import 'package:http/http.dart' as http;

class ParticipantsList extends StatefulWidget {
  final String activityID;

  const ParticipantsList({super.key, required this.activityID});

  @override
  State<ParticipantsList> createState() => _ParticipantsListState();
}

class _ParticipantsListState extends State<ParticipantsList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();

  var long = 36.0, lat = -2.0;
  String error = '';

  var isLoading;
  int _currentPageIndex = 0;
  final _currentPageNotifier = ValueNotifier<int>(0);
  final PageController _pageController = PageController();
  List<Person> people = [];

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  fetchData() async {
    String id = widget.activityID;
    try {
      final response =
          await get(Uri.parse("${getUrl()}participants/details/$id"));

      if (response.statusCode == 200) {
        List<dynamic> responseList = json.decode(response.body);
       
        List<Person> fetchedPeople = responseList.map((data) {
              return Person(
            name: data["ParticipantName"],
            project: data["Organization"],
          );
        }).toList();

        setState(() {
          people = List.from(fetchedPeople);
        });

           } else {
         }
    } catch (e) {
      }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromRGBO(3, 48, 110, 1),
            Color.fromRGBO(0, 96, 177, 1)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  height: 12,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Bungoma County Rural Water \nSensitization",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Event Participants",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 250, 246, 246),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 400,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int index) {
                          _currentPageNotifier.value = index;
                        },
                        itemCount:
                            (people.length / 6).ceil(), // 6 people per page
                        itemBuilder: (context, pageIndex) {
                          final start = pageIndex * 6;
                          final end = (start + 6) < people.length
                              ? (start + 6)
                              : people.length;
                          final pagePeople = people.sublist(start, end);
                          return ListView.builder(
                            itemCount: pagePeople.length,
                            itemBuilder: (context, index) {
                              final person = pagePeople[index];
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                    ), // Adjust border radius
                                  ),
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            person.name,
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 95, 175, 1.0)),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            person.project,
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 95, 175, 1.0)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: CirclePageIndicator(
                        itemCount: (people.length / 6).ceil(),
                        currentPageNotifier: _currentPageNotifier,
                        size: 10,
                        dotColor: Colors.grey,
                        selectedDotColor: Colors.red,
                        selectedSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SmallButton(
                        label: "Close Event",
                        onButtonPressed: () async {
                          // PROCEED TO NEXT PAGE
                          showDialog(
                              context: context,
                              builder: (context) {
                                return QRCodeDialog1(
                                    activityID: widget.activityID);
                              });
                        },
                        color: const Color.fromRGBO(186, 12, 47, 1.0),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SmallButton(
                        label: "Add Participants",
                        onButtonPressed: () async {
                          // PROCEED TO NEXT PAGE
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ARFAddParticipant(
                                        activityID: widget.activityID,
                                      )));
                        },
                        color: const Color.fromRGBO(0, 100, 182, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Person {
  final String name;
  final String project;

  Person({required this.name, required this.project});
}

Future<Message> submitData() async {
  try {
    final response = await http.post(
      Uri.parse("${getUrl()}ParticipantsList/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );

    if (response.statusCode == 200 || response.statusCode == 203) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      return Message(
        token: null,
        success: null,
        error: "Connection to server failed!!",
      );
    }
  } catch (e) {
    return Message(
      token: null,
      success: null,
      error: "Connection to server failed!",
    );
  }
}

class Message {
  var token;
  var success;
  var error;

  Message({
    required this.token,
    required this.success,
    required this.error,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      token: json['token'],
      success: json['success'],
      error: json['error'],
    );
  }
}
