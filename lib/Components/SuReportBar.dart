// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Components/TextSmall.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Pages/WorkPlans.dart';

class SuReportBar extends StatefulWidget {
  final dynamic item;

  const SuReportBar({
    super.key,
    required this.item,
  });

  @override
  State<SuReportBar> createState() => _SuReportBar();
}

class _SuReportBar extends State<SuReportBar> {
  String my = '';
  String error = '';
  String Remarks = '';
  var isLoading;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.green,
                          Color.fromARGB(255, 29, 221, 163)
                        ],
                      ),
                    ),
                    child: Column(children: [
                      const Text(
                        "Farmer Details",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Name: " + widget.item["Name"],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "National ID: " + widget.item["NationalID"],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Phone: " + widget.item["Phone"],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Age Group: " + widget.item["AgeGroup"],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.orangeAccent],
                      ),
                    ),
                    child: Column(children: [
                      const Text(
                        "Field Officer Report",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Service: " + widget.item["Task"],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Extension Service: " + widget.item["Type"],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Date: " + widget.item["updatedAt"],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Remarks  \n - " + widget.item["Remarks"],
                          style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              color: Colors.yellowAccent),
                        ),
                      ),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                  child: Column(children: [
                    const Text(
                      "Supervisor Remarks",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextSmall(label: 'Remarks'),
                    MyTextInput(
                      lines: 8,
                      value: '',
                      type: TextInputType.text,
                      title: 'Remarks',
                      onSubmit: (value) {
                        setState(() {
                          Remarks = value;
                          error = '';
                        });
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SubmitButton(
                        label: "Submit",
                        onButtonPressed: () async {
                          setState(() {
                            error = '';
                            isLoading =
                                LoadingAnimationWidget.horizontalRotatingDots(
                              color: Color.fromARGB(248, 186, 12, 47),
                              size: 100,
                            );
                          });

                          var res =
                              await sendReport(widget.item["ID"], Remarks);

                          setState(() {
                            isLoading = null;
                            if (res.error == null) {
                              error = res.success;
                            } else {
                              error = res.error;
                            }
                          });

                          if (res.error == null) {
                            Timer(const Duration(seconds: 1), () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => WorkPlan()));
                            });
                          }
                        }),
                    Center(
                      child: TextButton(
                          onPressed: () async {
                            setState(() {
                              error = '';
                              isLoading =
                                  LoadingAnimationWidget.horizontalRotatingDots(
                                color: Color.fromARGB(248, 186, 12, 47),
                                size: 100,
                              );
                            });

                            var res = await rejectReport(widget.item["ID"]);

                            setState(() {
                              isLoading = null;
                              if (res.error == null) {
                                error = res.success;
                              } else {
                                error = res.error;
                              }
                            });

                            if (res.error == null) {
                              Timer(const Duration(seconds: 1), () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => WorkPlan()));
                              });
                            }
                          },
                          child: Text(
                            "Reject Report",
                            style: TextStyle(color: Colors.deepOrangeAccent),
                          )),
                    )
                  ]),
                ),
              ],
            )),
        Center(child: isLoading),
      ],
    );
  }
}

Future<Message> sendReport(String id, String Remarks) async {
  if (Remarks == '') {
    return Message(
        token: null, success: null, error: "Please fill all fields!");
  }

  try {
    final response = await http.put(
      Uri.parse("${getUrl()}workplan/${id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Status': true,
        'SupervisorRemarks': Remarks,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 203) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      return Message(
        token: null,
        success: null,
        error: "Connection to server failed!",
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

Future<Message> rejectReport(String id) async {
  try {
    final response = await http.put(
      Uri.parse("${getUrl()}workplan/${id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Status': false,
        'FarmerID': null,
        'Tally': 0,
        'Remarks': null,
        'Longitude': null,
        'Latitude': null
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 203) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      return Message(
        token: null,
        success: null,
        error: "Connection to server failed!",
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
