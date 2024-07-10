// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/MySelectInput.dart';
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/TextSmall.dart';
import 'package:wkwp_mobile/Components/UserContainer.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Pages/ParticipantsList.dart';

class ARFAddParticipant extends StatefulWidget {
  final String activityID;

  const ARFAddParticipant({super.key, required this.activityID});

  @override
  State<ARFAddParticipant> createState() => _ARFAddParticipantState();
}

class _ARFAddParticipantState extends State<ARFAddParticipant> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();

  String error = '';
  String name = '';
  String organization = '';
  String email = '';
  String type = '';
  String pwd = '';
  String age = '';
  String gender = '';
  String phone = '';
  String description = '';

  var isLoading;

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ARFAddParticipant',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
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
                      height: 32,
                    ),
                    const Center(
                      child: Text(
                        "Bungoma County Rural\nWater Sensitization",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const TextSmall(label: "Full Name"),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      title: 'Name',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextSmall(label: "Organisation/Group"),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          organization = value;
                        });
                      },
                      title: 'Organisation/Group of the Participant',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextSmall(label: "Email Address"),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.emailAddress,
                      onSubmit: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      title: 'Email Address',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextSmall(label: "Phone Number"),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.phone,
                      onSubmit: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                      title: '07...',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextSmall(label: "PWD"),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          pwd = value;
                        });
                      },
                      title: 'Yes',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextSmall(label: "Age"),
                    MySelectInput(
                        onSubmit: (value) {
                          setState(() {
                            age = value;
                          });
                        },
                        list: const [
                      "Select",
                        "15-29", "30 and above"],
                        value: age, label: '',),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextSmall(label: "Gender"),
                    MySelectInput(
                        onSubmit: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        list: const [
                      "Select",
                        "Male", "Female"],
                        value: gender, label: '',),
                    const SizedBox(
                      height: 24,
                    ),
                    TextResponse(
                      label: error,
                    ),
                    Center(
                      child: isLoading ?? const SizedBox(),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SubmitButton(
                        label: "Next ->",
                        onButtonPressed: () async {
                                    setState(() {
                            isLoading =
                                LoadingAnimationWidget.horizontalRotatingDots(
                              color: Color.fromARGB(248, 186, 12, 47),
                              size: 100,
                            );
                          });
                          var res = await submitData(widget.activityID, name,
                              organization, email, phone, pwd, age, gender);
                          setState(() {
                            isLoading = null;
                            if (res.error == null) {
                              error = res.success;
                            } else {
                              error = res.error;
                            }
                          });
                          // change the error to no error
                          if (res.error == null) {
                            // PROCEED TO NEXT PAGE
                            Timer(const Duration(seconds: 1), () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ParticipantsList(
                                          activityID: widget.activityID)));
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
          ),
        ));
  }
}

Future<Message> submitData(
  String activityID,
  String name,
  String organization,
  String email,
  String phone,
  String pwd,
  String age,
  String gender,
) async {
  if (activityID.isEmpty ||
      name.isEmpty ||
      organization.isEmpty ||
      email.isEmpty ||
      phone.isEmpty ||
      pwd.isEmpty ||
      age.isEmpty ||
      gender.isEmpty) {
    return Message(
      token: null,
      success: null,
      error: "All Fields Must Be Filled!",
    );
  }

  try {
    final response = await http.post(
      Uri.parse("${getUrl()}participants/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'ActivityID': activityID,
        'ParticipantName': name,
        'Organization': organization,
        'Email': email,
        'Phone': phone,
        'PWD': pwd,
        'Age': age,
        'Gender': gender
      }),
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
