// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/CFormCheckBox.dart';
import 'package:wkwp_mobile/Components/CFormDate.dart';
import 'package:wkwp_mobile/Components/CFormInput.dart';
import 'package:wkwp_mobile/Components/CFormSelect.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/MyMap.dart';
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/UserContainer.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Model/Item2.dart';
import 'package:wkwp_mobile/Pages/CustomForms.dart';
import 'package:http/http.dart' as http;

class FormsTemplate extends StatefulWidget {
  final dynamic tbname;
  final dynamic toolname;

  const FormsTemplate({super.key, this.tbname, this.toolname});

  @override
  State<FormsTemplate> createState() => _FormsTemplateState();
}

class _FormsTemplateState extends State<FormsTemplate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();
  late Position position;

  String error = '';
  List<Item2> postList = [];
  List<Map<String, dynamic>> questionsCheck = [];

  String question1 = '';
  Map<String, dynamic> body = {};
  late double lat = 36;
  late double long = -2;
  bool locationMapDisplayed = false;
  bool location = false;

  var isLoading;

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  fillValues() async {
    try {
      setState(() {
        isLoading = LoadingAnimationWidget.horizontalRotatingDots(
          color: const Color.fromARGB(248, 186, 12, 47),
          size: 100,
        );
      });

      final response = await http.get(
        Uri.parse("${getUrl()}questions/bytablename/${widget.tbname}"),
      );

      List responseList = json.decode(response.body);

      setState(() {
        postList = responseList
            .map((data) => Item2(
                  Question: data["Required"] == "Yes"
                      ? "${data["Question"]} *"
                      : data["Question"],
                  QuestionType: data["QuestionType"],
                  Choices: data["Choices"],
                  Required: data["Required"],
                  Column: data["Column"],
                  DataType: data["DataType"],
                ))
            .toList();
      });

      postList.removeWhere((element) => element.QuestionType == "Location");

      for (dynamic item in responseList) {
        setState(() {
          body[item["Column"]] = '';
          if (item["Column"] == "geom") {
            body.remove('geom');
            setState(() {
              location = true;
            });
          }
          isLoading = null;
        });
      }
      getLocation();
    } catch (e) {
      setState(() {
        isLoading = null;
      });
    }
  }

  getLocation() async {
    print("get location");
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      long = position.longitude;
      lat = position.latitude;
      if (location == true) {
        body["Latitude"] = lat;
        body["Longitude"] = long;
      }
      print("form location: ${long}  $location");
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
  }

  @override
  void initState() {
    fillValues();

    super.initState();
  }

  double calculateListViewHeight() {
    return postList.length * 100.0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FormsTemplate',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          key: _scaffoldKey,
          drawer: const MyDrawer(),
          body: Stack(
            children: [
              Container(
                height: double.infinity,
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
                        height: 32,
                      ),
                      Center(
                        child: Text(
                          widget.toolname,
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      location
                          ? SizedBox(
                              height: 250,
                              child: MyMap(
                                lat: lat,
                                lon: long,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 8,
                      ),
                      postList.isNotEmpty
                          ? SingleChildScrollView(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: postList.length,
                                  itemBuilder: (context, index) {
                                    dynamic type = TextInputType.text;
                                    print(
                                        "questions ${postList[index].QuestionType}");

                                    switch (postList[index].DataType) {
                                      case "STRING":
                                        type = TextInputType.text;
                                        break;
                                      case "INTEGER":
                                        type = TextInputType.number;
                                        break;
                                      case "DECIMAL":
                                        type = TextInputType.number;
                                        break;
                                      case "DATE":
                                        type = TextInputType.datetime;
                                        break;

                                      default:
                                    }

                                    var lines = postList[index].QuestionType ==
                                            "Long Answer"
                                        ? 3
                                        : 1;

                                    // Always add required fields to questionsCheck with empty value
                                    if (postList[index].Required == "Yes") {
                                      questionsCheck.add({
                                        "required": postList[index].Required,
                                        "value": "",
                                      });
                                    }

                                    if (postList[index].QuestionType ==
                                        "Single Choice") {
                                      body[postList[index].Column] =
                                          postList[index].Choices[0];
                                      return CFormSelect(
                                        onSubmit: (v) {
                                          setState(() {
                                            body[postList[index].Column] = v;
                                          });
                                        },
                                        entries: postList[index].Choices,
                                        value: postList[index].Choices[0],
                                        label: postList[index].Question,
                                      );
                                    } else if (postList[index].QuestionType ==
                                        "Multiple Choice") {
                                      body[postList[index].Column] =
                                          postList[index].Choices[0];
                                      return CFormCheckBox(
                                        onSubmit: (v) {
                                          setState(() {
                                            body[postList[index].Column] = v;
                                          });
                                        },
                                        label: postList[index].Question,
                                        entries: postList[index].Choices,
                                        selectedValues: {
                                          postList[index].Choices[0]
                                        },
                                      );
                                    } else if (postList[index].QuestionType ==
                                        "Date") {
                                      return CFormDate(
                                        onSubmit: (v) {
                                          setState(() {
                                            body[postList[index].Column] = v;
                                            questionsCheck[index]['value'] = v;
                                          });
                                        },
                                        label: postList[index].Question,
                                        lines: lines,
                                        type: type,
                                      );
                                    } else {
                                      return CFormInput(
                                        label: postList[index].Question,
                                        lines: lines,
                                        // Pass the current value from body
                                        type: type,
                                        onSubmit: (v) {
                                          setState(() {
                                            body[postList[index].Column] = v;
                                            questionsCheck[index]['value'] =
                                                v; // Update questionsCheck with user input
                                          });
                                        },
                                      );
                                    }
                                  }),
                            )
                          : const SizedBox(
                              height: 300,
                            ),
                      TextResponse(
                        label: error,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SubmitButton(
                          label: "Send Form",
                          onButtonPressed: () async {
                            setState(() {
                              isLoading =
                                  LoadingAnimationWidget.horizontalRotatingDots(
                                color: const Color.fromARGB(248, 186, 12, 47),
                                size: 100,
                              );
                            });
                            var res = await submitData(
                              widget.tbname,
                              body,
                              questionsCheck,
                            );
                            setState(() {
                              isLoading = null;
                              if (res.error == null) {
                                error = res.success;
                              } else {
                                error = res.error;
                                return;
                              }
                            });
                            // change the error to no error
                            if (res.error == null) {
                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const CustomForms()));
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
              isLoading != null ? Center(child: isLoading) : const SizedBox()
            ],
          ),
        ));
  }
}

Future<Message> submitData(
  String tableName,
  dynamic body,
  List<Map<String, dynamic>> questionsCheck,
) async {
  print("custom forms: $tableName, $body, $questionsCheck");
  try {
    // if (hasEmptyValues(questionsCheck)) {
    //   return Message(
    //     token: null,
    //     success: null,
    //     error: "Please fill required empty fields",
    //   );
    // }

    final response = await http.post(
        Uri.parse("${getUrl()}toolslist/submittabledata/$tableName"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));

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

// bool hasEmptyValues(List<Map<String, dynamic>> questionsCheck) {
//   for (var check in questionsCheck) {
//     print("checks: $check");
//     if (check['required'] == 'Yes' &&
//         (check['value'] == null || check['value'] == '')) {
//       print("empty field");
//       return true;
//     }
//   }
//   print("all fields filled");
//   return false;
// }

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
