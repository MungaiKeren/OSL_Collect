// ignore_for_file: file_names, must_be_immutable
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wkwp_mobile/Components/DialogSubmit.dart';
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/TextSmall.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'package:wkwp_mobile/Pages/Home.dart';
import 'package:wkwp_mobile/Pages/ParticipantsList.dart';

class QRCodeDialog1 extends StatefulWidget {
  String activityID;
  QRCodeDialog1({super.key, required this.activityID});

  @override
  State<QRCodeDialog1> createState() => _QRCodeDialog1State();
}

class _QRCodeDialog1State extends State<QRCodeDialog1> {
  String erepname = '';
  String erepdesignation = '';
  var isLoading;
  String error = '';
  String userid = '';
  String wkwpname = '';
  String wkwpdesignation = '';

  final storage = const FlutterSecureStorage();

  Future<void> getUserInfo() async {
    var token = await storage.read(key: "WKWPjwt");
    var decoded = parseJwt(token.toString());

    setState(() {
      userid = decoded["UserID"];
      wkwpname = decoded["Name"];
      wkwpdesignation = decoded["Position"];
    });
    print("useridmy: $userid");
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        backgroundColor: Colors.transparent,
        content: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(3, 48, 110, 1),
                      Color.fromRGBO(0, 96, 177, 1)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    const Center(
                      child: Text(
                        "WKWP Representative",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const TextSmall(label: "wkwp rep name"),
                    MyTextInput(
                        lines: 1,
                        value: '',
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            erepname = value;
                          });
                        },
                        title: 'Entiry Representative'),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextSmall(label: "wkwp rep designation"),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          erepdesignation = value;
                        });
                      },
                      title: 'Entity Representative Designation',
                    ),
                    TextResponse(
                      label: error,
                    ),
                    Center(
                      child: isLoading ?? const SizedBox(),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    DialogSubmit(
                      label: "Submit",
                      onButtonPressed: () async {
                        setState(() {
                          isLoading =
                              LoadingAnimationWidget.horizontalRotatingDots(
                            color: Color.fromARGB(248, 186, 12, 47),
                            size: 100,
                          );
                        });
                        var res = await submitData(
                            erepname,
                            erepdesignation,
                            widget.activityID,
                            userid,
                            wkwpname,
                            wkwpdesignation);
                        setState(() {
                          isLoading = null;
                          if (res.error == null) {
                            error = res.success;
                          } else {
                            error = res.error;
                          }
                        });
                        // PROCEED TO NEXT PAGE
                        if (res.error == null) {
                          // Replace the current page with the dialog screen
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ParticipantsList(
                                        activityID: widget.activityID,
                                      )));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    DialogSubmit(
                      label: "Finish",
                      onButtonPressed: () async {
                        setState(() {
                          isLoading =
                              LoadingAnimationWidget.horizontalRotatingDots(
                            color: Color.fromARGB(248, 186, 12, 47),
                            size: 100,
                          );
                        });
                        // CLOSE TO HOME PAGE
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => const Home()));
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -50,
                right: -150,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Color.fromRGBO(0, 96, 177, 1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -120,
                left: -150,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(3, 48, 110, 1),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Message> submitData(String erepname, String erepdesignation, String id,
    String userid, String wkwpname, String wkwpdesignation) async {
  if (erepname.isEmpty || erepdesignation.isEmpty) {
    return Message(
      token: null,
      success: null,
      error: "Empty Field!!",
    );
  }

  try {
    print("myser: $userid");
    final response = await http.put(
      Uri.parse("${getUrl()}arf/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'ERepName': erepname,
        'ERepDesignation': erepdesignation,
        'WKWPRepSignature': userid,
        'WKWPRepName': wkwpname,
        'WKWPRepDesignation': wkwpdesignation,
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
