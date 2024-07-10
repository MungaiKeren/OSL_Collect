// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/TextSmall.dart';
import 'package:wkwp_mobile/Components/Utils.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ForgetPasswordDialogState();
}

class _ForgetPasswordDialogState extends State<ChangePasswordDialog> {
  String email = '';
  String oldpassword = '';
  String newpassword = '';
  dynamic isLoading;
  String error = '';
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromRGBO(3, 48, 110, 1),
            Color.fromRGBO(0, 96, 177, 1)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const TextSmall(label: "Old Password"),
              MyTextInput(
                lines: 1,
                value: '',
                type: TextInputType.phone,
                onSubmit: (value) {
                  setState(() {
                    oldpassword = value;
                  });
                },
                title: 'Old Password',
              ),
              const SizedBox(
                height: 16,
              ),
              const TextSmall(label: "New Password"),
              MyTextInput(
                lines: 1,
                value: '',
                type: TextInputType.phone,
                onSubmit: (value) {
                  setState(() {
                    newpassword = value;
                  });
                },
                title: 'New Password',
              ),
              Center(
                child: isLoading ?? const SizedBox(),
              ),
              // Display the loading animation when it's not null.
              const SizedBox(
                height: 16,
              ),
              TextResponse(
                label: error,
              ),
              SubmitButton(
                label: "Submit",
                onButtonPressed: () async {
                  setState(() {
                    isLoading = LoadingAnimationWidget.horizontalRotatingDots(
                      color: const Color.fromARGB(248, 186, 12, 47),
                      size: 100,
                    );
                  });
                  var res =
                      await changePassword(storage, oldpassword, newpassword);
                  setState(() {
                    isLoading = null;
                    if (res.error == null) {
                      error = res.success;
                      Timer(const Duration(seconds: 1), () {
                        Navigator.of(context).pop();
                      });
                    } else {
                      error = res.error;
                    }
                  });
                },
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Message> changePassword(FlutterSecureStorage storage, String oldpassword,
    String newpassword) async {
  if (oldpassword.isEmpty) {
    return Message(
      token: null,
      success: null,
      error: "Enter Old Password",
    );
  }

  if (newpassword.isEmpty) {
    return Message(
      token: null,
      success: null,
      error: "Enter New Password",
    );
  }

  try {
    var token = await storage.read(key: "WKWPjwt");
    var decoded = parseJwt(token.toString());

    var id = decoded["UserID"];
   
    final response = await http.put(
      Uri.parse("${getUrl()}mobile/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Password': oldpassword,
        'NewPassword': newpassword
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
  dynamic token;
  dynamic success;
  dynamic error;

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
